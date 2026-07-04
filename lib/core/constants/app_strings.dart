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
  static const String storageManagerTitle = 'QUẢN LÝ KHO';
  static const String inventoryDashboard = 'Bảng điều khiển kho';
  static const String inventorySubtitle = 'Quản lý tài sản vật lý của bạn';

  // ── Cards ────────────────────────────────────────────────────────────────────
  static const String productCatalogTitle = 'Danh mục sản phẩm';
  static const String productCatalogSubtitle =
      'Xem và chỉnh sửa tất cả mặt hàng đang lưu kho';
  static const String categoryManagementTitle = 'Quản lý danh mục';
  static const String categoryManagementSubtitle =
      'Sắp xếp mặt hàng theo loại và vị trí';
  static const String categorySearchHint = 'Tìm kiếm danh mục...';
  static const String categoryAddButton = 'Thêm danh mục';
  static const String categoryEditButton = 'Sửa danh mục';
  static const String categoryNewTitle = 'Danh mục mới';
  static const String categoryEditTitle = 'Sửa danh mục';
  static const String categoryUpdateTitle = 'Cập nhật danh mục';
  static const String categorySaveTitle = 'Lưu danh mục';
  static const String categoryDeleteTitle = 'Xóa danh mục';
  static String categoryDeleteConfirm(String name) =>
      'Bạn có chắc muốn xóa $name không?';
  static const String categoryNameLabel = 'Tên';
  static const String categoryNameHint = 'Tên danh mục';
  static const String categoryImageLabel = 'URL hình ảnh (không bắt buộc)';
  static const String categoryImageHint = 'https://...';
  static const String categorySaveButton = 'Lưu';
  static const String categoryCancelButton = 'Hủy';
  static const String categoryDeleteButton = 'Xóa';
  static const String categoryEmpty = 'Không tìm thấy danh mục nào.';
  static const String categoryNoResults = 'Không tìm thấy kết quả.';

  static const String stockMovementLogsTitle = 'Nhật ký xuất nhập kho';
  static const String stockMovementLogsSubtitle =
      'Theo dõi lịch sử nhập và xuất kho';

  // ── Bottom Nav ───────────────────────────────────────────────────────────────
  static const String navSales = 'Bán hàng';
  static const String navInventory = 'Kho';
  static const String navPartners = 'Đối tác';
  static const String navAccount = 'Tài khoản';

  // ── Quick Add ────────────────────────────────────────────────────────────────
  static const String quickAddTitle = 'Thêm sản phẩm';
  static const String quickAddBasicInfoTitle = 'Thông tin cơ bản';
  static const String quickAddProductNameLabel = 'Tên sản phẩm';
  static const String quickAddProductNameHint = 'Nhập tên sản phẩm';
  static const String quickAddSkuLabel = 'Mã SKU';
  static const String quickAddSkuHint = 'PROD-789';
  static const String quickAddCategoryLabel = 'Danh mục';
  static const String quickAddDescriptionLabel = 'Mô tả ngắn';
  static const String quickAddDescriptionHint = 'Thông tin ngắn về sản phẩm...';
  static const String quickAddImageLabel = 'Hình ảnh sản phẩm';
  static const String quickAddTapToUpload = 'Nhấn để tải ảnh lên';
  static const String quickAddTapToUploadImages = 'Nhấn để tải ảnh lên';
  static const String quickAddNext = 'Tiếp theo';
  static const String quickAddBack = 'Quay lại';
  static const String quickAddStep2Title = 'Giá & Tồn kho';
  static const String quickAddStep2Subtitle =
      'Thiết lập giá bán lẻ và giá vốn để theo dõi biên lợi nhuận.';
  static const String quickAddStep2CurrencyLabel = 'Tiền tệ';
  static const String quickAddStep2SellingPriceLabel = 'Giá bán';
  static const String quickAddStep2CostPriceLabel = 'Giá vốn';
  static const String quickAddStep2CostPriceHelper =
      'Dùng để tính biên lợi nhuận.';
  static const String quickAddStep2InventoryTitle = 'Tồn kho';
  static const String quickAddStep2QuantityLabel = 'Số lượng tồn kho';
  static const String quickAddStep2UnitLabel = 'Đơn vị tính';
  static const String quickAddStep2InfoText =
      'Biên lợi nhuận sẽ được tự động tính trên bảng điều khiển sau khi sản phẩm này được lưu và tồn kho được theo dõi.';
  static const String quickAddStep2Required = 'Bắt buộc';
  static const String quickAddStep2Optional = 'Không bắt buộc';
  static const String quickAddStep2Progress = 'Bước 2 trên 5';
  static const String quickAddStep3ProgressText = 'Bước 3';
  static const String quickAddStep3Title = 'Thuộc tính & Đối tác';
  static const String quickAddStep3AttributesTitle = 'Thuộc tính';
  static const String quickAddStep3AddAttributeButton = 'Thêm thuộc tính';
  static const String quickAddStep3BarcodeTitle = 'Mã vạch / QR';
  static const String quickAddStep3BarcodeHint =
      'Quét hoặc nhập mã vạch thủ công';
  static const String quickAddStep3Scan = 'Quét';
  static const String quickAddStep3SupplierTitle = 'Nhà cung cấp';
  static const String quickAddStep3SupplierHint = 'Chọn nhà cung cấp...';
  static const String quickAddStep3KeyHint = 'VD: Bảo hành';
  static const String quickAddStep3ValueHint = 'VD: 1 năm';
  static const String quickAddStep4ProgressText = 'Bước 4 trên 4';
  static const String quickAddStep4Title = 'Xem lại & Xác nhận';
  static const String quickAddStep4BasicDetailsLabel = 'THÔNG TIN CƠ BẢN';
  static const String quickAddStep4AttributesLabel = 'THUỘC TÍNH & BIẾN THỂ';
  static const String quickAddStep4PricingLabel = 'GIÁ';
  static const String quickAddStep4InventoryLabel = 'TỒN KHO';
  static const String quickAddStep4SupplierBarcodeLabel =
      'NHÀ CUNG CẤP & MÃ VẠCH';
  static const String quickAddStep4SellingPrice = 'Giá bán';
  static const String quickAddStep4CostPrice = 'Giá vốn';
  static const String quickAddStep4Margin = 'Biên lợi nhuận';
  static const String quickAddStep4InitialStock = 'Tồn kho ban đầu';
  static const String quickAddStep4LowStockAlert = 'Cảnh báo tồn kho thấp';
  static const String quickAddStep4Location = 'Vị trí';
  static const String quickAddStep4Supplier = 'Nhà cung cấp';
  static const String quickAddStep4BarcodeOptional = 'Mã vạch (không bắt buộc)';
  static const String quickAddStep4Missing = 'THIẾU';
  static const String quickAddStep4BarcodeScanHint = 'Quét hoặc nhập mã vạch';
  static const String quickAddStep4GeneratedVariants = 'Biến thể đã tạo';
  static const String quickAddStep4Status = 'Trạng thái';

  // ── Product Catalog ──────────────────────────────────────────────────────────
  static const String productCatalogPageTitle = 'StockMaster';
  static const String productCatalogEmpty = 'Không tìm thấy sản phẩm nào';
  static const String searchHint = 'Tìm theo tên SKU, mã vạch, ...';
  static const String filterTotalStock = 'Tổng tồn kho';
  static const String filterLowStock = 'Tồn kho thấp';
  static const String filterOutOfStock = 'Hết hàng';
  static const String inStock = 'Còn hàng';
  static const String lowStock = 'Tồn kho thấp';
  static const String outOfStock = 'Hết';
  static const String skuPrefix = 'SKU: ';
  static const String addProduct = 'Thêm sản phẩm';
  static String variantCount(int count) => '$count biến thể';

  // ── Add Product ──────────────────────────────────────────────────────────────
  static const String addProductTitle = 'Thêm sản phẩm';
  static const String addProductProgress1 = '1 trên 3';
  static const String addProductNameLabel = 'Tên sản phẩm';
  static const String addProductNameHint = 'Nhập tên sản phẩm';
  static const String addProductCategoryLabel = 'Danh mục';
  static const String addProductCurrencyLabel = 'Tiền tệ';
  static const String addProductUnitLabel = 'Đơn vị tính';
  static const String addProductDescriptionLabel = 'Mô tả';
  static const String addProductDescriptionHint = 'Mô tả ngắn về sản phẩm...';
  static const String addProductImageLabel = 'Hình ảnh sản phẩm';
  static const String addProductImageHint = 'Nhấn để tải ảnh lên';
  static const String addProductCancel = 'Hủy';
  static const String addProductNext = 'Tiếp theo';
  static const String saveAndComplete = 'Lưu & Hoàn tất';
  static const String createNewCategory = 'Tạo danh mục mới';

  static const String uploadImage = 'Tải ảnh lên';
  static const String takeAPhoto = 'Chụp ảnh';
  static const String chooseFromGallery = 'Chọn từ thư viện';
  static const String addProductUploadInProgress =
      'Vui lòng chờ đến khi tải ảnh lên hoàn tất';
  static const String addProductNameRequired = 'Tên sản phẩm là bắt buộc';
  static const String addProductCreatedSuccess = 'Tạo sản phẩm thành công!';
  static const String addProductCreateFailed = 'Tạo sản phẩm thất bại';
  static String selectedNewCategory(String name) =>
      'Đã chọn danh mục mới: $name';
  static const String currencyHint = 'VD: USD, EUR, VND';
  static const String unitHint = 'VD: Cái, Hộp';

  static const String addProductProgress2 = 'Bước 2 trên 3';
  static const String priceAndSkuVariants = 'Giá & Biến thể SKU';

  static const String skuPreview = 'Xem trước SKU';
  static String skuVariantsCount(int count) => '$count biến thể';
  static String priceLabel(String price) => 'Giá: \$$price';
  static String stockLabel(int stock) => 'Tồn kho: $stock';

  static const String editVariant = 'Sửa biến thể';
  static const String skuInfo = 'Thông tin SKU: ';
  static const String skuCodeLabel = 'Mã SKU';
  static const String skuCodeHint = 'Tự động';
  static const String barcodeLabel = 'Mã vạch';
  static const String barcodeHint = 'Quét hoặc nhập thủ công';
  static const String pricingAndStock = 'Giá & Tồn kho';
  static const String initialStock = 'Tồn kho ban đầu';
  static const String saveButton = 'Lưu';

  static const String variantOptionsDefinition = 'Định nghĩa tùy chọn biến thể';
  static const String addAnotherOption = 'Thêm tùy chọn khác';
  static const String optionNameLabel = 'Tên tùy chọn';
  static const String optionNameHint = 'VD: Màu sắc';
  static const String optionValuesLabel = 'Giá trị tùy chọn';
  static const String optionValuesHint = 'Nhập và nhấn enter...';

  static const String sellingPriceHint = 'VD: 10.00';
  static const String costPriceHint = 'VD: 5.00';
  static const String stockQuantityHint = '0';
  static const String editVariantPriceHint = '\$ 0.00';

  static const String addCustomVariant = 'Thêm biến thể tùy chỉnh';
  static const String variantAttributes = 'Thuộc tính biến thể';
  static const String colorLabel = 'Màu sắc';
  static const String colorHint = 'VD: Đen';
  static const String storageLabel = 'Dung lượng';
  static const String storageHint = 'VD: 128GB';
  static const String logisticsAndPricing = 'Vận chuyển & Giá';
  static const String skuCodeExampleHint = 'IP15P-BLK-128';
  static const String barcodeScanHint2 = 'Quét hoặc nhập mã vạch';
  static const String priceZeroHint = '0.00';
  static const String unitPcsHint = 'cái';
  static const String saveVariant = 'Lưu biến thể';

  // ── Sku Details ──────────────────────────────────────────────────────────────
  static const String skuDetailsTitle = 'Chi tiết SKU';
  static const String spuVariantsTitle = 'Biến thể sản phẩm';
  static const String variantsListTitle = 'Biến thể liên quan';
  static const String noVariantsFound =
      'Không tìm thấy biến thể nào cho sản phẩm này.';
  static const String stockShortLabel = 'Tồn kho';
  static const String editVariantButton = 'Sửa biến thể';
  static const String quickAdjustButton = 'Điều chỉnh nhanh';
  static const String currentStockLabel = 'Tồn kho hiện tại';
  static const String inTransitLabel = 'Đang vận chuyển';
  static const String reservedLabel = 'Đã giữ chỗ';
  static const String generalInfoTitle = 'Thông tin chung';
  static const String categoryLabel = 'Danh mục';
  static const String unitOfMeasureLabel = 'Đơn vị tính';
  static const String currencyLabel = 'Tiền tệ';
  static const String isSellableLabel = 'Có thể bán';
  static const String costPriceLabel = 'Giá vốn';
  static const String sellingPriceLabel = 'Giá bán';
  static const String marginLabel = 'Biên lợi nhuận';
  static const String attributesTitle = 'Thuộc tính';
  static const String descriptionTitle = 'Mô tả';
  static const String notAvailable = 'Không có';
  static const String addNew = 'Thêm mới';
  static const String retry = 'Thử lại';

  // ── SPU Form ────────────────────────────────────────────────────────────────
  static const String editSpuTitle = 'Sửa sản phẩm';
  static const String editSpuButton = 'Sửa SPU';
  static const String editSpuSaveChanges = 'Lưu thay đổi';
  static const String editSpuBasicInformation = 'Thông tin cơ bản';
  static const String editSpuNameRequired = 'Tên sản phẩm là bắt buộc';
  static const String editSpuUpdatedSuccess = 'Cập nhật sản phẩm thành công';
  static const String editSpuLoadFailed = 'Không thể tải sản phẩm';
  static const String editSpuNoCategory = 'Không có danh mục';
  static const String editSpuSelectCategory = 'Chọn danh mục';
  static const String editSpuCategoryLoadFailed = 'Không thể tải danh mục';

  // ── SKU Form ────────────────────────────────────────────────────────────────
  static const String skuFormEditTitle = 'Sửa SKU';
  static const String skuFormCreateTitle = 'Thêm SKU';
  static const String skuFormSaveChanges = 'Lưu thay đổi';
  static const String skuFormCreateSku = 'Tạo SKU';
  static const String skuFormGeneralInformation = 'Thông tin chung';
  static const String skuFormAttributes = 'Thuộc tính';
  static const String skuFormMedia = 'Hình ảnh';
  static const String skuFormDescription = 'Mô tả';
  static const String skuFormManage = 'Quản lý';
  static const String skuFormEdit = 'Sửa';
  static const String skuFormSkuName = 'Tên SKU';
  static const String skuFormCategory = 'Danh mục';
  static const String skuFormBarcode = 'Mã vạch';
  static const String skuFormSkuCode = 'Mã SKU';
  static const String skuFormCostPrice = 'Giá vốn';
  static const String skuFormSellingPrice = 'Giá bán';
  static const String skuFormCurrency = 'Tiền tệ';
  static const String skuFormUnitOfMeasure = 'Đơn vị tính';
  static const String skuFormIsSellable = 'Có thể bán';
  static const String skuFormSellableHelper =
      'Cho phép mặt hàng này được bán trong cửa hàng';
  static const String skuFormAddImage = 'Thêm ảnh';
  static const String skuFormEditAttributesTitle = 'Sửa thuộc tính';
  static const String skuFormEditImagesTitle = 'Sửa hình ảnh';
  static const String skuFormCancel = 'Hủy';
  static const String skuFormApplyAttributes = 'Áp dụng thuộc tính';
  static const String skuFormSelectAttributesTitle = 'Chọn thuộc tính';
  static const String skuFormSelectAttributesHelper =
      'Chọn một hoặc nhiều thuộc tính cửa hàng để thêm vào SKU này.';
  static const String skuFormAddNewAttribute = 'Thêm thuộc tính mới';
  static const String skuFormCreateAttributeTitle = 'Thuộc tính mới';
  static const String skuFormCreateAttributeHint = 'Nhập tên thuộc tính';
  static const String skuFormCreateAttributeConfirm = 'Tạo';
  static const String skuFormCreateAttributeHeaderAction = 'Mới';
  static const String skuFormCreateAttributeHelper =
      'Tạo thuộc tính cửa hàng và quay lại danh sách này.';
  static const String skuFormCreateAttributeNameLabel = 'Tên thuộc tính';
  static const String skuFormCreateAttributeNameRequired =
      'Tên thuộc tính là bắt buộc.';
  static const String skuFormAttributeCreatedSuccess =
      'Tạo thuộc tính thành công';
  static const String skuFormAddSelectedAttributes = 'Thêm thuộc tính';
  static const String skuFormAttributeAlreadyAdded = 'Đã thêm';
  static const String skuFormAttributesEmptyState =
      'Chưa có thuộc tính nào cho cửa hàng này.';
  static const String skuFormAttributesAllAdded =
      'Tất cả thuộc tính hiện có đã được thêm vào SKU này.';
  static const String skuFormAttributesLoadFailed =
      'Không thể tải thuộc tính cửa hàng.';
  static const String skuFormSaveGallery = 'Lưu thư viện ảnh';
  static const String skuFormUploadNew = 'Tải ảnh mới';
  static const String skuFormMediaHelper =
      'Quản lý thư viện ảnh cho SKU này. Kéo để sắp xếp lại.';
  static const String skuFormCover = 'Ảnh bìa';
  static const String skuFormMainImageBadge = 'Chính';
  static const String skuFormUploadInProgress =
      'Vui lòng chờ đến khi tải ảnh lên hoàn tất';
  static const String skuFormGalleryUpdatedSuccess =
      'Cập nhật thư viện ảnh thành công';
  static const String skuFormUpdatedSuccess = 'Cập nhật SKU thành công';
  static const String skuFormCreatedSuccess = 'Tạo SKU thành công';
  static String skuFormNewAttributeLabel(int index) => 'Thuộc tính $index';
}

