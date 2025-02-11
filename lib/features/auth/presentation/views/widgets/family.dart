import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/app_router/app_router_constants.dart';
import '../../view_model/familycreation_cubit/familycreation_cubit.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  final familyFormKey = GlobalKey<FormState>();
  final familyCodeFormKey = GlobalKey<FormState>();
  final familyNameController = TextEditingController();
  final familyCodeController = TextEditingController();

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

      if (mounted) {
        Map<String, dynamic> familyInfo = {
          'familyName': family['familyName'],
          'familyCode': family['familyCode'],
          'familyId': family.id,
        };
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("hasFamily", true);
        await prefs.setString("familyName", family['familyName']);
        await prefs.setString("familyCode", family['familyCode']);
        await prefs.setString("familyId", family.id);
        if (mounted) {
          context.go(kHomeScreen, extra: familyInfo);
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    context.read<FamilycreationCubit>().checkFamily();
  }

  @override
  void dispose() {
    familyNameController.dispose();
    familyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilycreationCubit, FamilycreationState>(
      listener: (context, state) {
        if (state is FamilycreationSuccess) {
          Map<String, dynamic> familyInfo = {
            'familyName': state.familyName,
            'familyCode': state.familyCode,
            'familyId': state.familyId,
          };
          context.go(kHomeScreen, extra: familyInfo);
        }
      },
      child: Scaffold(
          body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Join Family!!!"),
            Form(
              key: familyCodeFormKey,
              child: TextFormField(
                // initialValue: initialValue,
                controller: familyCodeController,
                decoration: InputDecoration(
                    hintText: "Enter family code",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  joinFamily();
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
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await createFamily();
                },
                child:
                    // state is FamilycreationLoading
                    //     ? Center(
                    //         child: CircularProgressIndicator(),
                    //       )
                    //     :

                    Text("Create Family Profile")),
          ],
        ),
      )),
    );
  }
}
