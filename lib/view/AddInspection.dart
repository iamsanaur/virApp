import 'package:flutter/material.dart';
import 'package:vir_assistant/view/AddInspectionForm.dart';

class AddInspection extends StatelessWidget {
  const AddInspection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Inspection'),
          centerTitle: true,
        ),
        body: AddInspectionForm());
  }
}
