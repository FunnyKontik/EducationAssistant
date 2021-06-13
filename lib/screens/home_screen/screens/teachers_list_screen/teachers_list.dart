import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:education_assistant/custom_widgets/custom_text_field.dart';
import 'package:education_assistant/custom_widgets/user_avatar.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/screens/home_screen/screens/add_teacher_screen/add_teacher_screen.dart';
import 'package:education_assistant/services/user_service.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class Teachers extends StatefulWidget {
  final UserModel currentUser;

  const Teachers({Key key, @required this.currentUser}) : super(key: key);

  @override
  _TeachersState createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  UserService userService = UserService();

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
        actions: <Widget>[
          if(widget.currentUser.role == UserRole.admin)
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            onPressed: () {
              NavigationUtils.toScreen(context, screen: AddTeacherScreen());
            },
          ),
        ],
      ),
      body: buildBody(context, userService, widget.currentUser),
    );
  }
}

Widget buildBody(
    BuildContext context, UserService userService, UserModel currentUser) {
  var userService = UserService();

  return StreamBuilder<QuerySnapshot>(
    stream: userService.getTeachers(),
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
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
                onPressed: () {
                  // userService.deleteUser(snapshot.data.docs[index].id);
                },
              ),
              onTap: () {},
              onLongPress: () {
                if (currentUser.role == UserRole.admin) {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                              'Видалення викладача',
                              textAlign: TextAlign.center,
                            ),
                            content: const Text(
                              'Ви дійсно хочете видалити викладача?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  userService.updateModerToUser(
                                      snapshot.data.docs[index].id);
                                  Navigator.pop(context, 'Видалити');
                                },
                                child: const Text(
                                  'Видалити',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Вiдмiнити'),
                                child: const Text('Вiдмiнити'),
                              ),
                            ],
                          ));
                }
              },
            ),
          );
        },
      );
    },
  );
}
