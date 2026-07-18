import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/layouts/main_layout.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/add_product_step1_page.dart';
import 'package:ventry_flutter/presentation/screens/edit_spu/edit_spu_page.dart';
import '../screens/login/login_page.dart';
import '../screens/register/register_page.dart';
import '../screens/inventory_dashboard/inventory_dashboard_page.dart';
import '../screens/product_catalog/product_catalog_page.dart';
import '../screens/quick_add/quick_add_step1_page.dart';
import '../screens/quick_add/quick_add_step2_page.dart';
import '../screens/quick_add/quick_add_step3_page.dart';
import '../screens/quick_add/quick_add_step4_page.dart';
import '../screens/category_management/category_management_page.dart';
import '../screens/test_scanner/test_scanner_page.dart';
import '../screens/sku_form/sku_form_page.dart';
import '../screens/sku_details/sku_details_page.dart';
import '../screens/spu_variants/spu_variants_page.dart';
import '../screens/splash/splash_page.dart';
import '../../injection.dart';
import 'auth_notifier.dart';
import 'router_constants.dart';

final router = GoRouter(
  initialLocation: RouterPath.splash,
  refreshListenable: getIt<AuthNotifier>(),
  redirect: (context, state) {
    final authNotifier = getIt<AuthNotifier>();
    final isSplashRoute = state.matchedLocation == RouterPath.splash;

    if (!authNotifier.isInitialized) {
      return isSplashRoute ? null : RouterPath.splash;
    }

    final isAuth = authNotifier.isAuthenticated;
    final isLoginRoute =
        state.matchedLocation == RouterPath.login ||
        state.matchedLocation == RouterPath.register;

    if (isSplashRoute) {
      return isAuth ? RouterPath.inventory : RouterPath.login;
    }

    if (!isAuth && !isLoginRoute) {
      return RouterPath.login;
    }

    if (isAuth && isLoginRoute) {
      return RouterPath.inventory;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: RouterPath.splash,
      name: RouterName.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouterPath.login,
      name: RouterName.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouterPath.register,
      name: RouterName.register,
      builder: (context, state) => const RegisterPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(body: child);
      },
      routes: [
        GoRoute(
          path: RouterPath.inventory,
          name: RouterName.inventory,
          builder: (context, state) => const InventoryDashboardPage(),
        ),
        GoRoute(
          path: RouterPath.productCatalog,
          name: RouterName.productCatalog,
          builder: (context, state) => const ProductCatalogPage(),
          routes: [
            GoRoute(
              path: 'spu/:spuUid/variants',
              name: RouterName.spuVariants,
              builder: (context, state) {
                final spuUid = state.pathParameters['spuUid'] ?? '';
                return SpuVariantsPage(spuUid: spuUid);
              },
            ),
            GoRoute(
              path: 'spu/:spuUid/edit',
              name: RouterName.editSpu,
              builder: (context, state) {
                final spuUid = state.pathParameters['spuUid'] ?? '';
                return EditSpuPage(spuUid: spuUid);
              },
            ),
            GoRoute(
              path: ':skuUid',
              name: RouterName.skuDetail,
              builder: (context, state) {
                final uid = state.pathParameters['skuUid'] ?? '';
                return SkuDetailsPage(skuUid: uid);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouterPath.quickAdd,
      name: RouterName.quickAdd,
      builder: (context, state) => const QuickAddStep1Page(),
    ),
    GoRoute(
      path: RouterPath.quickAddStep2,
      name: RouterName.quickAddStep2,
      builder: (context, state) => const QuickAddStep2Page(),
    ),
    GoRoute(
      path: RouterPath.quickAddStep3,
      name: RouterName.quickAddStep3,
      builder: (context, state) => const QuickAddStep3Page(),
    ),
    GoRoute(
      path: RouterPath.quickAddStep4,
      name: RouterName.quickAddStep4,
      builder: (context, state) => const QuickAddStep4Page(),
    ),
    GoRoute(
      path: RouterPath.categoryManagement,
      name: RouterName.categoryManagement,
      builder: (context, state) => const CategoryManagementPage(),
    ),
    GoRoute(
      path: RouterPath.addProduct,
      name: RouterName.addProduct,
      builder: (context, state) => const AddProductStep1Page(),
    ),
    GoRoute(
      path: RouterPath.testScanner,
      name: RouterName.testScanner,
      builder: (context, state) => const TestScannerPage(),
    ),
    GoRoute(
      path: RouterPath.skuForm,
      name: RouterName.skuForm,
      builder: (context, state) {
        final extra = state.extra;
        final args = extra is SkuFormPageArgs
            ? extra
            : extra is SkuEntity
            ? SkuFormPageArgs.edit(extra)
            : null;
        if (args == null) {
          return const SizedBox.shrink();
        }
        return SkuFormPage(args: args);
      },
    ),
  ],
);
