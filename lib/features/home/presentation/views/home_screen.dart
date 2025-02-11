import 'dart:io';

import 'package:expenses_manager/core/utils/constants.dart';
import 'package:expenses_manager/features/home/data/repo/home_repo_imp.dart';
import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/app_router/app_router_constants.dart';
import 'widets/home_screen_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.familyData});

  final Map<String, dynamic> familyData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future checkForUpdate() async {
    final firebaseConfig = FirebaseRemoteConfig.instance;
    await firebaseConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 1),
        minimumFetchInterval: Duration(seconds: 1),
      ),
    );
    await firebaseConfig.fetchAndActivate();
    final firebaseConfigBuildNo = firebaseConfig.getString('buildNumber');
    String packageInfo = '';

    await PackageInfo.fromPlatform().then((value) {
      packageInfo = value.buildNumber;
    });
    print("firebaseConfigBuildNo: $firebaseConfigBuildNo");
    print("packageInfo: $packageInfo");
    final result = packageInfo.compareTo(firebaseConfigBuildNo);
    if (result < 0 && mounted) {
      context.go(kUpdateScreen);
    }
    print("result: $result");
  }

  @override
  void initState() {
    checkForUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(HomeRepoImp())
        ..fetchExpenses(familyId: widget.familyData['familyId']),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.go(kAddScreen, extra: widget.familyData),
          child: const Icon(Icons.add),
        ),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.01, // Adjust the opacity as needed
              child: Image.asset(
                kAppLogo, // Replace with your image path
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeSuccess) {
                  return HomeScreenBody(
                    familyData: widget.familyData,
                    expenses: state.expenses ?? [],
                  );
                } else if (state is HomeFailure) {
                  return Center(child: Text(state.errorMessage));
                } else {
                  context
                      .read<HomeCubit>()
                      .fetchExpenses(familyId: widget.familyData['familyId']);
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
