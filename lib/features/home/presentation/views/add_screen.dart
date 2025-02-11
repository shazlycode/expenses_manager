import 'dart:io';

import 'package:expenses_manager/core/app_router/app_router_constants.dart';
import 'package:expenses_manager/features/home/data/repo/home_repo_imp.dart';
import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'widets/add_screen_view_body.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key, required this.familyData});
  final Map<String, dynamic> familyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expenses"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(kHomeScreen, extra: familyData),
        ),
      ),
      body: BlocProvider(
        create: (context) => HomeCubit(HomeRepoImp())
          ..fetchExpenses(familyId: familyData['familyId']),
        child: AddScreenViewBody(
          familyData: familyData,
        ),
      ),
    );
  }
}
