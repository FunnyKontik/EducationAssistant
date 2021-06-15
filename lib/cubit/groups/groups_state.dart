import 'package:education_assistant/models/group_model.dart';
import 'package:education_assistant/models/subject_model.dart';

class GroupsState{

  final List<GroupModel> allGroups;
  final bool isLoading;

  const GroupsState({
    this.allGroups = const [],
    this.isLoading = true,
});

  List<GroupModel> get groups{
    return allGroups;
  }

  List<String> getStudentsIds(String groupId) {
    var ids = <String>[];

    for (int i = 0; i < allGroups.length; i++) {
      if (allGroups[i].id == groupId) ids = allGroups[i].usersIds;
    }

    return ids;
  }

  List<String> getSubjectsIds(String groupId) {
    var ids = <String>[];

    for (int i = 0; i < allGroups.length; i++) {
      if (allGroups[i].id == groupId) ids = allGroups[i].subjectsIds;
    }

    return ids;
  }

  GroupsState copyWith({
    bool isLoading,
    List<GroupModel> allGroups,
  }) {
    return GroupsState(
      isLoading: isLoading ?? this.isLoading,
      allGroups: allGroups ?? this.allGroups,
    );
  }

}