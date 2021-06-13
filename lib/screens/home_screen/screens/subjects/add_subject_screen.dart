import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/custom_widgets/custom_text_field.dart';
import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/services/subject_service.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key key}) : super(key: key);

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {


  @override
  Widget build(BuildContext context) {
    SubjectService subjectService = SubjectService();
    TextEditingController subjectNameController = TextEditingController();
    TextEditingController subjectCreditsController = TextEditingController();
    TextEditingController subjectHoursController = TextEditingController();
    TextEditingController subjectDescController = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    scrollable: true,
                    title: const Text('Додавання предмету'),
                    content: Column(
                      children: [
                        CustomTextInput(
                          title: 'Введiть назву предмету',
                          textEditingController: subjectNameController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20,bottom: 20),
                          child: CustomTextInput(
                            title: 'Введiть кредити',
                            textEditingController: subjectCreditsController,
                          ),
                        ),
                        CustomTextInput(
                          title: 'Введiть години',
                          textEditingController: subjectHoursController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: CustomTextInput(
                            title: 'Введiть опис предмету',
                            textEditingController: subjectDescController,
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Вiдмiнити'),
                        child: const Text('Вiдмiнити'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (subjectNameController.text.length > 0) {
                            subjectService.addSubject(
                                subjectNameController.text,
                                subjectDescController.text,
                                double.parse(subjectCreditsController.text),
                                double.parse(subjectHoursController.text));
                          }
                          Navigator.pop(context, 'Додати');
                        },
                        child: const Text('Додати'),
                      ),
                    ],
                  ),
            ),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Додавання предмету'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    SubjectService subjectService = SubjectService();

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
            final subject =
            SubjectModel.fromMap(snapshot.data.docs[index].data());
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(subject.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    subjectService.deleteSubject(snapshot.data.docs[index].id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
