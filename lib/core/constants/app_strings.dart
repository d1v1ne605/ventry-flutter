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
  static const String categorySearchHint = 'Search category...';
  static const String categoryAddButton = 'Add Category';
  static const String categoryEditButton = 'Edit Category';
  static const String categoryNewTitle = 'New Category';
  static const String categoryEditTitle = 'Edit Category';
  static const String categoryUpdateTitle = 'Update Category';
  static const String categorySaveTitle = 'Save Category';
  static const String categoryDeleteTitle = 'Delete Category';
  static String categoryDeleteConfirm(String name) =>
      'Are you sure you want to delete $name?';
  static const String categoryNameLabel = 'Name';
  static const String categoryNameHint = 'Category Name';
  static const String categoryImageLabel = 'Image URL (optional)';
  static const String categoryImageHint = 'https://...';
  static const String categorySaveButton = 'Save';
  static const String categoryCancelButton = 'Cancel';
  static const String categoryDeleteButton = 'Delete';
  static const String categoryEmpty = 'No categories found.';
  static const String categoryNoResults = 'No results found.';

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
  static const String quickAddDescriptionHint =
      'Brief details about the product...';
  static const String quickAddImageLabel = 'Product Image';
  static const String quickAddTapToUpload = 'Tap to upload image';
  static const String quickAddTapToUploadImages = 'Tap to upload images';
  static const String quickAddNext = 'Next';
  static const String quickAddBack = 'Back';
  static const String quickAddStep2Title = 'Price & Inventory';
  static const String quickAddStep2Subtitle =
      'Set the retail price and your cost price to track margins.';
  static const String quickAddStep2CurrencyLabel = 'Currency';
  static const String quickAddStep2SellingPriceLabel = 'Selling Price';
  static const String quickAddStep2CostPriceLabel = 'Cost Price';
  static const String quickAddStep2CostPriceHelper =
      'Used to calculate profit margin.';
  static const String quickAddStep2InventoryTitle = 'Inventory';
  static const String quickAddStep2QuantityLabel = 'Stock Quantity';
  static const String quickAddStep2UnitLabel = 'Unit of Measure';
  static const String quickAddStep2InfoText =
      'Margins will be automatically calculated on the dashboard once this product is saved and inventory is tracked.';
  static const String quickAddStep2Required = 'Required';
  static const String quickAddStep2Optional = 'Optional';
  static const String quickAddStep2Progress = 'Step 2 of 5';
  static const String quickAddStep3ProgressText = 'Step 3';
  static const String quickAddStep3Title = 'Attributes & Partners';
  static const String quickAddStep3AttributesTitle = 'Attributes';
  static const String quickAddStep3AddAttributeButton = 'Add Attribute';
  static const String quickAddStep3BarcodeTitle = 'Barcode / QR';
  static const String quickAddStep3BarcodeHint =
      'Scan or enter barcode manually';
  static const String quickAddStep3Scan = 'Scan';
  static const String quickAddStep3SupplierTitle = 'Supplier';
  static const String quickAddStep3SupplierHint = 'Select a supplier...';
  static const String quickAddStep3KeyHint = 'e.g., Warranty';
  static const String quickAddStep3ValueHint = 'e.g., 1 Year';
  static const String quickAddStep4ProgressText = 'Step 4 of 4';
  static const String quickAddStep4Title = 'Review & Confirm';
  static const String quickAddStep4BasicDetailsLabel = 'BASIC DETAILS';
  static const String quickAddStep4AttributesLabel = 'ATTRIBUTES & VARIANTS';
  static const String quickAddStep4PricingLabel = 'PRICING';
  static const String quickAddStep4InventoryLabel = 'INVENTORY';
  static const String quickAddStep4SupplierBarcodeLabel = 'SUPPLIER & BARCODE';
  static const String quickAddStep4SellingPrice = 'Selling Price';
  static const String quickAddStep4CostPrice = 'Cost Price';
  static const String quickAddStep4Margin = 'Margin';
  static const String quickAddStep4InitialStock = 'Initial Stock';
  static const String quickAddStep4LowStockAlert = 'Low Stock Alert';
  static const String quickAddStep4Location = 'Location';
  static const String quickAddStep4Supplier = 'Supplier';
  static const String quickAddStep4BarcodeOptional = 'Barcode (Optional)';
  static const String quickAddStep4Missing = 'MISSING';
  static const String quickAddStep4BarcodeScanHint = 'Scan or enter barcode';
  static const String quickAddStep4GeneratedVariants = 'Generated Variants';
  static const String quickAddStep4Status = 'Status';

  // ── Product Catalog ──────────────────────────────────────────────────────────
  static const String productCatalogPageTitle = 'StockMaster';
  static const String productCatalogEmpty = 'No products found';
  static const String searchHint = 'Search by SKU name, barcode, ...';
  static const String filterTotalStock = 'Total Stock';
  static const String filterLowStock = 'Low Stock';
  static const String filterOutOfStock = 'Out of Stock';
  static const String inStock = 'In Stock';
  static const String lowStock = 'Low Stock';
  static const String outOfStock = 'Out';
  static const String skuPrefix = 'SKU: ';
  static const String addProduct = 'Add Product';
  static String variantCount(int count) =>
      count == 1 ? '$count Variant' : '$count Variants';

  // ── Add Product ──────────────────────────────────────────────────────────────
  static const String addProductTitle = 'Add Product';
  static const String addProductProgress1 = '1 of 3';
  static const String addProductNameLabel = 'Product Name';
  static const String addProductNameHint = 'Enter product name';
  static const String addProductCategoryLabel = 'Category';
  static const String addProductCurrencyLabel = 'Currency';
  static const String addProductUnitLabel = 'Unit of Measure';
  static const String addProductDescriptionLabel = 'Description';
  static const String addProductDescriptionHint =
      'Briefly describe the product...';
  static const String addProductImageLabel = 'Product Image';
  static const String addProductImageHint = 'Tap to upload an image';
  static const String addProductCancel = 'Cancel';
  static const String addProductNext = 'Next';
  static const String saveAndComplete = 'Save & Complete';
  static const String createNewCategory = 'Create New Category';

  static const String uploadImage = 'Upload Image';
  static const String takeAPhoto = 'Take a photo';
  static const String chooseFromGallery = 'Choose from gallery';
  static const String addProductUploadInProgress =
      'Please wait until image upload completes';
  static const String addProductNameRequired = 'Product Name is required';
  static const String addProductCreatedSuccess =
      'Product created successfully!';
  static const String addProductCreateFailed = 'Failed to create product';
  static String selectedNewCategory(String name) =>
      'Selected new category: $name';
  static const String currencyHint = 'e.g. USD, EUR, VND';
  static const String unitHint = 'e.g. Pieces, Boxes';

  static const String addProductProgress2 = 'Step 2 of 3';
  static const String priceAndSkuVariants = 'Price & SKU Variants';

  static const String skuPreview = 'SKU Preview';
  static String skuVariantsCount(int count) => '$count Variants';
  static String priceLabel(String price) => 'Price: \$$price';
  static String stockLabel(int stock) => 'Stock: $stock';

  static const String editVariant = 'Edit Variant';
  static const String skuInfo = 'SKU Info : ';
  static const String skuCodeLabel = 'SKU Code';
  static const String skuCodeHint = 'Automatically';
  static const String barcodeLabel = 'Barcode';
  static const String barcodeHint = 'Scan or enter manually';
  static const String pricingAndStock = 'Pricing & Stock';
  static const String initialStock = 'Initial Stock';
  static const String saveButton = 'Save';

  static const String variantOptionsDefinition = 'Variant Options Definition';
  static const String addAnotherOption = 'Add Another Option';
  static const String optionNameLabel = 'Option Name';
  static const String optionNameHint = 'e.g. Color';
  static const String optionValuesLabel = 'Option Values';
  static const String optionValuesHint = 'Type and press enter...';

  static const String sellingPriceHint = 'e.g. 10.00';
  static const String costPriceHint = 'e.g. 5.00';
  static const String stockQuantityHint = '0';
  static const String editVariantPriceHint = '\$ 0.00';

  static const String addCustomVariant = 'Add Custom Variant';
  static const String variantAttributes = 'Variant Attributes';
  static const String colorLabel = 'Color';
  static const String colorHint = 'e.g. Black';
  static const String storageLabel = 'Storage';
  static const String storageHint = 'e.g. 128GB';
  static const String logisticsAndPricing = 'Logistics & Pricing';
  static const String skuCodeExampleHint = 'IP15P-BLK-128';
  static const String barcodeScanHint2 = 'Scan or enter barcode';
  static const String priceZeroHint = '0.00';
  static const String unitPcsHint = 'pcs';
  static const String saveVariant = 'Save Variant';

  // ── Sku Details ──────────────────────────────────────────────────────────────
  static const String skuDetailsTitle = 'SKU Details';
  static const String spuVariantsTitle = 'Product Variants';
  static const String variantsListTitle = 'Related Variants';
  static const String noVariantsFound = 'No variants found for this product.';
  static const String stockShortLabel = 'Stock';
  static const String editVariantButton = 'Edit Variant';
  static const String quickAdjustButton = 'Quick Adjust';
  static const String currentStockLabel = 'Current Stock';
  static const String inTransitLabel = 'In Transit';
  static const String reservedLabel = 'Reserved';
  static const String generalInfoTitle = 'General Info';
  static const String categoryLabel = 'Category';
  static const String unitOfMeasureLabel = 'Unit of Measure';
  static const String currencyLabel = 'Currency';
  static const String isSellableLabel = 'Is Sellable';
  static const String costPriceLabel = 'Cost Price';
  static const String sellingPriceLabel = 'Selling Price';
  static const String marginLabel = 'Margin';
  static const String attributesTitle = 'Attributes';
  static const String descriptionTitle = 'Description';
  static const String notAvailable = 'N/A';
  static const String addNew = 'Add New';
  static const String retry = 'Retry';

  // ── SKU Form ────────────────────────────────────────────────────────────────
  static const String skuFormEditTitle = 'Edit SKU';
  static const String skuFormCreateTitle = 'Add SKU';
  static const String skuFormSaveChanges = 'Save Changes';
  static const String skuFormCreateSku = 'Create SKU';
  static const String skuFormGeneralInformation = 'General Information';
  static const String skuFormAttributes = 'Attributes';
  static const String skuFormMedia = 'Media';
  static const String skuFormDescription = 'Description';
  static const String skuFormManage = 'Manage';
  static const String skuFormEdit = 'Edit';
  static const String skuFormSkuName = 'SKU Name';
  static const String skuFormCategory = 'Category';
  static const String skuFormBarcode = 'Barcode';
  static const String skuFormSkuCode = 'SKU Code';
  static const String skuFormCostPrice = 'Cost Price';
  static const String skuFormSellingPrice = 'Selling Price';
  static const String skuFormCurrency = 'Currency';
  static const String skuFormUnitOfMeasure = 'Unit of Measure';
  static const String skuFormIsSellable = 'Is Sellable';
  static const String skuFormSellableHelper =
      'Allow this item to be sold in the store';
  static const String skuFormAddImage = 'Add Image';
  static const String skuFormEditAttributesTitle = 'Edit Attributes';
  static const String skuFormEditImagesTitle = 'Edit Images';
  static const String skuFormCancel = 'Cancel';
  static const String skuFormApplyAttributes = 'Apply Attributes';
  static const String skuFormSelectAttributesTitle = 'Select Attributes';
  static const String skuFormSelectAttributesHelper =
      'Choose one or more shop attributes to add to this SKU.';
  static const String skuFormAddNewAttribute = 'Add New Attribute';
  static const String skuFormCreateAttributeTitle = 'New Attribute';
  static const String skuFormCreateAttributeHint = 'Enter attribute name';
  static const String skuFormCreateAttributeConfirm = 'Create';
  static const String skuFormCreateAttributeHeaderAction = 'New';
  static const String skuFormCreateAttributeNameRequired =
      'Attribute name is required.';
  static const String skuFormAttributeCreatedSuccess =
      'Attribute created successfully';
  static const String skuFormAddSelectedAttributes = 'Add Attributes';
  static const String skuFormAttributeAlreadyAdded = 'Added';
  static const String skuFormAttributesEmptyState =
      'No attributes are available for this shop yet.';
  static const String skuFormAttributesAllAdded =
      'All available attributes have already been added to this SKU.';
  static const String skuFormAttributesLoadFailed =
      'Unable to load shop attributes.';
  static const String skuFormSaveGallery = 'Save Gallery';
  static const String skuFormUploadNew = 'Upload New';
  static const String skuFormMediaHelper =
      'Manage the gallery for this SKU. Drag to reorder.';
  static const String skuFormCover = 'Cover';
  static const String skuFormUploadInProgress =
      'Please wait until image upload completes';
  static const String skuFormGalleryUpdatedSuccess =
      'Gallery updated successfully';
  static const String skuFormUpdatedSuccess = 'SKU updated successfully';
  static const String skuFormCreatedSuccess = 'SKU created successfully';
  static String skuFormNewAttributeLabel(int index) => 'Attribute $index';
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
  final String usernameLabel = 'Username';
  final String usernameHint = 'Enter your username';
  final String passwordLabel = 'Password';
  final String passwordHint = 'Enter your password';
  final String confirmPasswordLabel = 'Confirm Password';
  final String confirmPasswordHint = 'Re-enter your password';
  final String personalInfoSection = 'Account Setup';
  final String shopDetailsSection = 'Shop Details';
  final String shopNameLabel = 'Company / Shop Name';
  final String shopNameHint = 'Enter your company name';
  final String createButton = 'Create Account';
  final String footerPrefix = 'Already have an account?';
  final String footerLink = 'Sign In';
  final String errorRequiredFields = 'Please fill in all required fields.';
  final String errorPasswordMismatch = 'Password confirmation does not match.';
  final String errorDefault =
      'Unable to create your account. Please try again.';
  final String successMessage = 'Account created successfully. Please sign in.';
}
