import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_resume_builder/widgets/form_text_field.dart';

class ResumeBuilderSplitView extends StatelessWidget {
  const ResumeBuilderSplitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              Text("Resume Builder"),
              SizedBox(width: 15),
              Text(
                "Powered by Flutter",
                style: TextStyle(fontSize: 15, color: Colors.white30),
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: Row(
          children: [
            form(),
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            )
          ],
        ));
  }

  Widget form() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: FormBuilder(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text('Contact Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          FormTextField(
            label: 'Name',
          ),
          FormTextField(
            label: 'Location',
          ),
        ],
      )),
    ));
  }
}
