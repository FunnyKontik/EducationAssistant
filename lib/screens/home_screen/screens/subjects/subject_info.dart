import 'package:education_assistant/models/subject_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubjectInfo extends StatefulWidget {
  final SubjectModel subjectModel;

  const SubjectInfo({Key key, @required this.subjectModel}) : super(key: key);

  @override
  _SubjectInfoState createState() => _SubjectInfoState();
}

class _SubjectInfoState extends State<SubjectInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectModel.name),
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Кiлькiсть годин: ' +
                      widget.subjectModel.hours.toString()),
                  Text('Кiлькiсть кредитiв: ' +
                      widget.subjectModel.credits.toString()),
                ],
              ),
              const Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  'Опис:',
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                widget.subjectModel.desc,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
