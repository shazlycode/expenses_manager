import 'package:expenses_manager/core/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/style.dart';

enum AuthType { register, login }

class AuthScreenBody extends StatefulWidget {
  const AuthScreenBody({super.key});

  @override
  State<AuthScreenBody> createState() => _AuthScreenBodyState();
}

class _AuthScreenBodyState extends State<AuthScreenBody> {
  AuthType? authType;

  @override
  void initState() {
    authType = AuthType.login;
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     context.go(kHomeScreen);
    //   }
    // });
    super.initState();
  }

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  auth() async {
    if (!formKey.currentState!.validate()) {
      return;
    } else if (authType == AuthType.login) {
      setState(() {
        isLoading = true;
      });
    } else {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(kAppLogo, fit: BoxFit.contain, height: 200, width: 200),
            SizedBox(height: 30),
            Form(
                key: formKey,
                child: SizedBox(
                  height: 400,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            label: Text("Email"),
                            suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter a valid password";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.go,
                        obscureText: true,
                        decoration: InputDecoration(
                            label: Text("Password"),
                            suffixIcon: Icon(Icons.remove_red_eye),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                      SizedBox(height: 5),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: authType == AuthType.login
                                ? "Don't have account "
                                : "Have account "),
                        TextSpan(
                            text: authType == AuthType.login
                                ? "Register"
                                : "Login",
                            style: kStyle4.copyWith(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  authType == AuthType.login
                                      ? authType = AuthType.register
                                      : authType = AuthType.login;
                                });
                              })
                      ])),
                      SizedBox(height: 30),
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                auth();
                              },
                              child: isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : Text(authType == AuthType.login
                                      ? "Login"
                                      : "Register"))
                    ],
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
