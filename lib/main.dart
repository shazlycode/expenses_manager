import 'package:expenses_manager/core/app_router/app_router.dart';
import 'package:expenses_manager/features/auth/data/repo/auth_repo_impl.dart';
import 'package:expenses_manager/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:expenses_manager/features/auth/presentation/view_model/familycreation_cubit/familycreation_cubit.dart';
import 'package:expenses_manager/features/home/data/repo/home_repo_imp.dart';
import 'package:expenses_manager/features/home/presentation/view_model/cubit/add_expense_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepoImpl())..checkLogin(),
        ),
        BlocProvider(
          create: (context) => FamilycreationCubit(AuthRepoImpl()),
        ),
        BlocProvider(create: (context) => AddExpenseCubit(HomeRepoImp())),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter().routs,
        theme: ThemeData.dark(),
      ),
    );
  }
}
