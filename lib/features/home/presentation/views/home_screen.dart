import 'package:expenses_manager/features/home/data/repo/home_repo_imp.dart';
import 'package:expenses_manager/features/home/presentation/view_model/cubit/add_expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widets/custom_fab.dart';
import 'widets/home_screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.familyData});
  // final Map<String, dynamic> familyData;
  final String familyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocProvider(
        create: (context) => AddExpenseCubit(HomeRepoImp()),
        child: CustomFab(familyData: familyData),
      ),
      body: HomeScreenBody(familyData: familyData),
    );
  }
}
