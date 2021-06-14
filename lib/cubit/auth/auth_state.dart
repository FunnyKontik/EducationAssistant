import 'package:education_assistant/models/user_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
class AuthState {
  final UserModel currentUser;
  final bool isLoading;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
  });

  AuthState copyWith({UserModel currentUser, bool isLoading}) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
