import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/services/user_service.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTeacherScreen extends StatefulWidget {
  @override
  _AddTeacherScreenState createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Додавання викладача'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
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
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.blueGrey,
                  onPressed: () {
                    userService.updateUserToModer(snapshot.data.docs[index].id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
