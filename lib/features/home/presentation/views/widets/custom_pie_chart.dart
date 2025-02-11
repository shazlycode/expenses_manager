import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/cat_colors.dart';
import '../../../../../core/utils/category.dart';
import '../../../data/models/expense.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({super.key, required this.familyData});
  final Map<String, dynamic> familyData;

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  List<Category> cat = [];

  getCategoriesTotal(String? catName, Color catColor, double total) {
    List<Expense> clothList = widget.familyData['expenses']
        .where((e) => e.category == catName)
        .toList();

    for (var c in clothList) {
      total += c.amount;
    }

    cat.add(Category(catName: catName, catColor: catColor, catValue: total));
  }

  List<Category> getAllCats({required List<Expense> expenses}) {
    Map<String, dynamic> cats = {};
    expenses.map((e) {
      if (cats.keys.contains(e.category)) {
        cats[e.category!] = cats[e.category] + e.amount;
      } else {
        cats[e.category!] = e.amount;
      }
    }).toList();

    cat = cats.entries.map((e) {
      return Category(
          catName: e.key, catColor: getCatColor(e.key), catValue: e.value);
    }).toList();
    return cat;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeSuccess) {
            getAllCats(expenses: state.expenses);
            return Row(children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: PieChart(PieChartData(
                        sections: cat.map((e) {
                      return PieChartSectionData(
                          value: e.catValue,
                          showTitle: true,
                          color: e.catColor);
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: c.catColor,
                            ),
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text(c.catName!),
                        ],
                      );
                    }).toList(),
                  ))
            ]);
          } else if (state is HomeFailure) {
            return Center(child: Text(state.errorMessage));
          } else if (state is HomeLoading) {
            {
              return Center(child: CircularProgressIndicator());
            }
          } else {
            return Center(child: Container());
          }
        },
      ),
    );
  }
}
