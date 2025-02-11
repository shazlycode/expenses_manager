import 'package:expenses_manager/features/auth/presentation/views/auth_screen.dart';
import 'package:expenses_manager/features/update/presentation/view/update_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/views/widgets/family.dart';
import '../../features/home/presentation/views/add_screen.dart';
import '../../features/home/presentation/views/home_screen.dart';
import '../../features/splash_screen/presentation/views/splash_screen.dart';
import 'app_router_constants.dart';

class AppRouter {
  final routs = GoRouter(routes: [
    GoRoute(path: kSpalshScreen, builder: (contesx, state) => SplashScreen()),
    GoRoute(path: kAuthScreen, builder: (contesx, state) => AuthScreen()),
    GoRoute(
        path: kHomeScreen,
        builder: (context, state) {
          Map<String, dynamic> familyData =
              state.extra as Map<String, dynamic>? ?? {};

          return HomeScreen(familyData: familyData);
        }),
    GoRoute(
      path: kAddScreen,
      builder: (context, state) => AddScreen(
        familyData: state.extra as Map<String, dynamic>,
      ),
    ),
    GoRoute(path: kFamilyScreen, builder: (context, state) => FamilyScreen()),
    GoRoute(
      path: kUpdateScreen,
      builder: (context, state) => UpdateScreen(),
    ),
  ]);
}
