import 'package:expenses_manager/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_router/app_router_constants.dart';

class SplashScreenBody extends StatelessWidget {
  const SplashScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      if (context.mounted) {
        context.go(kAuthScreen);
      }
    });
    return SafeArea(
        child: Center(
      child: Image.asset(
        kAppLogo,
        fit: BoxFit.fill,
      ),
    ));
  }
}
