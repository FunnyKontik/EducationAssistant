import 'dart:async';

import 'package:education_assistant/cubit/users/users_state.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  final _usersService = UsersService();
  StreamSubscription _usersSubscription;

  UsersCubit() : super(const UsersState());

  Future<void> loadInitialData() async {
    try {
      emit(state.copyWith(isLoading: true));
      _usersSubscription = _usersService.getAllUsers().listen(_updateUsers);
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _updateUsers(List<UserModel> users) {
    emit(state.copyWith(allUsers: users, isLoading: false));
  }

  Future<void> updateTeacher(String teacherId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _usersService.updateModerToUser(teacherId);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> updateUser(String userId) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _usersService.updateUserToModer(userId);
      emit(state.copyWith(isLoading: false));
    } catch (e, s) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void dispose() {
    _usersSubscription.cancel();
  }
}
