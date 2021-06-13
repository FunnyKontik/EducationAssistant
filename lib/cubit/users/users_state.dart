import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:meta/meta.dart';

@immutable
class UsersState {
  final List<UserModel> allUsers;
  final bool isLoading;

  const UsersState({
    this.allUsers = const [],
    this.isLoading = true,
  });

  List<UserModel> get teachers {
    return allUsers.where((e) => e.role != UserRole.user).toList();
  }

  List<UserModel> get admins {
    return allUsers.where((e) => e.role == UserRole.admin).toList();
  }

  List<UserModel> get users {
    return allUsers.where((e) => e.role == UserRole.user).toList();
  }

  UsersState copyWith({
    bool isLoading,
    List<UserModel> allUsers,
  }) {
    return UsersState(
      isLoading: isLoading ?? this.isLoading,
      allUsers: allUsers ?? this.allUsers,
    );
  }
}
