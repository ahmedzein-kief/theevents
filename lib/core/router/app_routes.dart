import 'package:event_app/vendor/vendor_home/vendor_settings/vendor_profile_settings_view.dart';
import 'package:event_app/wallet/logic/history/history_cubit.dart';
import 'package:event_app/wallet/ui/screens/wallet_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../vendor/vendor_home/vendor_coupons/vendor_coupon_view.dart';
import '../../vendor/vendor_home/vendor_coupons/vendor_create_coupon_view.dart';
import '../../views/auth_screens/splash_screen.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/best_seller_screens/best_seller.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/events_brands_screens/event_brand_view.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/fifty_discount_screens/discounts_screen.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/gift_card/gift_card_list_screen.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/new_product.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_page.dart';
import '../../wallet/logic/deposit/deposit_cubit.dart';
import '../../wallet/logic/drawer/drawer_cubit.dart';
import '../../wallet/logic/fund_expiry/fund_expiry_cubit.dart';
import '../../wallet/logic/notification/notification_cubit.dart';
import '../../wallet/logic/wallet/wallet_cubit.dart';
import '../../wallet/ui/screens/fund_expiry_alert_screen.dart';
import '../helper/di/locator.dart';
import '../widgets/bottom_navigation_bar.dart';

class AppRoutes {
  /// +++++++++++++++++++++ USER SIDE HOME INFORMATION ICONS ROUTES +++++++++++++++++
  static const String home = '/';
  static const String homeScreen = '/homeScreen';
  static const String orderPage = '/orderPage';
  static const String newProduct = '/newProduct';
  static const String giftCard = '/giftCard';
  static const String eventBrand = '/eventBrand';
  static const String bestSeller = '/bestSeller';
  static const String discountScreen = '/discountScreen';

  static const String vendorDashboardView = '/vendorDashboardView';
  static const String vendorProfileSettingsView = '/vendorProfileSettingsView';
  static const String vendorCouponView = '/vendorCouponView';
  static const String vendorCreateCouponView = '/vendorCreateCouponView';
  static const String vendorEditOrderView = '/vendorEditOrderView';
  static const String wallet = '/wallet';
  static const String addFundsScreen = '/AddFundsScreen';
  static const String fundExpiryAlertScreen = '/fundExpiryAlertScreen';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Optional: Helper method to get route arguments safely
    T? getArguments<T>() {
      final arguments = settings.arguments;
      if (arguments is T) {
        return arguments;
      }
      return null;
    }

    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: settings,
        );

      case '/homeScreen':
        return MaterialPageRoute(
          builder: (context) => const BaseHomeScreen(),
          settings: settings,
        );

      case orderPage:
        return MaterialPageRoute(
          builder: (context) => const OrderPageScreen(),
          settings: settings,
        );

      case newProduct:
        return MaterialPageRoute(
          builder: (context) => const NewProductPageScreen(),
          settings: settings,
        );

      case giftCard:
        return MaterialPageRoute(
          builder: (context) => const GiftCardListScreen(),
          settings: settings,
        );

      case eventBrand:
        return MaterialPageRoute(
          builder: (context) => const EventBrandScreen(),
          settings: settings,
        );

      case bestSeller:
        return MaterialPageRoute(
          builder: (context) => const BestSellerScreen(),
          settings: settings,
        );

      case discountScreen:
        return MaterialPageRoute(
          builder: (context) => const DiscountScreen(),
          settings: settings,
        );

      case vendorProfileSettingsView:
        return MaterialPageRoute(
          builder: (context) => VendorProfileSettingsView(),
          settings: settings,
        );

      case vendorCouponView:
        return MaterialPageRoute(
          builder: (context) => const VendorCouponView(),
          settings: settings,
        );

      case vendorCreateCouponView:
        return MaterialPageRoute(
          builder: (context) => const VendorCreateCouponView(),
          settings: settings,
        );

      case fundExpiryAlertScreen:
        final walletCubit = getArguments<WalletCubit>();

        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => locator<FundExpiryCubit>()..loadExpiringFunds(),
              ),
              if (walletCubit != null)
                BlocProvider<WalletCubit>.value(value: walletCubit)
              else
                BlocProvider(
                  create: (context) => locator<WalletCubit>()..loadWalletData(),
                ),
            ],
            child: const FundExpiryAlertScreen(),
          ),
          settings: settings,
        );

      case wallet:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => locator<WalletCubit>()..loadWalletData(),
              ),
              BlocProvider(
                create: (context) => locator<DepositCubit>(),
              ),
              BlocProvider(
                create: (context) => locator<HistoryCubit>(),
              ),
              BlocProvider(
                create: (context) => locator<NotificationsCubit>(),
              ),
              BlocProvider(
                create: (context) => DrawerCubit(),
              ),
            ],
            child: const WalletDrawer(),
          ),
          settings: settings,
        );

      default:
        // Return null to let Flutter handle unknown routes
        // or return a custom 404 page
        return null;

      // Alternative: Return a 404 page
      // return MaterialPageRoute(
      //   builder: (context) => const NotFoundPage(),
      //   settings: settings,
      // );
    }
  }
}
