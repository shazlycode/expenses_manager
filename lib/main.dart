import 'package:expenses_manager/core/app_router/app_router.dart';
import 'package:expenses_manager/features/auth/data/repo/auth_repo_impl.dart';
import 'package:expenses_manager/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:expenses_manager/features/auth/presentation/view_model/familycreation_cubit/familycreation_cubit.dart';
import 'package:expenses_manager/features/home/data/repo/home_repo_imp.dart';
import 'package:expenses_manager/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepoImpl()),
        ),
        BlocProvider(
          create: (context) => FamilycreationCubit(AuthRepoImpl()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter().routs,
        theme: ThemeData.dark(),
      ),
    );
  }
}
