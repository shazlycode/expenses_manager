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

  Future<void> auth() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      if (authType == AuthType.login) {
        await context.read<AuthCubit>().login(
            email: emailController.text, password: passwordController.text);
      } else {
        await context.read<AuthCubit>().register(
            email: emailController.text, password: passwordController.text);
      }
    } catch (e) {
      showErrorMessage(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  Future<void> joinFamily() async {
    if (!familyCodeFormKey.currentState!.validate()) return;

    try {
      var snapshot =
          await FirebaseFirestore.instance.collection("families").get();

      var family = snapshot.docs.firstWhere(
        (doc) => doc['familyCode'] == familyCodeController.text,
        orElse: () => throw Exception("Family Profile Not Found"),
      );

      if (context.mounted) {
        Map<String, dynamic> familyInfo = {
          'familyName': family['familyName'],
          'familyCode': family['familyCode'],
          'familyId': family.id,
        };

        context.go(kHomeScreen, extra: familyInfo);
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  // joinFamily() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("families")
  //         .get()
  //         .then((snapshot) {
  //       QueryDocumentSnapshot<Map<String, dynamic>>? family =
  //           snapshot.docs.where((doc) {
  //         return doc.data()['familyCode'] == familyCodeController.text;
  //       }).first;
  //       if (family.exists && context.mounted) {
  //         context.go(kHomeScreen, extra: {
  //           'familyName': family['familyName'],
  //           'familyCode': family['familyCode'],
  //           'familyId': family.id,
  //         });
  //       } else {
  //         if (context.mounted) {
  //           showDialog(
  //               context: context,
  //               builder: (context) => AlertDialog(
  //                     content: Text("Family Profile Not Found"),
  //                   ));
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     if (context.mounted) {
  //       showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //                 content: Text(e.toString()),
  //               ));
  //     }
  //   }
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    familyNameController.dispose();
    familyCodeController.dispose();
    super.dispose();
  }

  String? initialValue;
  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilycreationCubit, FamilycreationState>(
      listener: (context, state) {
        if (state is FamilycreationSuccess) {
          // توجيه المستخدم مباشرة إلى الشاشة الرئيسية
          context.go(kHomeScreen, extra: {
            'familyName': state.familyName,
            'familyCode': state.familyCode,
            'familyId': state.familyId,
          });
        }
      },
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
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
              context.go(kFamilyScreen);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(kAppLogo,
                      fit: BoxFit.contain, height: 200, width: 200),
                  const SizedBox(height: 30),
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
                                  label: const Text("Email"),
                                  suffixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                            const SizedBox(height: 20),
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
                                  label: const Text("Password"),
                                  suffixIcon: const Icon(Icons.remove_red_eye),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: authType == AuthType.login
                                      ? "Don't have an account? "
                                      : "Have an account? "),
                              TextSpan(
                                  text: authType == AuthType.login
                                      ? "Register"
                                      : "Login",
                                  style: kStyle4.copyWith(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        authType = authType == AuthType.login
                                            ? AuthType.register
                                            : AuthType.login;
                                      });
                                    })
                            ])),
                            const SizedBox(height: 30),
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: auth,
                                    child: Text(authType == AuthType.login
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
      )),
    );
  }
}
