import 'package:education_assistant/models/group_model.dart';
import 'package:education_assistant/models/subject_model.dart';

class GroupsState{

  final List<GroupModel> allGroups;
  final bool isLoading;

  const GroupsState({
    this.allGroups = const [],
    this.isLoading = true,
});

  List<GroupModel> get models{
    return allGroups;
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