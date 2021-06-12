import 'package:flutter/foundation.dart';

enum UserRole { admin, moder, user }

extension UserRoleStringExtension on UserRole {
  String get asString => describeEnum(this);
}
