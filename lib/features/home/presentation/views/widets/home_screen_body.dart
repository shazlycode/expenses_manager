import 'package:expenses_manager/features/home/data/repo/home_repo_imp.dart';
import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'budget_expenses_card.dart';
import 'custom_home_app_bar.dart';
import 'custom_pie_chart.dart';
import 'expenses_list.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key, required this.familyData});
  // final Map<String, dynamic> familyData;
  final String familyData;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit(HomeRepoImp())..fetchExpenses(familyId: familyData),
      // ..fetchExpenses(familyId: familyData['familyId']),
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  CustomHomeAppBar(familyData: familyData),
                  SliverPadding(padding: EdgeInsets.all(20)),
                  BudgetExpensesCard(familyData: familyData),
                  SliverPadding(padding: EdgeInsets.all(20)),
                  CustomPieChart(),
                  SliverPadding(padding: EdgeInsets.all(20)),
                  ExpensesList(familyData: familyData),
                ],
              ))),
    );
  }
}
