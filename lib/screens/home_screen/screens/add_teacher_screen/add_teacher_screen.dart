import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/auth/auth_state.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';
import 'package:education_assistant/cubit/users/users_state.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/services/user_service.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({Key key}) : super(key: key);


  @override
  _AddTeacherScreenState createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  UserModel currentUser;
  UsersCubit usersCubit;

  @override
  void initState() {
    currentUser = BlocProvider.of<AuthCubit>(context).state.currentUser;
    usersCubit = BlocProvider.of<UsersCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Додавання викладача'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return BlocBuilder<UsersCubit, UsersState>(
      //stream: userService.getAllUsers(),
      bloc: usersCubit,
      builder: (context, usersState) {
        if (usersState.isLoading) return WidgetUtils.showLoading();

        final users =
            usersState.users.where((e) => e.id != currentUser.id).toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) {
            final user = users[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: UserAvatar(user: user),
                title: Text(user.name),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.blueGrey,
                  onPressed: () async {
                    await usersCubit.updateUser(user.id);
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
