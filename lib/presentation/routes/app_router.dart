import 'package:go_router/go_router.dart';
import '../screens/login/login_page.dart';

final router = GoRouter(
  initialLocation: '/register',
  routes: [GoRoute(path: '/', builder: (context, state) => const LoginPage())],
);
