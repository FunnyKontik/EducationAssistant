import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/services/user_service.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class Teachers extends StatefulWidget {
  @override
  _TeachersState createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  UserService userService = UserService();
  StreamSubscription allUsersSubscription;
  List<UserModel> allUsers;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Викладачі'),
        centerTitle: true,
      ),
      body: buildBody(context, userService),
    );
  }
}

Widget buildBody(BuildContext context, UserService userService) {

  return StreamBuilder<QuerySnapshot>(
    stream: userService.getAllUsers(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong...'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return WidgetUtils.showLoading();
      }

      return ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (_, index) {
          final user = UserModel.fromMap(snapshot.data.docs[index].data());
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: UserAvatar(user: user),
              title: Text(user.name),
              trailing: Icon(Icons.info_outline, color: Colors.blueGrey),
              onTap: () {},
            ),
          );
        },
      );
    },
  );
}
