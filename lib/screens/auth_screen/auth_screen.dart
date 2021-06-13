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

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
      appBar: AppBar(centerTitle: true, title: const Text('Авторизація')),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (_, state) {
        if (!state.isLoading && state.currentUser != null) {
          NavigationUtils.toScreenRemoveUntil(context, screen: HomeScreen());
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Забули пароль?'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomButton(
              content: 'Увійти',
              height: 70,
              width: 150,
              fontSize: 20,
              fontColor: Colors.white,
              color: Colors.blue,
              onPressed: () {},
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
              height: 1,
              width: 20,
              color: Colors.black38,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Text('Або', style: TextStyle(color: Colors.black38)),
            ),
            Container(
              height: 1,
              width: 20,
              color: Colors.black38,
            ),
          ]),
          SignWithCustomButton(
            backColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                return const Color.fromRGBO(222, 82, 70, 1);
              },
            ),
            fontColor: Colors.white,
            content: 'Увійти з Google',
            icon: 'assets/GoogleIcon.png',
            height: 47,
            onPressed: authCubit.googleSignIn,
          )
        ]),
      ),
    );
  }
}
