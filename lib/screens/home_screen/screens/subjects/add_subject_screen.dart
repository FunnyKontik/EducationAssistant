import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/cubit/subjects/subjects_cubit.dart';
import 'package:education_assistant/cubit/subjects/subjects_state.dart';
import 'package:education_assistant/custom_widgets/custom_text_field.dart';
import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/services/subject_service.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key key}) : super(key: key);

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  SubjectsCubit subjectsCubit;

  @override
  void initState(){
    subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> teacherIds = [];

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
                            subjectsCubit.addSubject(
                                subjectNameController.text,
                                subjectDescController.text,
                                double.parse(subjectCreditsController.text),
                                double.parse(subjectHoursController.text),
                                teacherIds);
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
    return BlocBuilder<SubjectsCubit,SubjectState>(
      bloc: subjectsCubit,
      builder: (context, subjectState) {
        if(subjectState.isLoading){
          return WidgetUtils.showLoading();
        }
        final subjects = subjectState.subjects.toList();

        return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (_, index) {
            final subject = subjects[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(subject.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    subjectsCubit.deleteSubject(subject);
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
