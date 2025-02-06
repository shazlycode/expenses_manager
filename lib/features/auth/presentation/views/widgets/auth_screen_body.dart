import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/core/app_router/app_router_constants.dart';
import 'package:expenses_manager/core/utils/constants.dart';
import 'package:expenses_manager/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:expenses_manager/features/auth/presentation/view_model/familycreation_cubit/familycreation_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final familyFormKey = GlobalKey<FormState>();
  final familyCodeFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final familyNameController = TextEditingController();
  final familyCodeController = TextEditingController();

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  auth() async {
    if (!formKey.currentState!.validate()) {
      return;
    } else if (authType == AuthType.login) {
      setState(() {
        isLoading = true;
      });

      await context.read<AuthCubit>().login(
          email: emailController.text, password: passwordController.text);
    } else {
      await context.read<AuthCubit>().register(
          email: emailController.text, password: passwordController.text);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> createFamily() async {
    if (!familyFormKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    await context
        .read<FamilycreationCubit>()
        .createFamilyProfile(familyName: familyNameController.text);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    familyNameController.dispose();
    familyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                state.errorMessage,
                style: kStyle4,
              ),
              backgroundColor: Colors.red,
            ));
          } else if (state is AuthSuccess) {
            showDialog(
                context: context,
                builder: (context) {
                  return BlocConsumer<FamilycreationCubit, FamilycreationState>(
                    listener: (context, state) {
                      if (state is FamilycreationSuccess) {
                        context.go(kHomeScreen, extra: {
                          'familyName': state.familyName,
                          'familyCode': state.familyCode
                        });
                      } else if (state is FamilycreationFalure) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.errorMessage),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    builder: (context, state) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Join Family!!!"),
                              Form(
                                key: familyCodeFormKey,
                                child: TextFormField(
                                  controller: familyCodeController,
                                  decoration: InputDecoration(
                                      hintText: "Enter family code",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection("families")
                                          .get()
                                          .then((snapshot) {
                                        QueryDocumentSnapshot<
                                                Map<String, dynamic>>? family =
                                            snapshot.docs.where((doc) {
                                          return doc.data()['familyCode'] ==
                                              familyCodeController.text;
                                        }).first;
                                        if (family.exists || context.mounted) {
                                          context.go(kHomeScreen, extra: {
                                            'familyName': family['familyName'],
                                            'familyCode': family['familyCode']
                                          });
                                        } else {
                                          if (context.mounted) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      content: Text(
                                                          "Family Profile Not Found"),
                                                    ));
                                          }
                                        }
                                      });
                                    } catch (e) {
                                      if (context.mounted) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  content: Text(e.toString()),
                                                ));
                                      }
                                    }
                                  },
                                  child: Text("Join Family")),
                              SizedBox(height: 30),
                              Text("Craete a new family profile?"),
                              Form(
                                key: familyFormKey,
                                child: TextFormField(
                                  controller: familyNameController,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return "Enter Family Name";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Enter family Name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await createFamily();
                                  },
                                  child: state is FamilycreationLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Text("Create Family Profile")),
                            ],
                          ),
                        );
                      });
                    },
                  );
                });
            // context.go(kHomeScreen);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(kAppLogo,
                    fit: BoxFit.contain, height: 200, width: 200),
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
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Text(authType == AuthType.login
                                          ? "Login"
                                          : "Register"))
                        ],
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    ));
  }
}
