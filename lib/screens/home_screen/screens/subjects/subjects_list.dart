import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/screens/home_screen/screens/subjects/add_subject_screen.dart';
import 'package:education_assistant/services/subject_service.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  SubjectService subjectService = SubjectService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Предмети'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              NavigationUtils.toScreen(context, screen: AddSubject());
            },
          )
        ],
      ),
      body: buildBody(context, subjectService),
    );
  }
}

Widget buildBody(BuildContext context, SubjectService subjectService) {

  return StreamBuilder<QuerySnapshot>(
    stream: subjectService.getSubjects(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong...'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return WidgetUtils.showLoading();
      }

      return ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (_, index) {
          final subject = SubjectModel.fromMap(snapshot.data.docs[index].data());
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(subject.name),
              trailing: Icon(Icons.info_outline, color: Colors.blueGrey),
              onTap: () {

              },
            ),
          );
        },
      );
    },
  );
}
