import 'package:education_assistant/cubit/groups/groups_cubit.dart';
import 'package:education_assistant/cubit/groups/groups_state.dart';
import 'package:education_assistant/cubit/subjects/subjects_cubit.dart';
import 'package:education_assistant/models/group_model.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSubjectToGroup extends StatefulWidget {
  final GroupModel groupModel;

  const AddSubjectToGroup({Key key, @required this.groupModel})
      : super(key: key);

  @override
  _AddSubjectToGroupState createState() => _AddSubjectToGroupState();
}

class _AddSubjectToGroupState extends State<AddSubjectToGroup> {
  SubjectsCubit subjectsCubit;
  GroupsCubit groupsCubit;

  @override
  void initState() {
    subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
    groupsCubit = BlocProvider.of<GroupsCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Додавання предмету'),
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
          final subjects = subjectsCubit.state.subjects
              .where((e) => !groupsState.getSubjectsIds(groupId).contains(e.id))
              .toList();
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
                    onTap: () {
                      groupsCubit.addSubjectToGroup(
                          widget.groupModel, subject.id);
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
