import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/category.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({super.key});

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  List<Category> cat = [];

  getCatColor(String catName) {
    switch (catName) {
      case "Clothes":
        return Colors.green;
      case "Entertainment":
        return Colors.pink;
      case "Bill":
        return Colors.amber;
      case "Travel":
        return Colors.purple;
      case "Grocery":
        return const Color.fromARGB(255, 255, 177, 60);
      case "Car":
        return Colors.blue;
      case "Health":
        return Colors.teal;
      case "Education":
        return Colors.deepOrange;
      case "Others":
        return Colors.red;
      case "Food":
        return const Color.fromARGB(255, 73, 115, 58);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(children: [
        Expanded(
          flex: 2,
          child: SizedBox(
              width: 200,
              height: 200,
              child: PieChart(PieChartData(
                  sections: cat.map((e) {
                return PieChartSectionData(
                    value: e.catValue, showTitle: true, color: e.catColor);
              }).toList()))),
        ),
        Expanded(
            flex: 1,
            child: Column(
              children: cat.map((c) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      color: c.catColor,
                    ),
                    SizedBox(width: 5),
                    Text(c.catName!),
                  ],
                );
              }).toList(),
            ))
      ]),
    );
  }
}
