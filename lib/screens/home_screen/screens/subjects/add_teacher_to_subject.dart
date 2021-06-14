import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/subjects/subjects_cubit.dart';
import 'package:education_assistant/cubit/users/users_state.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/screens/home_screen/screens/add_teacher_screen/add_teacher_screen.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';

class AddTeacherToSubject extends StatefulWidget {
  final SubjectModel subjectModel;

  const AddTeacherToSubject({Key key, @required this.subjectModel})
      : super(key: key);

  @override
  _AddTeacherToSubjectState createState() => _AddTeacherToSubjectState();
}

class _AddTeacherToSubjectState extends State<AddTeacherToSubject> {
  UsersCubit usersCubit;
  UserModel currentUser;
  SubjectsCubit subjectsCubit;

  @override
  void initState() {
    currentUser = BlocProvider.of<AuthCubit>(context).state.currentUser;
    usersCubit = BlocProvider.of<UsersCubit>(context);
    subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: buildBody());
  }

  Widget appBar() {
    return AppBar(
      title: const Text('Викладачі'),
      centerTitle: true,
    );
  }

  Widget buildBody() {
    return BlocBuilder<UsersCubit, UsersState>(
      bloc: usersCubit,
      builder: (context, usersState) {
        if (usersState.isLoading) return WidgetUtils.showLoading();
        List<UserModel> teachers;

        if(widget.subjectModel.teachersIds == null){
          teachers = usersState.teachers;
        }
        else {
          teachers = usersState.teachers
              .where((e) => !widget.subjectModel.teachersIds.contains(e.id))
              .toList();
        }
        return ListView.builder(
          itemCount: teachers.length,
          itemBuilder: (_, index) {
            final teacher = teachers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: UserAvatar(user: teacher),
                title: Text(teacher.name),
                trailing: IconButton(
                    onPressed: () async {
                      print(teacher.id);
                      await subjectsCubit.addTeacherToSubject(
                          widget.subjectModel, teacher.id, );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add_outlined, color: Colors.grey)),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }
}
