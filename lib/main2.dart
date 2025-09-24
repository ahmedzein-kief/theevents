import 'package:event_app/core/router/app_routes.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/provider/auth_provider/forgot_password.dart';
import 'package:event_app/provider/auth_provider/get_user_provider.dart';
import 'package:event_app/provider/auth_provider/user_auth_provider.dart';
import 'package:event_app/provider/cart_item_provider/cart_item_provider.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/provider/checkout_provider/submit_checkout_information.dart';
import 'package:event_app/provider/home_information_icon_events_brands/events_brand_banner_provider.dart';
import 'package:event_app/provider/home_information_icon_events_brands/product_packages_events_brand.dart';
import 'package:event_app/provider/home_shortcode_provider/banner_ads_provider.dart';
import 'package:event_app/provider/home_shortcode_provider/featured_brands_items_provider.dart';
import 'package:event_app/provider/home_shortcode_provider/featured_brands_provider.dart';
import 'package:event_app/provider/home_shortcode_provider/simple_slider_provider.dart';
import 'package:event_app/provider/home_shortcode_provider/users_by_type_provider.dart';
import 'package:event_app/provider/home_shortcode_provider/vendor_by_types_provider.dart';
import 'package:event_app/provider/information_icons_provider/best_seller_provider.dart';
import 'package:event_app/provider/information_icons_provider/fifty_discount_provider.dart';
import 'package:event_app/provider/information_icons_provider/gift_card_payments_provider.dart';
import 'package:event_app/provider/information_icons_provider/gift_card_provider.dart';
import 'package:event_app/provider/information_icons_provider/new_products_provider.dart';
import 'package:event_app/provider/login_profile_provider/change_password.dart';
import 'package:event_app/provider/login_profile_provider/profile_update.dart';
import 'package:event_app/provider/orders_provider/order_data_provider.dart';
import 'package:event_app/provider/payment_address/create_address_provider.dart';
import 'package:event_app/provider/payment_address/customer_address.dart';
import 'package:event_app/provider/payment_address/customer_edit.dart';
import 'package:event_app/provider/product_package_provider/packages_provider.dart';
import 'package:event_app/provider/product_package_provider/product_details_provider.dart';
import 'package:event_app/provider/product_package_provider/product_provider.dart';
import 'package:event_app/provider/search_bar_provider/search_bar_provider.dart';
import 'package:event_app/provider/shortcode_events_bazaar_provider/events_bazaar_provider.dart';
import 'package:event_app/provider/shortcode_featured_categories_provider/featured_categories_detail_provider.dart';
import 'package:event_app/provider/shortcode_featured_categories_provider/featured_categories_provider.dart';
import 'package:event_app/provider/shortcode_fresh_picks_provider/eCom_Tags_brands_Provider.dart';
import 'package:event_app/provider/shortcode_fresh_picks_provider/eCom_tags_provider.dart';
import 'package:event_app/provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import 'package:event_app/provider/shortcode_home_page_provider.dart';
import 'package:event_app/provider/shortcode_vendor_type_by_provider/vendor_type_by_provider.dart';
import 'package:event_app/provider/store_provider/brand_store_provider.dart';
import 'package:event_app/provider/theme_notifier.dart';
import 'package:event_app/provider/user_order_provider/order_banner_provider.dart';
import 'package:event_app/provider/vendor/vendor_sign_up_provider.dart';
import 'package:event_app/provider/wishlist_items_provider/wishlist_provider.dart';
import 'package:event_app/vendor/view_models/dashboard/vendor_dashboard_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_delete_coupon_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_get_coupons_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_order_returns/vendor_order_returns_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_delete_order_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_generate_order_invoice_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_get_order_details_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_get_orders_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_packages/vendor_get_packages_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_get_products_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_revenues/vendor_revenues_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_reviews/vendor_reviews_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_get_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_withdrawal/vendor_withdrawal_view_model.dart';
import 'package:event_app/views/profile_page_screens/privacy_policy_screen.dart';
import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('wishlist');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SecurePreferencesUtil.init(); // Initialize shared preferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(create: (_) => TopSliderProvider()),
          ChangeNotifierProvider(create: (_) => BottomSliderProvider()),
          ChangeNotifierProvider(create: (_) => FeaturedCategoriesProvider()),
          ChangeNotifierProvider(create: (_) => BannerAdsProvider()),
          ChangeNotifierProvider(create: (_) => VendorByTypesProvider()),
          ChangeNotifierProvider(create: (_) => UsersByTypeProvider()),
          ChangeNotifierProvider(create: (_) => FeaturedBrandsProvider()),
          ChangeNotifierProvider(create: (_) => FeaturedBrandsItemsProvider()),
          ChangeNotifierProvider(
            create: (_) => FeaturedCategoriesDetailProvider(),
          ),
          ChangeNotifierProvider(create: (_) => HomePageProvider()),
          ChangeNotifierProvider(create: (_) => EventBazaarProvider()),
          ChangeNotifierProvider(create: (_) => FreshPicksProvider()),
          ChangeNotifierProvider(create: (_) => VendorByTypeProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => PackageProvider()),
          ChangeNotifierProvider(create: (_) => NewProductsProvider()),
          ChangeNotifierProvider(create: (_) => ProductItemsProvider()),
          ChangeNotifierProvider(create: (_) => GiftCardInnerProvider()),
          ChangeNotifierProvider(create: (_) => BestSellerProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FiftyPercentDiscountProvider()),
          ChangeNotifierProvider(create: (_) => EComTagProvider()),
          ChangeNotifierProvider(create: (_) => SearchBarProvider()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
          ChangeNotifierProvider(create: (_) => PrivacyPolicyProvider()),
          ChangeNotifierProvider(create: (_) => TermsAndConditionProvider()),
          ChangeNotifierProvider(create: (_) => EComBrandsProvider()),
          ChangeNotifierProvider(create: (_) => StoreProvider()),
          ChangeNotifierProvider(create: (_) => AddressProvider()),
          ChangeNotifierProvider(
            create: (_) => PaymentMethodProviderGiftCard(),
          ),
          ChangeNotifierProvider(create: (_) => EventsBrandProvider()),
          ChangeNotifierProvider(create: (_) => EventsBrandProductProvider()),
          ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
          ChangeNotifierProvider(create: (_) => ProfileUpdateProvider()),
          ChangeNotifierProvider(create: (_) => CreateGiftCardProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => CustomerAddressProvider()),
          ChangeNotifierProvider(create: (_) => CustomerAddress()),
          ChangeNotifierProvider(create: (_) => UserOrderProvider()),
          ChangeNotifierProvider(create: (_) => CheckoutProvider()),
          ChangeNotifierProvider(
            create: (_) => SubMitCheckoutInformationProvider(),
          ),
          ChangeNotifierProvider(create: (_) => OrderDataProvider()),
          ChangeNotifierProvider(create: (_) => VendorSignUpProvider()),

          /// Vendor view models registration
          ChangeNotifierProvider(create: (_) => VendorGetProductsViewModel()),
          ChangeNotifierProvider(create: (_) => VendorCreateProductViewModel()),
          ChangeNotifierProvider(create: (_) => VendorGetPackagesViewModel()),
          ChangeNotifierProvider(create: (_) => VendorGetCouponsViewModel()),
          ChangeNotifierProvider(create: (_) => VendorGetSettingsViewModel()),
          ChangeNotifierProvider(create: (_) => VendorSettingsViewModel()),
          ChangeNotifierProvider(create: (_) => VendorDeleteCouponViewModel()),
          ChangeNotifierProvider(create: (_) => VendorDashboardViewModel()),

          /// vendor orders
          ChangeNotifierProvider(create: (_) => VendorGetOrdersViewModel()),
          ChangeNotifierProvider(
            create: (_) => VendorGetOrderDetailsViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => VendorGenerateOrderInvoiceViewModel(),
          ),
          ChangeNotifierProvider(create: (_) => VendorOrderReturnsViewModel()),
          ChangeNotifierProvider(create: (_) => VendorWithdrawalsViewModel()),
          ChangeNotifierProvider(create: (_) => VendorReviewsViewModel()),
          ChangeNotifierProvider(create: (_) => VendorRevenuesViewModel()),
          ChangeNotifierProvider(create: (_) => VendorDeleteOrderViewModel()),
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, theme, child) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
                // Use light icons on a dark status bar
                statusBarBrightness: Brightness.dark,
                // Use dark status bar background
                statusBarColor: theme.isLightTheme ? Colors.black : Colors.transparent, // Adjust based on theme
                // statusBarColor: AppColors.peachyPink
              ),
              child: MaterialApp(
                theme: lightTheme,
                darkTheme: darkTheme,
                title: 'Events',
                debugShowCheckedModeBanner: false,
                themeMode: theme.isLightTheme ? ThemeMode.light : ThemeMode.dark,
                onGenerateRoute: AppRoutes.onGenerateRoute,
                initialRoute: AppRoutes.home, // This will show SplashScreen first
              ),
            );
          },
        ),
      );
}

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    onSecondary: AppColors.semiTransparentBlack,
    onErrorContainer: Colors.blue[50],
    primary: Colors.white,
    secondary: Colors.black,
    onPrimary: Colors.black,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.peachyPink,
    selectionColor: AppColors.peachyPink,
    selectionHandleColor: AppColors.peachyPink,
  ),
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.bgColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.bgColor,
    elevation: 0.5,
    shadowColor: Colors.grey,
    titleTextStyle: TextStyle(color: Colors.black),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    onSecondary: Colors.white,
    onErrorContainer: Colors.grey,
    primary: Colors.black,
    secondary: Colors.grey[800]!,
    onPrimary: Colors.white,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.peachyPink,
    selectionColor: AppColors.peachyPink,
    selectionHandleColor: AppColors.peachyPink,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey.withAlpha((0.5 * 255).toInt()),
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0.5,
    shadowColor: AppColors.lightCoral,
    titleTextStyle: TextStyle(color: Colors.white),
  ),
);
