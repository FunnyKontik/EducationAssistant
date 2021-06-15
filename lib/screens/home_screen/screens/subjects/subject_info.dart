import 'package:education_assistant/cubit/subjects/subjects_cubit.dart';
import 'package:education_assistant/cubit/subjects/subjects_state.dart';
import 'package:education_assistant/cubit/users/users_state.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_teacher_to_subject.dart';

class SubjectInfo extends StatefulWidget {
  final SubjectModel subjectModel;

  const SubjectInfo({Key key, @required this.subjectModel}) : super(key: key);

  @override
  _SubjectInfoState createState() => _SubjectInfoState();
}

class _SubjectInfoState extends State<SubjectInfo> {
  UsersCubit usersCubit;
  SubjectsCubit subjectsCubit;

  @override
  void initState() {
    usersCubit = BlocProvider.of<UsersCubit>(context);
    subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
    // currentUser = authCubit.state.currentUser;
    // subjectTeachers = subjectsCubit.state.t

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectModel.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              NavigationUtils.toScreen(context,
                  screen: AddTeacherToSubject(
                    subjectModel: widget.subjectModel,
                  ));
            },
          )
        ],
        centerTitle: true,
      ),
      body: SubjectInfo(),
    );
  }

  Widget SubjectInfo() {
    return ListView(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Кiлькiсть годин: ${widget.subjectModel.hours}'),
                Text('Кiлькiсть кредитiв: ${widget.subjectModel.credits}'),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Опис:',
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              widget.subjectModel.desc,
              textAlign: TextAlign.start,
            ),
            const Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'Викладачi: ',
                textAlign: TextAlign.center,
              ),
            ),
            buildBody(),
          ],
        ),
      ),
    ]);
  }

  Widget buildBody() {
    return BlocBuilder<SubjectsCubit, SubjectState>(
      bloc: subjectsCubit,
      builder: (context, subjectState) {
        if (subjectState.isLoading) return WidgetUtils.showLoading();
        final teachers = usersCubit.state.teachers
            .where((e) => subjectState
                .getTeachersIds(widget.subjectModel.id)
                .contains(e.id))
            .toList();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: teachers.length,
          itemBuilder: (_, index) {
            final teacher = teachers[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: UserAvatar(user: teacher),
                title: Text(teacher.name),
                trailing: const Icon(Icons.info_outline, color: Colors.grey),
                onTap: () {},
                onLongPress: () {
                  showAlterDialog(teacher.id);
                },
              ),
            );
          },
        );
      },
    );
  }

  void showAlterDialog(String teacherId) {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Видалення викладача',
                  textAlign: TextAlign.center),
              content: const Text(
                'Ви дійсно хочете видалити викладача?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await subjectsCubit.removeTeacherFromSubject(
                        widget.subjectModel, teacherId);
                    Navigator.pop(context, 'Видалити');
                  },
                  child: const Text(
                    'Видалити',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Вiдмiнити'),
                  child: const Text('Вiдмiнити'),
                ),
              ],
            ));
  }
}