/// Login screen string tokens.
class _LoginStrings {
  final String title = 'Chào mừng trở lại';
  final String subtitle = 'Đăng nhập để tiếp tục quản lý kho của bạn';
  final String emailLabel = 'Email';
  final String emailHint = 'Nhập email của bạn';
  final String passwordLabel = 'Mật khẩu';
  final String passwordHint = 'Nhập mật khẩu của bạn';
  final String forgotPassword = 'Quên mật khẩu?';
  final String submitButton = 'Đăng nhập';
  final String footerPrefix = 'Chưa có tài khoản?';
  final String footerLink = 'Đăng ký';
  final String errorDefault =
      'Email hoặc mật khẩu không hợp lệ. Vui lòng thử lại.';
  final String successMessage = 'Đăng nhập thành công!';
}

/// Register screen string tokens.
class _RegisterStrings {
  final String title = 'Tạo tài khoản';
  final String subtitle = 'Tham gia để quản lý kho thông minh hơn';
  final String fullNameLabel = 'Họ và tên';
  final String fullNameHint = 'Nhập họ và tên của bạn';
  final String usernameLabel = 'Tên đăng nhập';
  final String usernameHint = 'Nhập tên đăng nhập của bạn';
  final String passwordLabel = 'Mật khẩu';
  final String passwordHint = 'Nhập mật khẩu của bạn';
  final String confirmPasswordLabel = 'Xác nhận mật khẩu';
  final String confirmPasswordHint = 'Nhập lại mật khẩu của bạn';
  final String personalInfoSection = 'Thiết lập tài khoản';
  final String shopDetailsSection = 'Thông tin cửa hàng';
  final String shopNameLabel = 'Tên công ty / cửa hàng';
  final String shopNameHint = 'Nhập tên công ty của bạn';
  final String createButton = 'Tạo tài khoản';
  final String footerPrefix = 'Đã có tài khoản?';
  final String footerLink = 'Đăng nhập';
  final String errorRequiredFields =
      'Vui lòng điền đầy đủ các trường bắt buộc.';
  final String errorPasswordMismatch = 'Xác nhận mật khẩu không khớp.';
  final String errorDefault = 'Không thể tạo tài khoản. Vui lòng thử lại.';
  final String successMessage = 'Tạo tài khoản thành công. Vui lòng đăng nhập.';
}
