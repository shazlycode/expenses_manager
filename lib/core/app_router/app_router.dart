import 'package:expenses_manager/features/auth/presentation/views/auth_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/views/home_screen.dart';
import '../../features/splash_screen/presentation/views/splash_screen.dart';
import 'app_router_constants.dart';

class AppRouter {
  final routs = GoRouter(routes: [
    GoRoute(path: kSpalshScreen, builder: (contesx, state) => SplashScreen()),
    GoRoute(path: kAuthScreen, builder: (contesx, state) => AuthScreen()),
    GoRoute(
      path: kHomeScreen,
      builder: (context, state) => HomeScreen(),
    )
  ]);
}
