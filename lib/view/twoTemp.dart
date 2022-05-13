import 'package:flutter/material.dart';
import 'package:vir_assistant/view/twoTempbody.dart';

class TwoTemp extends StatelessWidget {
  const TwoTemp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Defects'),
          centerTitle: true,
        ),
        body: Padding(padding: EdgeInsets.all(10), child: TwoTempBody()));
  }
}
