// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import 'package:vir_assistant/view/HomePage.dart';

import '../controllers/shipController.dart';

class ThreeTempBody extends StatefulWidget {
  const ThreeTempBody({Key? key}) : super(key: key);

  @override
  _ThreeTempBodyState createState() => _ThreeTempBodyState();
}

class _ThreeTempBodyState extends State<ThreeTempBody> {
  final _inspectionBox = Hive.box('inspection');
  final shipController = Get.put(ShipController());
  final defectName = TextEditingController();
  final defectDesc = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  List<String> imgAdd = [];
  bool firstImageAdded = false;
  bool secondImageAdded = false;
  @override
  void initState() {
    pdf.addPage(pw.Page(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Align(
              alignment: pw.Alignment.bottomCenter,
              child: pw.Center(
                  child: pw.Column(children: [
                pw.Text(shipController.shipName.value,
                    style: pw.TextStyle(
                      fontSize: 64,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Text(shipController.dateVir.value,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    )),
              ]))); // Center
        }));
    super.initState();
  }

  final pdf = pw.Document();

  Future storeInspectionData(name, dateVIR, location) async {
    final data = _inspectionBox.keys.map((key) {
      final value = _inspectionBox.get(key);
      return {
        "key": key,
        "name": value["name"],
        "dateVIR": value['dateVIR'],
        "location": value["location"]
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
    await _inspectionBox
        .add({'name': name, 'dateVIR': dateVIR, 'location': location});
  }

  final ImagePicker _picker = ImagePicker();
  _imgFromCamera(int i) async {
    try {
      if (firstImageAdded) {
        final XFile? photo = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 50);

        imgAdd.insert(1, photo!.path);
        setState(() {
          secondImageAdded = true;
        });
      } else {
        final XFile? photo = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 50);

        imgAdd.insert(0, photo!.path);
        setState(() {
          firstImageAdded = true;
        });
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  _imgFromGallery(int i) async {
    try {
      if (firstImageAdded) {
        final XFile? photo = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);

        imgAdd.insert(1, photo!.path);
        setState(() {
          secondImageAdded = true;
        });
      } else {
        final XFile? photo = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 50);

        imgAdd.insert(0, photo!.path);
        setState(() {
          firstImageAdded = true;
        });
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _showPicker(context, int ind) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(ind);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera(ind);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Add Defects Details',
                style: TextStyle(fontSize: 18),
              )),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: defectName,
            decoration: InputDecoration(
              labelText: 'Defect Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: defectDesc,
            decoration: InputDecoration(
              labelText: 'Defect Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showPicker(context, 0);
                  },
                  child: Text('Add Image 1'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showPicker(context, 1);
                  },
                  child: Text('Add Image 2'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              firstImageAdded
                  ? Image.file(
                      File(imgAdd[0]),
                      height: 180,
                      width: 180,
                    )
                  : SizedBox(
                      width: 10,
                      height: 50,
                    ),
              secondImageAdded
                  ? Image.file(File(imgAdd[1]), height: 180, width: 180)
                  : SizedBox(
                      width: 10,
                      height: 50,
                    )
            ],
          ),
          ElevatedButton(
              onPressed: () {
                final image1 =
                    pw.MemoryImage(File(imgAdd[0]).readAsBytesSync());
                final image2 =
                    pw.MemoryImage(File(imgAdd[1]).readAsBytesSync());
                pdf.addPage(pw.Page(
                    margin: pw.EdgeInsets.all(20),
                    orientation: pw.PageOrientation.landscape,
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Center(
                          child: pw.Column(children: [
                        pw.Text(defectName.text,
                            style: pw.TextStyle(fontSize: 24)),
                        pw.Text(defectDesc.text,
                            style: pw.TextStyle(fontSize: 18)),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Image(
                                image1,
                                height: 250,
                                width: 400,
                              ),
                              pw.Image(
                                image2,
                                height: 250,
                                width: 400,
                              )
                            ])
                      ]));
                    }));
                setState(() {
                  defectName.text = '';
                  defectDesc.text = '';
                  firstImageAdded = false;
                  secondImageAdded = false;
                });
                Get.snackbar('Added Page', '',
                    snackPosition: SnackPosition.BOTTOM);
              },
              child: Text('Add Defect')),
          SizedBox(
            height: 10,
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final output = await getApplicationDocumentsDirectory();
            final file = File('${output.path}/' +
                shipController.shipName.toString() +
                DateTime.now().toString() +
                '-VIR.pdf');
            await file.writeAsBytes(await pdf.save());
            Get.snackbar('PDF Generated', file.path,
                snackPosition: SnackPosition.BOTTOM);
            storeInspectionData(shipController.shipName.toString(),
                shipController.dateVir.toString(), file.path.toString());
            PdfPreview(
                build: (format) => pdf.save(),
                allowPrinting: true,
                allowSharing: true);
            Get.offAll(MyHomePage(title: 'Vessel Inspection'));
          } catch (e) {
            Get.snackbar('Error', e.toString(),
                snackPosition: SnackPosition.BOTTOM);
          }
        },
        child: Text('Finish'),
      ),
    );
  }
}
