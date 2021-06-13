import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';
import 'package:education_assistant/cubit/users/users_state.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/screens/home_screen/screens/add_teacher_screen/add_teacher_screen.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({Key key}) : super(key: key);

  @override
  _TeachersScreenState createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  UsersCubit usersCubit;
  UserModel currentUser;

  @override
  void initState() {
    currentUser = BlocProvider.of<AuthCubit>(context).state.currentUser;
    usersCubit = BlocProvider.of<UsersCubit>(context);
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
      actions: <Widget>[
        if (currentUser.role == UserRole.admin)
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              NavigationUtils.toScreen(context, screen: AddTeacherScreen());
            },
          ),
      ],
    );
  }

  Widget buildBody() {
    return BlocBuilder<UsersCubit, UsersState>(
      bloc: usersCubit,
      builder: (context, usersState) {
        if (usersState.isLoading) return WidgetUtils.showLoading();

        final teachers =
            usersState.teachers.where((e) => e.id != currentUser.id).toList();

        return ListView.builder(
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
                  if (currentUser.role == UserRole.admin) {
                    showAlterDialog(teacher.id);
                  }
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
                    await usersCubit.updateTeacher(teacherId);
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
