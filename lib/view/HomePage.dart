// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:open_file/open_file.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vir_assistant/view/AddInspection.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _inspectionBox = Hive.box('inspection');
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> data = [];

  late bool hasData = false;

  void _refreshItems() async {
    data = _inspectionBox.keys.map((key) {
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
  }

  void initialGetSaved() async {
    _refreshItems();
    if (data.isNotEmpty) {
      setState(() {
        hasData = true;
      });
    }
  }

  Future<void> _deleteItem(int itemKey) async {
    await _inspectionBox.delete(itemKey);
    _refreshItems();
    Get.snackbar('Deleted', 'Inspection has been deleted.',
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    initialGetSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => {Get.to(const AddInspection())},
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (_, i) {
              return Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => {
                    OpenFile.open(_items[i]['location'],
                        type: "application/pdf")
                  },
                  child: ListTile(
                    leading: Icon(Icons.build_circle),
                    title: Text(_items[i]['name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(_items[i]['key']),
                    ),
                    subtitle: Text(_items[i]['dateVIR']),
                  ),
                ),
              );
            }),
      )),
    );
  }
}
