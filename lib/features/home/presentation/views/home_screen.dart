import 'package:flutter/material.dart';

import 'widets/custom_fab.dart';
import 'widets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.familyData});
  final Map<String, dynamic> familyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFab(),
      body: HomeScreenBody(familyData: familyData),
    );
  }
}
