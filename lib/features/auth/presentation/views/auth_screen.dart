import 'package:flutter/material.dart';

import 'widgets/auth_screen_body.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenBody(),
    );
  }
}
