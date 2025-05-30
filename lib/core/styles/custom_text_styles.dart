import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle homeLocationStyle() {
  return GoogleFonts.inter(textStyle: const TextStyle(overflow: TextOverflow.ellipsis), fontSize: 10, fontWeight: FontWeight.w300);
}

TextStyle homeSearchStyle() {
  return GoogleFonts.inter(textStyle: const TextStyle(overflow: TextOverflow.ellipsis), fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey);
}

TextStyle homeItemsStyle(context) {
  return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary, textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
}

TextStyle homeEventsBazaarStyle(context) {
  return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary, textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
}

TextStyle homeFreshPicksItemName() {
  return const TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: 10,
      fontFamily: "FontSf",
      // color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.w700);
}

TextStyle productCategoryItemName() {
  return const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 10, color: Colors.white, fontFamily: "FontSf", fontWeight: FontWeight.w700);
}

TextStyle packagesProduct() {
  return const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12, color: Colors.white, fontFamily: "FontSf", fontWeight: FontWeight.bold);
}

TextStyle homeFreshPicksPrices() {
  return const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 14, fontFamily: "FontSf", fontWeight: FontWeight.w900);
}

TextStyle homeFreshPicksBy() {
  return const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 8, fontFamily: "FontSf", fontWeight: FontWeight.w500);
}

TextStyle homeSeeAllTextStyle() {
  return const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500);
}

TextStyle twoSliderAdsTextStyle() {
  return GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
  );
}

// ----------------------------------------------------------------    style fo like items        ++++++++++++++++++++++++++++++++++++++++++

