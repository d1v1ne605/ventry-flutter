abstract final class RouterPath {
  RouterPath._(); // Private constructor prevents instantiation of the class

  static const String login = '/';
  static const String register = '/register';
  static const String inventory = '/inventory';
  static const String productCatalog = '/product-catalog';
  static const String quickAdd = '/quick-add';
  static const String quickAddStep2 = '/quick-add-step2';
  static const String quickAddStep3 = '/quick-add-step3';
  static const String quickAddStep4 = '/quick-add-step4';
}

abstract final class RouterName {
  RouterName._(); // Private constructor prevents instantiation of the class

  static const String login = 'login';
  static const String register = 'register';
  static const String inventory = 'inventory';
  static const String productCatalog = 'productCatalog';
  static const String quickAdd = 'quickAdd';
  static const String quickAddStep2 = 'quickAddStep2';
  static const String quickAddStep3 = 'quickAddStep3';
  static const String quickAddStep4 = 'quickAddStep4';
}
