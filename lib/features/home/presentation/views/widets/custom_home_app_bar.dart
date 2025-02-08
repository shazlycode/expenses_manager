import 'package:flutter/material.dart';

import '../../../../../core/utils/style.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key, required this.familyData});
  // final Map<String, dynamic> familyData;
  final String familyData;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: "Family", style: kStyle2.copyWith(color: Colors.white)),
          TextSpan(
              text: "Expenses",
              style: kStyle2.copyWith(color: Colors.blue[400])),
        ]))
      ],
    ));
  }
}
