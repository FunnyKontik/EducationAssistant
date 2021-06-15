import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:education_assistant/cubit/users/users_state.dart';
import 'package:education_assistant/models/group_model.dart';
import 'package:education_assistant/services/group_service.dart';

import 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final GroupService _groupService = GroupService();
  StreamSubscription _groupsSubscription;

  GroupsCubit() : super(const GroupsState());

  Future<void> loadInitialData() async {
    try {
      emit(state.copyWith(isLoading: true));
      _groupsSubscription = _groupService.getAllGroups().listen(_updateGroups);
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _updateGroups(List<GroupModel> groups) {
    emit(state.copyWith(allGroups: groups, isLoading: false));
  }

  Future<void> deleteGroup(GroupModel group) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _groupService.deleteGroup(group);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addGroup(String name) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _groupService.addGroup(name);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addStudentToGroup(
      GroupModel groupModel, String studentId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _groupService.addStudentToGroup(groupModel, studentId);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> removeStudentFromGroup(
      GroupModel groupModel, String studentId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _groupService.removeStudentFromGroup(groupModel, studentId);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> removeSubjectFromGroup(
      GroupModel groupModel, String subjectId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _groupService.removeSubjectFromGroup(groupModel, subjectId);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addSubjectToGroup(
      GroupModel groupModel, String subjectId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _groupService.addSubjectToGroup(groupModel, subjectId);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void dispose() {
    _groupsSubscription.cancel();
  }
}
