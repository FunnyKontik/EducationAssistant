import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/auth/auth_state.dart';
import 'package:education_assistant/screens/auth_screen/auth_screen.dart';
import 'package:education_assistant/screens/home_screen/home_screen.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:education_assistant/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthCubit authCubit;

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
    authCubit.checkCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (_, state) {
          if (!state.isLoading) {
            NavigationUtils.toScreenRemoveUntil(context,
                screen:
                    state.currentUser != null ? HomeScreen() : AuthScreen());
          }
        },
        child: Scaffold(body: WidgetUtils.showLoading()));
  }
}