TextStyle soldByStyle(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle optionTitle(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle wishTopItemStyle(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    fontSize: 10,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle wishItemDescription() {
  return GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 10);
}

TextStyle wishItemSalePrice(context) {
  return GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 10, decoration: TextDecoration.lineThrough, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle wishItemSaleOff() {
  return GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.deepOrangeAccent);
}

TextStyle cartItemQty(context) {
  return GoogleFonts.inter(fontWeight: FontWeight.w300, fontSize: 14, color: Theme.of(context).colorScheme.onPrimary);
}
//      ----------------------------------------------------------------   styles of featured categories ----------------------------------------------------------------

TextStyle featureCategoryName(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    textStyle: TextStyle(
      overflow: TextOverflow.ellipsis,
    ),
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle recommandName(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w100,
    fontSize: 16,
    textStyle: TextStyle(
      overflow: TextOverflow.ellipsis,
    ),
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle ratings(context) {
  return GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      textStyle: TextStyle(
        overflow: TextOverflow.ellipsis,
      ),
      // color:  Theme.of(context).colorScheme.primary
      color: AppColors.darkGray);
}

TextStyle productsName(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w300,
    fontSize: 10,
    textStyle: TextStyle(
      overflow: TextOverflow.ellipsis,
    ),
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle priceStyle(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    fontSize: 10,
    textStyle: const TextStyle(
      overflow: TextOverflow.ellipsis,
    ),
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle standardPriceStyle(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 8,
    textStyle: const TextStyle(
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.lineThrough,
    ),
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

//    ----------------------------------------------------------------   events bazaar styles   ----------------------------------------------------------------

TextStyle eventsBazaarDetail(context) {
  return GoogleFonts.jomhuria(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

///    =====================================================                style for profile Page          ============================================

TextStyle profileItems(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle labelHeading(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    // color: Colors.black.withOpacity(0.6)
    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
  );
}

TextStyle labelPaymentHeading(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    // color: Colors.black.withOpacity(0.6)
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle description(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    wordSpacing: 3,
    // color: Colors.black.withOpacity(0.6)
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle shippingMethod(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    wordSpacing: 3,
    // color: Colors.black.withOpacity(0.6)
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle payments(context) {
  return TextStyle(
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8), fontFamily: "FontSf", overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w700, fontSize: 18);
}

TextStyle reviewTabs(context) {
  return TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontFamily: "FontSf", fontWeight: FontWeight.w400, fontSize: 14);
}

TextStyle backTextStyle(context) {
  return TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontFamily: "FontSf", fontWeight: FontWeight.w700, fontSize: 17);
}

TextStyle profileItemsTextStyle() {
  return TextStyle(color: Colors.grey, fontFamily: "FontSf", fontWeight: FontWeight.w700, fontSize: 17);
}

TextStyle checkOutStyle(context) {
  return GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle mainHead(context) {
  return TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontFamily: "FontSf", fontWeight: FontWeight.w700);
}

TextStyle chooseStyle(context) {
  return TextStyle(
      fontSize: 20, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6), fontFamily: "FontSf", overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w700);
}

TextStyle boldHomeTextStyle() {
  return const TextStyle(
      fontSize: 16,
      // color: Theme.of(context).colorScheme.onPrimary,
      fontFamily: "FontSf",
      fontWeight: FontWeight.w700);
}

TextStyle withoutLoginTextStyle() {
  return const TextStyle(overflow: TextOverflow.ellipsis, fontFamily: "FontSf", fontSize: 20, fontWeight: FontWeight.w700);
}

//  +================================================================  style for fresh picks items see all =================================================================

TextStyle styleForItems(context) {
  return GoogleFonts.jomhuria(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: Theme.of(context).colorScheme.onSecondary,
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
  );
}

//  +================================================================  style for logout screen =================================================================

TextStyle textStyleLogoutTop(context) {
  return GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w100,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

TextStyle textStyleLogoutNoAC(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w200, color: Theme.of(context).colorScheme.onPrimary, textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
}

//  +================================================================  style for login  us screen =================================================================

TextStyle loginTextStyle(context) {
  return GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimary, textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
}

TextStyle loginOrStyle(context) {
  return GoogleFonts.inter(
      fontSize: 24, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSecondary, textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
}

TextStyle loginTermsConditionStyle(context) {
  return GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSecondary, textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
}

TextStyle loginTextFieldStyle(context) {
  return GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey, textStyle: const TextStyle(overflow: TextOverflow.ellipsis));
}

//  +================================================================  style for SignUp  us screen =================================================================

TextStyle signupPasswordConditionStyle(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSecondary);
}

//  +================================================================  style for WISHLIST  us screen =================================================================

TextStyle wishListText(context) {
  return GoogleFonts.inter(fontSize: 19, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle addToCartText(context) {
  return GoogleFonts.inter(fontSize: 17, textStyle: TextStyle(overflow: TextOverflow.ellipsis), fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary);
}

//  +================================================================  style for CartItems    us screen =================================================================

TextStyle cartSubtotal(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.totalItemsText);
}

TextStyle cartTotal(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.totalItemsText);
}

TextStyle shippingFeesText(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w200, color: Theme.of(context).colorScheme.onPrimary
      // color: AppColors.totalItemsText
      );
}

TextStyle shippingCheckoutText(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, textStyle: const TextStyle(overflow: TextOverflow.ellipsis), color: Theme.of(context).colorScheme.primary);
}

//  +================================================================  style for SaveAddress  us screen =================================================================

TextStyle saveAddressText(context) {
  return GoogleFonts.inter(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
      // color: Theme.of(context).colorScheme.primary
      color: AppColors.totalItemsText);
}

//  +================================================================  style for Payment screen =================================================================

TextStyle paymentText(context) {
  return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
      // color: Theme.of(context).colorScheme.primary
      color: AppColors.lightCoral);
}

TextStyle paymentOptionText(context) {
  return GoogleFonts.inter(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
      // color: Theme.of(context).colorScheme.primary
      color: AppColors.darkGray);
}

//  +================================================================  style for Cart Empty screen =================================================================

TextStyle cartTextStyle(context) {
  return GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimary);
}

//  +================================================================  style for Inner Items userByType =================================================================

TextStyle holderNameTextStyle(context) {
  return GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle holderTypeTextStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w100, color: Theme.of(context).colorScheme.onPrimary);
}

//  +================================================================  style for FeaturedBrandScreen =================================================================

TextStyle featuredBrandText(context) {
  return GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimary);
}

//  +================================================================  style for GiftCard =================================================================

TextStyle giftSelectAmountText(context) {
  return GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle payNowText(context) {
  return GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.primary);
}

TextStyle headingStyleText(context) {
  return GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle headingDescriptionStyleText(context) {
  return GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle specificationStyleText(context) {
  return GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimary);
}

//  +================================================================  style for Privacy Policy  =================================================================

TextStyle profileStyleText(context) {
  return GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle profileNameStyle() {
  return const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 22, fontFamily: "FontSf", fontWeight: FontWeight.w700);
}

TextStyle privacyPolicyTextStyle(context) {
  return GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle infoTextStyle(context) {
  return GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary);
}

//  +================================================================  style for About Us  Policy  =================================================================

TextStyle headingTextStyle(context) {
  return GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle headingsTextStyle(context) {
  return GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle ourItemsStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w200, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle ourItemsTextStyle(context) {
  return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w200, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle valueItemsStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary);
}

//  +================================================================  style for PRODUCT VIEW  PAGE  =================================================================

TextStyle productValueItemsStyle(context) {
  return GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle productPriceStyle(context) {
  return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.lineThrough,
      // color: Theme.of(context).colorScheme.onPrimary
      color: Colors.grey);
}

TextStyle productDescription(context) {
  return GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle sizeGuide(context) {
  return GoogleFonts.josefinSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      // Add underline
      decorationColor: AppColors.peachyPink,
      // Optional: specify the underline color

      color: AppColors.peachyPink);
}

TextStyle productsReviewDescription(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w200, color: AppColors.darkGray);
}

TextStyle viewShopText(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w200, color: Colors.blue);
}

TextStyle addToWiShListText(context) {
  return GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary);
}

