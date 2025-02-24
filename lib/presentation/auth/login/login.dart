import 'dart:developer';
import 'package:bhawani_tech_task/presentation/auth/login/bloc/login_bloc.dart';
import 'package:bhawani_tech_task/presentation/auth/register/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../custom_widgets/custom_buttons.dart';
import '../../../custom_widgets/custom_text_feild.dart';
import '../../dashboard/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _navigation();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _navigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('login') ?? false;
    if (isLoggedIn) {
      Get.offAll(() => const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 235, 213, 186),
                Color.fromARGB(255, 188, 173, 231),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            width: Get.width * 0.5,
            height: Get.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'HI, Welcome Back!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Hello again, you've been missed",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextFeild(
                    text: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      log(value.toString());
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (EmailValidator.validate(value) == false) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFeild(
                    text: 'Password',
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSaved: (value) {
                      log(value.toString());
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is LoginLoadingState) {
                        return const CircularProgressIndicator();
                      }
                      return CustomButton(
                        buttonText: 'Log In',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginButtonTappedEvent(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          Get.to(() => Register());
        },
        child: Container(
          width: Get.width,
          height: 50,
          color: Colors.white,
          child: Center(
            child: RichText(
              text: const TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Register',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
