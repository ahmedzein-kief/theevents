import 'package:event_app/vendor/vendor_home/vendor_settings/vendor_profile_settings_view.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/gift_card/gift_card_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../provider/shortcode_home_page_provider.dart';
import '../vendor/vendor_home/vendor_coupons/vendor_coupon_view.dart';
import '../vendor/vendor_home/vendor_coupons/vendor_create_coupon_view.dart';
import '../views/base_screens/profile_screens/reviews/customer_submit_review_view.dart';
import '../views/home_screens_shortcode/shortcode_information_icons/best_seller_screens/best_seller.dart';
import '../views/home_screens_shortcode/shortcode_information_icons/events_brands_screens/event_brand_view.dart';
import '../views/home_screens_shortcode/shortcode_information_icons/fifty_discount_screens/discounts_screen.dart';
import '../views/home_screens_shortcode/shortcode_information_icons/new_product.dart';
import '../views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_page.dart';

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

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return {
      orderPage: (context) => const OrderPageScreen(),
      newProduct: (context) => const NewProductPageScreen(),
      giftCard: (context) => GiftCardScreen(),
      eventBrand: (context) => EventBrandScreen(),
      bestSeller: (context) => const BestSellerScreen(),
      discountScreen: (context) => const DiscountScreen(),
      vendorProfileSettingsView: (context) => VendorProfileSettingsView(),
      vendorCouponView: (context) => VendorCouponView(),
      vendorCreateCouponView: (context) => VendorCreateCouponView(),
    };
  }
}
