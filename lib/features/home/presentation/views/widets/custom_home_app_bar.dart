import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/app_router/app_router_constants.dart';
import '../../../../../core/utils/style.dart';

class CustomHomeAppBar extends StatefulWidget {
  const CustomHomeAppBar({super.key, required this.familyData});
  final Map<String, dynamic> familyData;

  @override
  State<CustomHomeAppBar> createState() => _CustomHomeAppBarState();
}

class _CustomHomeAppBarState extends State<CustomHomeAppBar> {
  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    await prefs.clear();
    if (mounted) {
      context.go(kAuthScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: "Family", style: kStyle2.copyWith(color: Colors.white)),
          TextSpan(
              text: "Expenses",
              style: kStyle2.copyWith(color: Colors.blue[400])),
        ])),
        const Spacer(),
        IconButton(
            onPressed: () => logOut(),
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
              size: 25,
            ))
      ],
    ));
  }
}
