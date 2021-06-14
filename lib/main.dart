import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/subjects/subjects_cubit.dart';
import 'package:education_assistant/cubit/users/users_cubit.dart';
import 'package:education_assistant/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/subjects/groups_cubit.dart';

void main() {
  ApplicationRunner().run();
}

class ApplicationRunner {
  Future<void> initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  Future<void> run() async {
    await initApp();
    runApp(MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<UsersCubit>(create: (_) => UsersCubit()),
        BlocProvider<GroupsCubit> (create: (_) => GroupsCubit()),
        BlocProvider<SubjectsCubit>(create: (_) => SubjectsCubit()),
      ],
      child: MaterialApp(
        title: 'Education Assistant',
        theme: ThemeData(primaryColor: Colors.blue),
        home: SplashScreen(),
      ),
    );
  }
}
