import 'dart:developer';
import 'dart:io';

import 'package:bhawani_tech_task/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:bhawani_tech_task/core/custom_widgets/custom_buttons.dart';
import 'package:bhawani_tech_task/core/custom_widgets/custom_text_feild.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' show Get, GetNavigation;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedRole = 'employee';

  File? selectedImage;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Let's get going!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Register an account to get started",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _signUpForm(),
              const SizedBox(height: 30),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  if (state is RegisterLoadingState) {
                    return const CircularProgressIndicator();
                  }
                  return CustomButton(
                    buttonText: 'Register',
                    onTap: () async {
                      // Validate the form and save the data if the form is valid
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Add the RegisterButtonTappedEvent to the RegisterBloc with the email, password, name and role as parameters
                        // This will trigger the RegisterButtonTappedEvent and call the on<RegisterButtonTappedEvent> method in the RegisterBloc
                        BlocProvider.of<RegisterBloc>(context).add(
                          RegisterButtonTappedEvent(
                            email: emailController.text,
                            password: passwordController.text,
                            name: nameController.text,
                            role: selectedRole,
                          ),
                        );
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: Colors.white,
          child: Center(
            child: RichText(
              text: const TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Log In',
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

  Widget _signUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          CustomTextFeild(
            text: 'Name',
            controller: nameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
            onSaved: (value) {
              // log(value.toString());
            },
          ),
          CustomTextFeild(
            text: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (EmailValidator.validate(value) == false) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) {
              // log(value.toString());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton(
                dropdownColor: Colors.white,
                value: selectedRole,
                items: ["admin", "manager", "employee"]
                    .map<DropdownMenuItem<String>>((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role.toUpperCase()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
              ),
            ),
          ),
          CustomTextFeild(
            text: 'Password',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            onSaved: (value) {
              // log(value.toString());
            },
          ),
        ],
      ),
    );
  }
}
