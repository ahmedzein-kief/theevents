class ApiEndpoints {
  static const String baseUrl = 'https://apistaging.theevents.ae/api/v1/';
  static const String imageBaseURL = 'https://apistaging.theevents.ae/storage/';

  static const String payBaseURL = 'https://paystaging.theevents.ae/api/v1/';

  /*static const String baseUrl = 'https://events-api.clientswork.in/api/v1/';
  static const String imageBaseURL = 'https://events-api.clientswork.in/storage/';*/

  //   Urls Of Api Endpoints  new one
  static const String shortCode = '${baseUrl}pages/home';

  static const String searchBarSuggestion = '${baseUrl}search-bar';
  static const String homeSlider = '${baseUrl}simple-slider';
  static const String categoryViewAllBanner = '${baseUrl}pages/categories';
  static const String orderScreenBanner = '${baseUrl}pages/orders';
  static const String categoryViewAllItems = '${baseUrl}get-categories-paging';
  static const String newProductsBanner = '${baseUrl}pages/products';
  static const String newProducts = '${baseUrl}products';
  static const String categoryBanner = '${baseUrl}category/';
  static const String categoryProducts = '${baseUrl}products-category/';
  static const String categoryPackages = '${baseUrl}packages-category/';
  static const String giftCardBanner = '${baseUrl}pages/create-gift-card';
  static const String featureBrandsBanner = '${baseUrl}pages/brands';
  static const String featureBrandsAll = '${baseUrl}brands';
  static const String featuredBrandProducts = '${baseUrl}brand-products/';
  static const String featuredBrandPackages = '${baseUrl}brand-packages/';
  static const String featuredBrandsSlide = '${baseUrl}featured-brands';
  static const String bestSellerBanner = '${baseUrl}collections/best-sellers';
  static const String bestSellerProducts = '${baseUrl}collections/best-sellers/products';
  static const String bestSellerPackages = '${baseUrl}collections/best-sellers/packages';
  static const String fiftyPercentDiscountBanner = '${baseUrl}collections/50-discount';
  static const String fiftyPercentDiscountProducts = '${baseUrl}collections/50-discount/products';
  static const String fiftyPercentDiscountPackages = '${baseUrl}collections/50-discount/packages';

  static const String eventsBazaarList = '${baseUrl}countries/bazaar';

  static const String eventsBazaarBanner = '${baseUrl}pages/event-bazaar-coming-soon';
  static const String userByTypeBanner = '${baseUrl}vendor-type-by-id/';
  static const String userByTypeStores = '${baseUrl}stores';
  static const String homeBrands = '${baseUrl}theme-ad/';
  static const String homeProducts = '${baseUrl}products';
  static const String homeProductsViewAllBanner = '${baseUrl}pages/tags';
  static const String wishList = '${baseUrl}wishlist/';
  static const String wishlistItems = '${baseUrl}wishlist';
  static const String eComTagsAll = '${baseUrl}ecom-tags';
  static const String products = '${baseUrl}products/';
  static const String homeUserStores = '${baseUrl}stores';
  static const String customerByType = '${baseUrl}customers-by-type';
  static const String homeVendorData = '${baseUrl}vendor-data/';
  static const String userByTypeProducts = '${baseUrl}products';
  static const String userByTypePackages = '${baseUrl}packages';
  static const String getCustomer = '${baseUrl}customer/me';
  static const String privacyPolicy = '${baseUrl}pages/privacy-policy';
  static const String termsAndConditions = '${baseUrl}pages/terms-conditions';
  static const String customerReviews = '${baseUrl}reviews/';

  static const String eComBanner = '${baseUrl}ecom-tag/';
  static const String addToCart = '${baseUrl}cart/add-to-cart';
  static const String cartItems = '${baseUrl}cart';

  // static const String cartRemove = '${baseUrl}cart/remove/';
  static const String cartRemove = '${baseUrl}cart/remove-m/';
  static const String brands = '${baseUrl}brands';
  static const String updateCart = '${baseUrl}cart/update';
  static const String productsECom = '${baseUrl}tag-products/';
  static const String packagesECom = '${baseUrl}tag-packages/';
  static const String countryList = '${baseUrl}countries/list';
  static const String cityList = '${baseUrl}cities/list';
  static const String stateList = '${baseUrl}states/list';

  static const String createCustomerAddress = '${baseUrl}customer/address/create';

  static const String customerAddressList = '${baseUrl}customer/address/list';

  static const String paymentMethods = '${payBaseURL}payment-methods';
  static const String brandStore = '${baseUrl}stores/';
  static const String eventBrandProducts = '${baseUrl}collections/events-brand/products';
  static const String eventBrandPackages = '${baseUrl}collections/events-brand/packages';
  static const String changePassword = '${baseUrl}customer/change-password';
  static const String editAccount = '${baseUrl}customer/edit-account';

  static const String createGiftCard = '${baseUrl}gift-cards/create';

  static const String customerAddressEdit = '${baseUrl}customer/address/edit/';
  static const String customerAddressDelete = '${baseUrl}customer/address/delete/';

  static const String forgotPassword = 'forgot-password';
  static const String vendorTypes = 'vendor-types';

  static const String login = '${baseUrl}login';

  static const String logout = '${baseUrl}logout';
  static const String signUp = 'register';
  static const String homeBanner = '/simple-slider?key=home-slider';
  static const String featuredBrands = '${baseUrl}brands/';
  static const String checkout = '${baseUrl}checkout/';
  static const String customerOrders = '${baseUrl}customer/orders';
  static const String customerOrdersView = '${baseUrl}customer/orders/view';
  static const String customerOrdersCancel = '${baseUrl}customer/orders/cancel';
  static const String customerOrdersPrint = '${baseUrl}customer/orders/print';
  static const String customerDelete = '${baseUrl}customer/delete';
  static const String couponApply = '${baseUrl}coupon/apply';
  static const String couponRemove = '${baseUrl}coupon/remove';
  static const String productVariations = '${baseUrl}product-variation/';
  static const String uploadProof = 'upload-proof';
  static const String downloadProof = 'download-proof';

  /// upload Profile Picture
  static const String customerUploadProfilePic = '${baseUrl}customer/avatar';

  /// get product reviews
  static const String customerGetProductReviews = '${baseUrl}customer/product-reviews';

  /// submit customer review
  static const String customerSubmitReview = '${baseUrl}review/create';

  /// customer delete review
  static const String customerDeleteReview = '${baseUrl}review/delete/';

  static const String getAllActiveLanguages = '${baseUrl}languages';
}

class CommonVariables {
  static int currentPage = 1;
  static bool isFetchingMore = false;
  static String selectedSortBy = 'default_sorting';
  static bool isLoadingProducts = false;
}
