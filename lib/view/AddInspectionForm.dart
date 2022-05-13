// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:vir_assistant/controllers/shipController.dart';
import 'package:vir_assistant/view/twoTemp.dart';

class AddInspectionForm extends StatefulWidget {
  const AddInspectionForm({Key? key}) : super(key: key);

  @override
  _AddInspectionFormState createState() => _AddInspectionFormState();
}

class _AddInspectionFormState extends State<AddInspectionForm> {
  final shipController = Get.put(ShipController());
  final _formKey = GlobalKey<FormState>();

  late String _setDate;

  late String _hour, _minute, _time;

  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    @override
    void initState() {
      _dateController.text = DateFormat.yMd().format(DateTime.now());

      super.initState();
    }

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
          height: _height,
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            labelText: 'Ship Name',
                            labelStyle: TextStyle(fontSize: 18),
                            prefixIcon: Icon(Icons.anchor)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Ship Name';
                          }
                          return null;
                        },
                      ),
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              width: _width,
                              height: _height / 20,
                              margin: EdgeInsets.only(top: 30),
                              alignment: Alignment.center,
                              decoration:
                                  BoxDecoration(color: Colors.grey[300]),
                              child: TextFormField(
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _dateController,
                                onSaved: (val) {
                                  _setDate = val!;
                                },
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    labelText: 'Choose Date',
                                    prefixIcon: Icon(Icons.date_range),
                                    labelStyle: TextStyle(fontSize: 18),
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.present_to_all,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Choose Template',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: _width,
                        height: _height / 3,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            InkWell(
                                child: Stack(children: [
                              Image.asset('./images/twoPictures.jpg'),
                              const Positioned(
                                left: 130,
                                top: 100,
                                child: Icon(Icons.check_circle,
                                    color: Colors.blueGrey, size: 30),
                              )
                            ])),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                child: Stack(children: [
                              Image.asset('./images/threePictures.jpg'),
                              const Positioned(
                                left: 130,
                                top: 100,
                                child: Icon(Icons.check_circle_outline_outlined,
                                    color: Colors.blueGrey, size: 30),
                              )
                            ])),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                shipController
                                    .updateShipName(_nameController.text);
                                shipController
                                    .updateDateVir(_dateController.text);
                                Get.to(() => TwoTemp());
                              }
                            },
                            child: Text('Add Inspection')),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
