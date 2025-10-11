class VendorApiEndpoints {
  static const String baseUrl = 'https://apistaging.theevents.ae/api/v1/vendor/';
  static const String baseUrlSettings = 'https://apistaging.theevents.ae/api/v1/';
  static const String imageBaseURL = 'https://apistaging.theevents.ae/storage/';
  static const String vendorProductBaseUrl = 'https://theevents.ae/products/';

  /*static const String baseUrl = 'https://events-api.clientswork.in/api/v1/';
  static const String imageBaseURL = 'https://events-api.clientswork.in/storage/';*/

  //   Urls Of Api Endpoints  new one
  static const String signup = '${baseUrl}register';
  static const String meta = '${baseUrl}meta';
  static const String vendorTypes = 'https://apistaging.theevents.ae/api/v1/getVendorsTypes';
  static const String vendorPermissions = '${baseUrl}getPermissions';
  static const String settingsSubscription = '${baseUrlSettings}settings/subscription';
  static const String pay = '${baseUrlSettings}payment-methods';
  static const String emailResend = '${baseUrlSettings}email/resend';
  static const String previewAgreement = '${baseUrl}preview-agreement';
  static const String downloadAgreement = '${baseUrl}download-agreement';
  static const String getAgreementUrl = '${baseUrl}get-agreement-url';

  /// product
  static String get vendorProducts => '${baseUrl}products';

  static String get vendorGetProductGeneralSettings => '${baseUrl}products/general-settings';

  static String get vendorAttributeSets => '${baseUrl}products/attribute-sets';

  static String get vendorGetProductTags => '${baseUrl}ajax/tags';

  static String get vendorCreateProductSlug => '${baseUrl}products/create-slug';

  static String get globalOptions => '${baseUrl}ajax/global-option';

  static String get searchProduct => '${baseUrl}products/get-list-product-for-search';

  static String get vendorGetProductSeoKeywords => '${baseUrl}ajax/get-seo-keywords';

  static String get vendorGetProductVariations => '${baseUrl}products/product-versions/';

  static String get vendorSetDefaultProductVariation => '${baseUrl}products/set-default-product-version/';

  static String get vendorGenerateAllProductVariations => '${baseUrl}products/generate-all-version/';

  static String get vendorGetSelectedProductAttributes => '${baseUrl}products/attribute-sets/';

  static String get vendorEditProductAttributes => '${baseUrl}products/store-related-attributes/';

  static String get vendorCreateProduct => '${baseUrl}products/create';

  static String get vendorUploadImages => '${baseUrl}ajax/upload';

  static String get vendorDeleteProduct => '${baseUrl}products/';

  static String get vendorUpdateProduct => '${baseUrl}products/update/';

  static String get vendorGetVersion => '${baseUrl}products/get-version/';

  static String get vendorUpdateProductVariation => '${baseUrl}products/update-version/';

  static String get vendorDeleteProductVariation => '${baseUrl}products/delete-version/';

  static String get vendorCreateProductVariation => '${baseUrl}products/add-version/';

  /// packages
  static String get vendorPackages => '${baseUrl}packages';

  static String get vendorGetPackageGeneralSettings => '${baseUrl}packages/general-settings';

  static String get vendorCreatePackage => '${baseUrl}packages/create';

  static String get vendorDeletePackage => '${baseUrl}packages/';

  static String get vendorViewPackage => '${baseUrl}packages/';

  static String get vendorUpdatePackage => '${baseUrl}packages/update/';

  static String get vendorDashboard => '${baseUrl}dashboard';

  static String get vendorGetCoupons => '${baseUrl}coupons';

  static String get vendorGenerateCouponCode => '${baseUrl}coupons/generate-coupon';

  static String get vendorCreateCoupon => '${baseUrl}coupons/create';

  static String get vendorDeleteCoupon => '${baseUrl}coupons/delete/';

  /// settings
  static String get vendorGetSettings => '${baseUrl}settings';

  static String get vendorStoreSettings => '${baseUrl}settings';

  static String get vendorTaxInfoSettings => '${baseUrl}settings/tax-info';

  static String get vendorPayoutInfoSettings => '${baseUrl}settings/payout';

  /// vendor withdrawals
  static String get vendorWithdrawals => '${baseUrl}withdrawals/index';

  static String get vendorCreateWithdrawal => '${baseUrl}withdrawals/create';

  static String get vendorUpdateWithdrawal => '${baseUrl}withdrawals/update/';

  static String get vendorCancelWithdrawal => '${baseUrl}withdrawals/cancel/';

  static String get vendorShowWithdrawal => '${baseUrl}withdrawals/show/';

  static String get vendorReviews => '${baseUrl}reviews';

  static String get vendorRevenues => '${baseUrl}revenues';

  /// orders
  static String get vendorGetOrders => '${baseUrl}orders';

  static String get vendorDeleteOrder => '${baseUrl}orders/delete/';

  static String get vendorGetOrderDetails => '${baseUrl}orders/show/';

  static String get vendorGenerateOrderInvoice => '${baseUrl}orders/generate-invoice/';

  static String get vendorUpdateShippingStatus => '${baseUrl}orders/update-shipping-status/';

  static String get vendorUpdateOrder => '${baseUrl}orders/update/';

  static String get vendorConfirmOrder => '${baseUrl}orders/confirm/';

  static String get vendorCancelOrder => '${baseUrl}orders/cancel-order/';

  static String get vendorSendConfirmationEmail => '${baseUrl}orders/send-order-confirmation-email/';

  static String get vendorOrderReturns => '${baseUrl}order-returns';

  static String get vendorUpdateShippingAddress => '${baseUrl}orders/update-shipping-address/';

  static String get addAttributeToProduct => '${baseUrl}products/add-attribute-to-product/';

  static String get rejectionHistory => '${baseUrl}rejection-history/';
}