//  +================================================================  style for ORDER PAGE  =================================================================

TextStyle orderText(context) {
  return GoogleFonts.inter(fontSize: 12, textStyle: const TextStyle(overflow: TextOverflow.ellipsis), fontWeight: FontWeight.w500, color: AppColors.myRed);
}

TextStyle orderDateText(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle orderNameText(context) {
  return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle productReviewText(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w200, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle productDetailText(context) {
  return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w200, color: Theme.of(context).colorScheme.onPrimary);
}

//  +================================================================  style for ORDER CONFIRMATION PAGE  =================================================================

TextStyle orderPlaceText(context) {
  return GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle orderExpectDateText(context) {
  return GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w300, color: AppColors.forestGreen);
}

TextStyle itemsText(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.totalItemsText);
}

TextStyle itemsHeadText(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.totalItemsText);
}

TextStyle itemsTypeText(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle itemsColorText(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w200, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle itemsTitleText(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.totalItemsText);
}

TextStyle totalPriceStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.totalItemsText);
}

TextStyle totalStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle deliveryMethodsStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w300, color: AppColors.totalItemsText);
}

TextStyle standardStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w300, color: AppColors.totalItemsText);
}

TextStyle addressStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.totalItemsText);
}

TextStyle returnStyle(context) {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary);
}

TextStyle shotCodeInfoTextStyle(context) {
  return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.darkGray);
}

TextStyle standardTextStyle(context) {
  return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.onPrimary);
}

//  ------------------------------------------------------------------------------------------------  UserProfileLoginStyle   ------------------------------------------------------------------------------------------------

TextStyle accountTextStyle(context) {
  return GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary);
}

TextStyle nameTextStyle(context) {
  return const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 20, fontFamily: "FontSf", fontWeight: FontWeight.w700);
}

TextStyle mailTextStyle(context) {
  return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onPrimary,
      textStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
      ));
}

TextStyle logoutTextStyle(context) {
  return GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary);
}

TextStyle deleteTextStyle(context) {
  return GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.deleteAccount);
}

//  ------------------------------------------------------------------------------------------------  VendorByTypeStyle   ------------------------------------------------------------------------------------------------

TextStyle topTabBarStyle(context) {
  return GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black);
}

//  ------------------------------------------------------------------------------------------------  sorting_Styles   ------------------------------------------------------------------------------------------------

TextStyle sortingStyle(context) {
  return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary);
}
