import 'package:education_assistant/models/user_model.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final UserModel user;

  const UserAvatar({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user.imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(90)),
        child: Image.network(user.imageUrl),
      );
    }
    return CircleAvatar(
      child: Center(
        child: Text(
          user.name[0].toUpperCase(),
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
