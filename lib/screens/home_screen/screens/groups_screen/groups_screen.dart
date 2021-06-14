import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/subjects/groups_cubit.dart';
import 'package:education_assistant/cubit/subjects/groups_state.dart';
import 'package:education_assistant/models/group_model.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key key}) : super(key: key);

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  GroupModel groupModel;
  GroupsCubit groupsCubit;
  UserModel currentUser;

  @override
  void initState() {
    groupsCubit = BlocProvider.of<GroupsCubit>(context);
    currentUser = BlocProvider.of<AuthCubit>(context).state.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список груп'),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return BlocBuilder<GroupsCubit, GroupsState>(
      bloc: groupsCubit,
      builder: (context, groupsState) {
        if (groupsState.isLoading) return WidgetUtils.showLoading();

        final groups = groupsState.allGroups;

        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (_, index) {
            final group = groups[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(group.name),
                trailing: const Icon(Icons.info_outline, color: Colors.grey),
                onTap: () {},
                onLongPress: () {
                  if (currentUser.role == UserRole.admin) {
                    showAlterDialog(group);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  void showAlterDialog(GroupModel group) {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Видалення групи',
                  textAlign: TextAlign.center),
              content: const Text(
                'Ви дійсно хочете видалити групу?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await groupsCubit.deleteGroup(group);
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
