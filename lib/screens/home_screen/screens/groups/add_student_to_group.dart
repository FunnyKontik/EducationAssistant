import 'package:education_assistant/cubit/groups/groups_cubit.dart';
import 'package:education_assistant/cubit/groups/groups_state.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/group_model.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStudentToGroup extends StatefulWidget {
  final GroupModel groupModel;

  const AddStudentToGroup({Key key, @required this.groupModel})
      : super(key: key);

  @override
  _AddStudentToGroupState createState() => _AddStudentToGroupState();
}

class _AddStudentToGroupState extends State<AddStudentToGroup> {
  UsersCubit usersCubit;
  GroupsCubit groupsCubit;

  @override
  void initState() {
    usersCubit = BlocProvider.of<UsersCubit>(context);
    groupsCubit = BlocProvider.of<GroupsCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Додавання студента'),
        centerTitle: true,
      ),
      body: buildBody(widget.groupModel.id),
    );
  }

  Widget buildBody(String groupId) {
    return BlocBuilder<GroupsCubit, GroupsState>(
        bloc: groupsCubit,
        builder: (context, groupsState) {
          if (groupsState.isLoading) return WidgetUtils.showLoading();
          final students = usersCubit.state.users
              .where((e) => !groupsState.getStudentsIds(groupId).contains(e.id))
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
                    onTap: () {
                      groupsCubit.addStudentToGroup(
                          widget.groupModel, student.id);
                    },
                    onLongPress: () {
                      //showAlterDialog(teacher.id);
                    },
                  ),
                );
              });
        });
  }
}
