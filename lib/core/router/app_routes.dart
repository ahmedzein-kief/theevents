import 'package:event_app/vendor/vendor_home/vendor_settings/vendor_profile_settings_view.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/gift_card/gift_card_screen.dart';
import 'package:event_app/wallet/ui/screens/wallet_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../provider/shortcode_home_page_provider.dart';
import '../../vendor/vendor_home/vendor_coupons/vendor_coupon_view.dart';
import '../../vendor/vendor_home/vendor_coupons/vendor_create_coupon_view.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/best_seller_screens/best_seller.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/events_brands_screens/event_brand_view.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/fifty_discount_screens/discounts_screen.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/new_product.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_page.dart';
import '../../wallet/data/repo/wallet_repository.dart';
import '../../wallet/logic/deposit/deposit_cubit.dart';
import '../../wallet/logic/drawer/drawer_cubit.dart';
import '../../wallet/logic/wallet/wallet_cubit.dart';
import '../../wallet/ui/screens/add_funds_screen.dart';

class AppRoutes {
  /// +++++++++++++++++++++ USER SIDE HOME INFORMATION ICONS ROUTES +++++++++++++++++
  static const String home = '/';
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

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return {
      orderPage: (context) => const OrderPageScreen(),
      newProduct: (context) => const NewProductPageScreen(),
      giftCard: (context) => const GiftCardScreen(),
      eventBrand: (context) => const EventBrandScreen(),
      bestSeller: (context) => const BestSellerScreen(),
      discountScreen: (context) => const DiscountScreen(),
      vendorProfileSettingsView: (context) => VendorProfileSettingsView(),
      vendorCouponView: (context) => const VendorCouponView(),
      vendorCreateCouponView: (context) => const VendorCreateCouponView(),
      addFundsScreen: (context) => BlocProvider(
            create: (context) => DepositCubit(WalletRepositoryImpl()),
            child: const AddFundsScreen(),
          ),
      wallet: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => WalletCubit(WalletRepositoryImpl())..loadWalletData(),
              ),
              BlocProvider(
                create: (context) => DepositCubit(WalletRepositoryImpl()),
              ),
              BlocProvider(
                create: (context) => DrawerCubit(),
              ),
            ],
            child: const WalletDrawer(),
          ),
    };
  }
}
