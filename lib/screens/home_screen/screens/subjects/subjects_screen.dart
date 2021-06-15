import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_assistant/constants/enums/user_role.dart';
import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/subjects/subjects_cubit.dart';
import 'package:education_assistant/cubit/subjects/subjects_state.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';
import 'package:education_assistant/models/subject_model.dart';
import 'package:education_assistant/models/user_model.dart';
import 'package:education_assistant/screens/home_screen/screens/subjects/add_subject_screen.dart';
import 'package:education_assistant/screens/home_screen/screens/subjects/subject_info.dart';
import 'package:education_assistant/services/subject_service.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({Key key}) : super(key: key);

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  SubjectsCubit subjectsCubit;
  AuthCubit authCubit;
  UserModel userModel;

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
    subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
    userModel = authCubit.state.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: buildBody(),
    );
  }

  Widget appBar() {
    return AppBar(
      title: const Text('Предмети'),
      centerTitle: true,
      actions: <Widget>[
        if(!(authCubit.state.currentUser.role == UserRole.user))
        IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () {
            NavigationUtils.toScreen(context, screen: AddSubject());
          },
        )
      ],
    );
  }

  Widget buildBody() {
    return BlocBuilder<SubjectsCubit, SubjectState>(
      bloc: subjectsCubit,
      builder: (context, subjectState) {
        if (subjectState.isLoading) {
          return WidgetUtils.showLoading();
        }
        final subjects = subjectState.subjects;
        return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (_, index) {
            final subject = subjects[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                  title: Text(subject.name),
                  trailing: Icon(Icons.info_outline, color: Colors.blueGrey),
                  onTap: () {
                    NavigationUtils.toScreen(context,
                        screen: SubjectInfo(
                          subjectModel: subject,
                        ));
                  }),
            );
          },
        );
      },
    );
  }
}
