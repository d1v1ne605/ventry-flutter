import 'package:go_router/go_router.dart';
import '../screens/login/login_page.dart';
import '../screens/register/register_page.dart';
import '../screens/inventory_dashboard/inventory_dashboard_page.dart';
import '../screens/product_catalog/product_catalog_page.dart';
import '../screens/quick_add/quick_add_step1_page.dart';
import '../screens/quick_add/quick_add_step2_page.dart';
import '../screens/quick_add/quick_add_step3_page.dart';

final router = GoRouter(
  initialLocation: '/quick-add',
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
    GoRoute(
      path: '/product-catalog',
      builder: (context, state) => const ProductCatalogPage(),
    ),
    GoRoute(
      path: '/quick-add',
      builder: (context, state) => const QuickAddStep1Page(),
    ),
    GoRoute(
      path: '/quick-add-step2',
      builder: (context, state) => const QuickAddStep2Page(),
    ),
    GoRoute(
      path: '/quick-add-step3',
      builder: (context, state) => const QuickAddStep3Page(),
    ),
  ],
);

