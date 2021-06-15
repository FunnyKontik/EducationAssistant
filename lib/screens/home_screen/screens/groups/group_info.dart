import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/groups/groups_cubit.dart';
import 'package:education_assistant/cubit/groups/groups_state.dart';
import 'package:education_assistant/cubit/subjects/subjects_cubit.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/group_model.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/screens/home_screen/screens/groups/add_student_to_group.dart';
import 'package:education_assistant/screens/home_screen/screens/groups/add_subject_to_group.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupInfo extends StatefulWidget {
  final GroupModel groupModel;

  const GroupInfo({Key key, @required this.groupModel}) : super(key: key);

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  UsersCubit usersCubit;
  SubjectsCubit subjectsCubit;
  GroupsCubit groupsCubit;
  AuthCubit authCubit;
  UserModel currentUser;

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
    usersCubit = BlocProvider.of<UsersCubit>(context);
    groupsCubit = BlocProvider.of<GroupsCubit>(context);
    subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
    currentUser = authCubit.state.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Інформація про групу'),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: ListView(
        children: <Widget>[
          Text(
            'Група: ${widget.groupModel.name}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            const Text(
              'Студенти групи:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            if(!(currentUser.role == UserRole.user))
            IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.blue,
                  size: 30,
                ),
                onPressed: () {
                  NavigationUtils.toScreen(context,
                      screen: AddStudentToGroup(groupModel: widget.groupModel));
                }),
          ]),
          showStudents(widget.groupModel.id),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            const Text(
              'Предмети, які вивчає група:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            if(!(currentUser.role == UserRole.user))
            IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.blue,
                  size: 30,
                ),
                onPressed: () {
                  NavigationUtils.toScreen(context,
                      screen: AddSubjectToGroup(groupModel: widget.groupModel));
                }),
          ]),
          showSubjects(widget.groupModel.id),
        ],
      ),
    );
  }

  Widget showStudents(String groupId) {
    return BlocBuilder<GroupsCubit, GroupsState>(
        bloc: groupsCubit,
        builder: (context, groupsState) {
          if (groupsState.isLoading) return WidgetUtils.showLoading();
          final students = usersCubit.state.users
              .where((e) => groupsState.getStudentsIds(groupId).contains(e.id))
              .toList();
          return ListView.builder(
              itemCount: students.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final student = students[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: UserAvatar(user: student),
                    title: Text(student.name),
                    trailing:
                        const Icon(Icons.info_outline, color: Colors.grey),
                    onTap: () {},
                    onLongPress: () {
                      if(!(currentUser.role == UserRole.user))
                        showStudentDeleteDialog(student.id);
                    },
                  ),
                );
              });
        });
  }

  Widget showSubjects(String groupId) {
    return BlocBuilder<GroupsCubit, GroupsState>(
        bloc: groupsCubit,
        builder: (context, groupsState) {
          if (groupsState.isLoading) return WidgetUtils.showLoading();
          final subjects = subjectsCubit.state.allSubjects
              .where((e) => groupsState.getSubjectsIds(groupId).contains(e.id))
              .toList();
          print(subjects.length);
          return ListView.builder(
              itemCount: subjects.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final subject = subjects[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(subject.name),
                    trailing:
                        const Icon(Icons.info_outline, color: Colors.grey),
                    onTap: () {},
                    onLongPress: () {
                      if(!(currentUser.role == UserRole.user))
                        showSubjectDeleteDialog(subject.id);
                    },
                  ),
                );
              });
        });
  }

  void showStudentDeleteDialog(String studentId) {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title:
                  const Text('Видалення студента', textAlign: TextAlign.center),
              content: const Text(
                'Ви дійсно хочете видалити студента з групи?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await groupsCubit.removeStudentFromGroup(
                        widget.groupModel, studentId);
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

  void showSubjectDeleteDialog(String subjectId) {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title:
                  const Text('Видалення предмету', textAlign: TextAlign.center),
              content: const Text(
                'Ви дійсно хочете видалити предмет з групи?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await groupsCubit.removeSubjectFromGroup(
                        widget.groupModel, subjectId);
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
