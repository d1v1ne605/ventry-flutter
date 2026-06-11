import 'package:go_router/go_router.dart';
import '../screens/login/login_page.dart';
import '../screens/register/register_page.dart';
import '../screens/inventory_dashboard/inventory_dashboard_page.dart';

final router = GoRouter(
  initialLocation: '/inventory',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryDashboardPage(),
    ),
  ],
);
