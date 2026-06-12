/// Centralized string constants used across the entire app.
class AppStrings {
  // ── Auth ─────────────────────────────────────────────────────────────────────
  // ignore: non_constant_identifier_names
  static final login = _LoginStrings();

  // ignore: non_constant_identifier_names
  static final register = _RegisterStrings();

  // ── App-wide ─────────────────────────────────────────────────────────────────
  static const String appName = 'Ventry';

  // ── Inventory Dashboard ──────────────────────────────────────────────────────
  static const String storageManagerTitle = 'STORAGE MANAGER';
  static const String inventoryDashboard = 'Inventory Dashboard';
  static const String inventorySubtitle = 'Manage your physical assets';

  // ── Cards ────────────────────────────────────────────────────────────────────
  static const String productCatalogTitle = 'Product Catalog';
  static const String productCatalogSubtitle = 'View and edit all stored items';
  static const String categoryManagementTitle = 'Category Management';
  static const String categoryManagementSubtitle =
      'Organize items by type and location';
  static const String stockMovementLogsTitle = 'Stock Movement Logs';
  static const String stockMovementLogsSubtitle =
      'Track inbound and outbound history';

  // ── Bottom Nav ───────────────────────────────────────────────────────────────
  static const String navSales = 'Sales';
  static const String navInventory = 'Inventory';
  static const String navPartners = 'Partners';
  static const String navAccount = 'Account';

  // ── Quick Add ────────────────────────────────────────────────────────────────
  static const String quickAddTitle = 'Add Product';
  static const String quickAddBasicInfoTitle = 'Basic Information';
  static const String quickAddProductNameLabel = 'Product Name';
  static const String quickAddProductNameHint = 'Enter product name';
  static const String quickAddSkuLabel = 'SKU Code';
  static const String quickAddSkuHint = 'PROD-789';
  static const String quickAddCategoryLabel = 'Category';
  static const String quickAddDescriptionLabel = 'Short Description';
  static const String quickAddDescriptionHint = 'Brief details about the product...';
  static const String quickAddImageLabel = 'Product Image';
  static const String quickAddNext = 'Next';
  static const String quickAddBack = 'Back';
  static const String quickAddStep2Title = 'Price & Inventory';
  static const String quickAddStep2Subtitle = 'Set the retail price and your cost price to track margins.';
  static const String quickAddStep2CurrencyLabel = 'Currency';
  static const String quickAddStep2SellingPriceLabel = 'Selling Price';
  static const String quickAddStep2CostPriceLabel = 'Cost Price';
  static const String quickAddStep2CostPriceHelper = 'Used to calculate profit margin.';
  static const String quickAddStep2InventoryTitle = 'Inventory';
  static const String quickAddStep2QuantityLabel = 'Stock Quantity';
  static const String quickAddStep2UnitLabel = 'Unit of Measure';
  static const String quickAddStep2InfoText = 'Margins will be automatically calculated on the dashboard once this product is saved and inventory is tracked.';
  static const String quickAddStep2Required = 'Required';
  static const String quickAddStep2Optional = 'Optional';
  static const String quickAddStep2Progress = 'Step 2 of 5';


  // ── Product Catalog ──────────────────────────────────────────────────────────
  static const String productCatalogPageTitle = 'StockMaster';
  static const String searchHint = 'Search by SKU name, barcode, ...';
  static const String filterTotalStock = 'Total Stock';
  static const String filterLowStock = 'Low Stock';
  static const String filterOutOfStock = 'Out of Stock';
  static const String inStock = 'In Stock';
  static const String lowStock = 'Low Stock';
  static const String outOfStock = 'Out';
  static const String skuPrefix = 'SKU: ';
  static const String addProduct = 'Add Product';
}

/// Login screen string tokens.
class _LoginStrings {
  final String title = 'Welcome Back';
  final String subtitle = 'Sign in to continue managing your inventory';
  final String emailLabel = 'Email';
  final String emailHint = 'Enter your email';
  final String passwordLabel = 'Password';
  final String passwordHint = 'Enter your password';
  final String forgotPassword = 'Forgot password?';
  final String submitButton = 'Sign In';
  final String footerPrefix = "Don't have an account?";
  final String footerLink = 'Sign Up';
  final String errorDefault = 'Invalid email or password. Please try again.';
  final String successMessage = 'Login successful!';
}

/// Register screen string tokens.
class _RegisterStrings {
  final String title = 'Create Account';
  final String subtitle = 'Join us to manage your inventory smarter';
  final String fullNameLabel = 'Full Name';
  final String fullNameHint = 'Enter your full name';
  final String emailLabel = 'Email';
  final String emailHint = 'Enter your email';
  final String phoneLabel = 'Phone Number';
  final String phoneHint = 'Enter your phone number';
  final String passwordLabel = 'Password';
  final String passwordHint = 'Enter your password';
  final String confirmPasswordLabel = 'Confirm Password';
  final String confirmPasswordHint = 'Re-enter your password';
  final String personalInfoSection = 'Personal Information';
  final String shopDetailsSection = 'Shop Details';
  final String shopNameLabel = 'Company / Shop Name';
  final String shopNameHint = 'Enter your company name';
  final String createButton = 'Create Account';
  final String footerPrefix = 'Already have an account?';
  final String footerLink = 'Sign In';
}
