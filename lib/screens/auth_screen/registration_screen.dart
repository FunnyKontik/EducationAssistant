import 'package:education_assistant/cubit/auth/auth_cubit.dart';
import 'package:education_assistant/cubit/auth/auth_state.dart';
import 'package:education_assistant/custom_widgets/custom_button.dart';
import 'package:education_assistant/custom_widgets/custom_text_field.dart';
import 'package:education_assistant/custom_widgets/sign_with_button.dart';
import 'package:education_assistant/screens/home_screen/home_screen.dart';
import 'package:education_assistant/utils/navigation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  AuthCubit authCubit;

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(centerTitle: true, title: const Text('Реєстрацiя')),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (_, state) {
        if (!state.isLoading && state.currentUser != null) {
          NavigationUtils.toScreenRemoveUntil(context, screen: AuthScreen());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Image.asset('assets/logo.png', height: 80, width: 80),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Education',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: CustomTextInput(
              textEditingController: loginController,
              title: 'Логін',
            ),
          ),
          CustomTextInput(
            textEditingController: passwordController,
            title: 'Пароль',
            isPassword: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
            child: SignWithCustomButton(
              backColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
                  return const Color.fromRGBO(0, 96, 255, 1);
                },
              ),
              fontColor: Colors.white,
              content: 'Зареєструватися',
              icon: '',
              height: 47,
              onPressed: () {
                authCubit.firebaseRegistration(
                    loginController.text, passwordController.text);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
