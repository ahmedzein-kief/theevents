import 'package:event_app/core/constants/vendor_app_strings.dart';

import 'app_strings.dart';

final Map<String, Map<String, String>> appTranslations = {
  // English
  'en': {
    'walletApplicable': 'Wallet Applicable',
    AppStrings.vendorSubscriptionOneYear: 'Vendor Subscription (1 Year)',
    AppStrings.vendorSubscriptionDescription: 'This is a one time fee for vendor registration.',
    'loginSuccessfully': 'Login successfully',
    'paidAmount': 'Paid Amount',
    'saveLower': 'Save',
    'shippingUp': 'SHIPPING',
    'statusUp': 'STATUS',
    'shippingMethodUp': 'SHIPPING METHOD',
    'downloadInvoice': 'Download Invoice',
    'ordersLower': 'orders',
    'updateShippingStatusFull': 'Update Shipping Status',
    'weightUp': 'WEIGHT (G)',
    'editOrder': 'Edit Order',
    'orderInformation': 'Order Information',
    'vendorSubscriptionExpired': 'Your subscription has finished',
    'youMustAddAddressFirstToContinue': 'You must add an address first to continue',
    'noShippingMethodAvailable': 'No shipping method available',
    'addingNewAttributesHelps': 'Adding new attributes helps the product to have many options, such as size or color.',
    'digitalLinks': 'Digital Links',
    'fileName': 'File Name',
    'externalLink': 'External Link',
    'size': 'Size',
    'saved': 'Saved',
    'unsaved': 'Unsaved',
    'authenticationFailed': 'Authentication failed. Please login again.',
    'authenticationRequired': 'Authentication required',
    'requestCancelled': 'Request cancelled',
    'failedToAddItemToCart': 'Failed to add item to cart',
    'somethingWentWrong': 'Something went wrong.',
    'anErrorOccurred': 'An error occurred. Please try again.',
    'failedToLoadCartData': 'Failed to load cart data.',
    'failedToLoadCheckoutData': 'Failed to load checkout data.',
    'anErrorOccurredDuringCheckout': 'An error occurred during checkout.',
    'anErrorOccurredWhileUpdatingCart': 'An error occurred while updating cart.',
    'noOrdersFound': 'No orders found.',
    'failedToLoadAddresses': 'Failed to load addresses.',
    'addressDeleteSuccess': 'Address deleted successfully!',
    'failedToDeleteAddress': 'Failed to delete address.',
    'errorDeletingAddress': 'An error occurred while deleting address.',
    'addressUpdateSuccess': 'Address updated successfully!',
    'invalidAddressData': 'Please enter valid data.',
    'failedToLoadData': 'Failed to load data.',
    'pleaseLoginWishlist': 'Please log in to manage your wishlist.',
    'wishlistUpdateFailed': 'Failed to update wishlist.',
    'unknownError': 'An unknown error occurred.',
    'pleaseSelectShipmentStatus': 'Please select a shipment status',
    'failedToUpdateShipmentStatus': 'Failed to update shipment status',
    'resendEmail': 'Resend Email',
    'paymentMethod': 'Payment Method',
    'paymentStatus': 'Payment Status',
    'shippingInformation': 'Shipping Information',
    'updateShippingStatus': 'Update Shipping Status',
    'errorFetchingProducts': 'Error fetching products',
    'camera': 'Camera',
    'gallery': 'Gallery',
    // Validator messages (English)
    'valEmailEmpty': 'Email cannot be empty',
    'valEmailInvalid': 'Enter a valid email address.',
    'valRequiredField': 'This field is required',
    'valUrlInvalid': 'Please enter a valid link',
    'valPhoneEmpty': 'Phone number cannot be empty',
    'valPhone9Digits': 'Phone number should be 9 digits long',
    'valPhoneDigitsOnly': 'Phone number should contain only numbers.',
    'valCompanyMobileRequired': 'Company mobile number is required',
    'valCompanyMobile9Digits': 'Company mobile number should be 9 digits long',
    'valCompanyMobileDigitsOnly': 'Company mobile number should contain only numbers.',
    'valLandlineRequired': 'Phone number (Landline) is required',
    'valLandline8Digits': 'Phone number (Landline) should be 8 digits long',
    'valLandlineDigitsOnly': 'Phone number (Landline) should contain only numbers.',
    'valPhoneRequired': 'Phone is required',
    'valGenderRequired': 'Please select gender',
    'valNameEmpty': 'Name cannot be empty',
    'valNameRequired': 'Name is required',
    'valNameMax25': 'Name cannot be more than 25 characters',
    'valBankNameRequired': 'Bank name is required',
    'valAccountNameRequired': 'Account name is required',
    'valAccountNumberRequired': 'Account number is required',
    'valRegionRequired': 'Please select region',
    'valCountryRequired': 'Please select country',
    'valEidRequired': 'Emirates ID number is required',
    'valEid15Digits': 'Emirates ID number must be 15 digits long.',
    'valCompanyCategoryRequired': 'Company category type is required',
    'valEidExpiryRequired': "EID number's expiry date is required",
    'valTradingNumberRequired': 'Trading number is required',
    'valTradingNumberLength': 'Trading License number must be between 10 and 15 characters long.',
    'valTradeLicenseExpiryRequired': "Trade License number's expiry date is required",
    'valFieldRequiredAlt': 'This Field cannot be empty.',
    'valCompanyAddressRequired': 'Company address is required',
    'valCompanyNameRequired': 'Company name is required',
    'valCompanyNameMax50': 'Company name cannot be more than 50 characters',
    'valCompanySlugRequired': 'Company slug is required',
    'valCompanySlugMax20': 'Company slug cannot be more than 20 characters',
    'valZipEmpty': 'Zip code cannot be empty',
    'valZip5Digits': 'Zip Code must be 5 digits long.',
    'valZipDigitsOnly': 'Zip Code should contain only numbers.',
    'valPasswordEmpty': 'Password cannot be empty.',
    'valPasswordMin9': 'Password should be at least 9 characters long.',
    'valPasswordPolicyFull':
        'Password must include at least one uppercase letter, one lowercase letter, one digit, and one special character.',
    'valVendorPasswordMin9': 'Password should be at least 9 characters long',
    'valVendorPasswordCaseReq': 'Password must contain at least one uppercase and one lowercase letter.',
    'valPaypalIdMax120': 'PayPal ID must not be greater than 120 characters.',
    'valPaypalEmailInvalid': 'Enter a valid PayPal email ID.',
    'valIFSCMax120': 'Bank code/IFSC must not be greater than 120 characters.',
    'valAccountNumberMax120': 'Account number must not be greater than 120 characters.',
    'valCouponsNumMin1': 'Number of coupons must be greater than or equal to 1',
    'valDiscountMin1': 'Discount must be greater than or equal to 1',
    'valPermalinkRequired': 'Product permanent link is required.',
    'valPermalinkUnique': 'Please generate unique permanent link.',
    'valStartDateAfterEnd': 'Start date cannot be after end date.',
    'valInvalidDateFormat': 'Invalid date format.',
    'valAddressRequired': 'Address field is required.',
    'valAddressMin5': 'Address must be at least 5 characters long.',
    'valAddressMax100': 'Address must not exceed 100 characters.',
    'valCityRequired': 'City field is required.',
    'valCityMin2': 'City name must be at least 2 characters long.',
    'valCityMax50': 'City name must not exceed 50 characters.',
    'valCityChars': 'City name can only contain letters, spaces, and hyphens.',
    'valIbanRequired': 'IBAN number is required',
    'valIbanLength': 'Invalid IBAN length',
    'valIbanFormat': 'Invalid IBAN format',
    'chooseDiscountPeriod': 'Choose discount period',
    'customerWontSeeThisPrice': 'Customers won\'t see this price',
    'In stock': 'In stock',
    'Out of stock': 'Out of Stock',
    'On backorder': 'On Backorder',
    'percentFromOriginalPrice': 'Percent from Original Price',
    'allowCustomerCheckoutWhenOut of stock': 'Allow customer checkout when out of stock',
    'stockStatus': 'Stock Status',
    'priceField': 'Price field',
    'priceFieldDescription':
        'Enter the amount you want to reduce from the original price. Example: If the original price is \$100, enter 20 to reduce the price to \$80.',
    'typeField': 'Type field',
    'typeFieldDescription':
        'Choose the discount type: Fixed (reduce a specific amount) or Percent (reduce by a percentage).',

    'searchProducts': 'Search products',
    'selectedProductAlreadyAdded': 'Selected product already added in the list',
    'pleaseSearchAndAddProducts': 'Please search and add products',
    'productOptionsDes': 'Please add product options on the tap of + button at bottom right corner.',
    'pleaseSelectType': 'Please select type',
    'selectSectionType': 'Select Section Type',
    'addGlobalOptions': 'Add Global Options',
    'addNewRow': 'Add new row',
    'selectFromExistingFAQs': 'Select from existing FAQs',
    'or': 'or',
    'add': 'Add',
    'addKeyword': 'Add Keyword',
    'addMoreAttribute': 'Add More Attribute',
    'pendingProducts': 'Pending Products',
    'pendingPackages': 'Pending Packages',
    'request': 'Request',
    'publish': 'Publish',
    'afterCancelAmountAndFeeWillBeRefundedBackInYourBalance':
        'After cancel, amount and fee will be refunded back in your balance.',
    'doYouWantToCancelThisWithdrawal': 'Do you want to cancel this withdrawal?',
    'youWillReceiveMoneyThroughTheInformation': 'You will receive money through the information:',
    'payoutInfo': 'Payout Info',

    'noRecordFound': 'No record found',
    'sku': 'SKU',
    'code': 'Code',
    'amount': 'Amount',
    'totalUsed': 'Total Used',
    'noGiftCardsFound': 'No gift cards found',
    'createFirstGiftCard': 'Create your first gift card',
    'createGiftCard': 'Create gift card',

    'becomeSeller': 'Become a seller',
    'yesBecomeSeller': 'Yes, become a seller',
    'becomeSellerConfirmation': 'Are you sure you want to become a seller?',
    'menu': 'Menu',
    'pleaseLogInToContinue': 'Please log in to continue',
    'pleaseAddNewAddress': 'Please add a new address',
    'pleaseSelectAnAddress': 'Please select an address',
    'other': 'Other',
    'Transaction Confirmations': 'Transaction Confirmations',
    'Deposits, purchases, confirmations': 'Deposits, purchases, confirmations',

    'Achievement Alerts': 'Achievement Alerts',
    'Milestones, rewards, goals': 'Milestones, rewards, goals',

    'Expiry Reminders': 'Expiry Reminders',
    'Product expiry, renewal alerts': 'Product expiry, renewal alerts',

    'Promotional Messages': 'Promotional Messages',
    'Marketing updates, special offers': 'Marketing updates, special offers',

    'Security Alerts': 'Security Alerts',
    'Login alerts, security updates': 'Login alerts, security updates',

    'System Updates': 'System Updates',
    'App updates, maintenance notices': 'App updates, maintenance notices',
    'database': 'Database',
    'sms': 'SMS',
    'broadcast': 'Broadcast',
    'mail': 'Mail',

    'Transaction': 'Transaction',
    'Expiry Reminder': 'Expiry Reminder',
    'Promotional': 'Promotional',
    'Security': 'Security',
    'System': 'System',
    'Achievements': 'Achievements',
    'copyrightText': '© 2025 The Events. All Rights Reserved.',
    'enterYourCouponCode': 'Enter your coupon code',
    'redeemYourGiftCard': 'Redeem Your Gift Card',
    'noFees': 'No Fees',
    AppStrings.markAsUnread: 'Mark as unread',
    AppStrings.markAsRead: 'Mark as read',
    AppStrings.noExpiringFundsFound: 'No expiring funds found',
    AppStrings.notificationSettings: 'Notification Settings',
    AppStrings.notificationTypes: 'Notification Types',
    'fundExpiryAlert': 'Fund Expiry Alert',
    'criticalActionRequired': 'Critical - Action required',
    'transactionsCount': 'Total Transactions',
    '7Days': '7 Days',
    '30Days': '30 Days',
    '90Days': '90 Days',
    'currentMonth': 'Current Month',
    'lastMonth': 'Last Month',
    'currentYear': 'Current Year',
    'lastYear': 'Last Year',
    'transactionHistory': 'Transaction History',
    'export': 'Export',
    'searchTransactions': 'Search transactions...',
    'allTypes': 'All Types',
    'deposit': 'Deposit',
    'payment': 'Payment',
    'reward': 'Reward',
    'refund': 'Refund',
    'allMethods': 'All Methods',
    'creditCard': 'Credit Card',
    'giftCard': 'Gift Card',
    'bankTransfer': 'Bank Transfer',
    'thirtyDays': '30 Days',
    'sevenDays': '7 Days',
    'ninetyDays': '90 Days',
    'allTime': 'All Time',
    'reset': 'Reset',

    // Notifications Screen translations
    'notifications': 'Notifications',
    'markAllRead': 'Mark all read',
    'noNotificationsYet': 'No notifications yet',
    'notificationsEmptyMessage': 'You\'ll see important updates and\nalerts about your wallet here.',

    AppStrings.wallet: 'Wallet',
    AppStrings.digitalWallet: 'Digital Wallet',
    AppStrings.expirySoon: 'Expiry Soon',
    AppStrings.currentBalanceTitle: 'Current Balance',
    AppStrings.rewardsEarnedTitle: 'Rewards Earned',
    AppStrings.walletBalanceTitle: 'Wallet Balance',
    AppStrings.lastUpdatedPrefix: 'Last updated',
    AppStrings.addFunds: 'Add Funds',
    AppStrings.history: 'History',
    AppStrings.notifications: 'Notifications',
    AppStrings.deposits: 'Deposits',
    AppStrings.overview: 'Overview',
    AppStrings.addFundsToWallet: 'Add Funds to Wallet',
    AppStrings.selectDepositMethod: 'Select Deposit Method',
    AppStrings.couponCodeGiftCard: 'Coupon Code (Gift Card)',
    AppStrings.amountAed: 'Amount (AED)',
    AppStrings.instant: 'Instant',
    AppStrings.giftCard: 'Gift Card',
    AppStrings.creditDebitCard: 'Credit/Debit Card',
    AppStrings.visaMasterAccepted: 'Visa, Master Card accepted',
    AppStrings.processingFeeSuffix: 'processing fee',
    AppStrings.balanceLabel: 'Balance: ',
    AppStrings.was: 'Was: ',
    AppStrings.applePay: AppStrings.applePay,
    AppStrings.applePaySubtitle: AppStrings.applePaySubtitle,
    AppStrings.paymentCard: AppStrings.paymentCard,
    AppStrings.paymentTabby: AppStrings.paymentTabby,
    AppStrings.paymentTamara: AppStrings.paymentTamara,
    AppStrings.termsNote: AppStrings.termsNote,
    AppStrings.selectFromExistingAddresses: AppStrings.selectFromExistingAddresses,
    AppStrings.orderSummary: AppStrings.orderSummary,
    AppStrings.subtotalUpper: AppStrings.subtotalUpper,
    AppStrings.taxVat: AppStrings.taxVat,
    AppStrings.shipping: AppStrings.shipping,
    AppStrings.couponDiscount: AppStrings.couponDiscount,
    AppStrings.promotionDiscount: AppStrings.promotionDiscount,
    AppStrings.totalUpper: AppStrings.totalUpper,
    AppStrings.deliverTo: AppStrings.deliverTo,
    AppStrings.noAddressSelected: AppStrings.noAddressSelected,
    AppStrings.addressDetailsNotFound: AppStrings.addressDetailsNotFound,
    AppStrings.areaState: AppStrings.areaState,
    AppStrings.phoneNumber: AppStrings.phoneNumber,
    AppStrings.grandTotal: AppStrings.grandTotal,
    AppStrings.payNowTitle: AppStrings.payNowTitle,
    AppStrings.paymentCompletedSuccessfully: AppStrings.paymentCompletedSuccessfully,
    AppStrings.applePayFailed: AppStrings.applePayFailed,
    AppStrings.applePayErrorPrefix: AppStrings.applePayErrorPrefix,
    'confirmPaymentCancel': 'Cancel Payment?',
    'paymentCancelWarning': 'Are you sure you want to cancel the payment?',
    'continuePayment': 'Continue Payment',
    'cancelPayment': 'Cancel Payment',
    'noOrderDetailsFound': 'No order details found',
    'retry': 'Retry',
    'orderPlacedSuccessfully': 'Order placed successfully! Check your orders for details.',
    'payment_successful': 'Payment was successful',
    'payment_failed': 'Payment failed',
    'payment_cancelled': 'Payment was cancelled',
    'payment_link_error': 'Failed to generate payment link',
    AppStrings.vendorAccountUnderReview: AppStrings.vendorAccountUnderReview,
    'content': 'Content',
    'pleaseSelectRequiredOptions': 'Please select all required options',
    'dismiss': 'Dismiss',
    'Bazaar': 'Bazaar',
    'state': 'State',
    'stateIsRequired': 'State is required',
    'cityIsRequired': 'City is required',
    'selectState': 'Select State',
    'selectCity': 'Select City',
    'unknownState': 'Unknown State',
// Core App Strings
    AppStrings.darkMode: AppStrings.darkMode,
    AppStrings.giftsByOccasion: AppStrings.giftsByOccasion,
    AppStrings.changeLanguage: AppStrings.changeLanguage,
    AppStrings.welcomeMessage: AppStrings.welcomeMessage,
    AppStrings.loginSignUp: AppStrings.loginSignUp,
    AppStrings.cart: AppStrings.cart,
    AppStrings.changePassword: AppStrings.changePassword,
    AppStrings.redeemCard: AppStrings.redeemCard,
    AppStrings.joinAsSeller: AppStrings.joinAsSeller,
    AppStrings.joinUsSeller: AppStrings.joinUsSeller,
    AppStrings.privacyPolicy: AppStrings.privacyPolicy,
    AppStrings.aboutUs: AppStrings.aboutUs,
    AppStrings.location: AppStrings.location,
    AppStrings.helpAndSupport: AppStrings.helpAndSupport,
    AppStrings.signUp: AppStrings.signUp,
    AppStrings.signIn: AppStrings.signIn,
    AppStrings.description: AppStrings.description,
    AppStrings.termsAndConditions: AppStrings.termsAndConditions,
    AppStrings.termsAndConditionsText: AppStrings.termsAndConditionsText,
    AppStrings.buyAndRedeem: AppStrings.buyAndRedeem,
    AppStrings.vendor: AppStrings.vendor,
    AppStrings.vendorAgreement: AppStrings.vendorAgreement,

// Descriptions
    AppStrings.descriptionGiftCard: AppStrings.descriptionGiftCard,
    AppStrings.redeemFirstLine: AppStrings.redeemFirstLine,
    AppStrings.redeemSecondLine: AppStrings.redeemSecondLine,
    AppStrings.redeemThirdLine: AppStrings.redeemThirdLine,
    AppStrings.redeemForthLine: AppStrings.redeemForthLine,
    AppStrings.redeemFifthLine: AppStrings.redeemFifthLine,

// Cart & Shopping
    AppStrings.myCart: AppStrings.myCart,
    AppStrings.back: AppStrings.back,
    AppStrings.totalColon: AppStrings.totalColon,
    AppStrings.profile: AppStrings.profile,
    AppStrings.shippingFees: AppStrings.shippingFees,
    AppStrings.proceedToCheckOut: AppStrings.proceedToCheckOut,
    AppStrings.addToCart: AppStrings.addToCart,
    AppStrings.subTotalColon: AppStrings.subTotalColon,
    AppStrings.taxColon: AppStrings.taxColon,
    AppStrings.couponCodeText: AppStrings.couponCodeText,
    AppStrings.couponCodeAmount: AppStrings.couponCodeAmount,
    AppStrings.shippingFee: AppStrings.shippingFee,
    AppStrings.switchLanguage: AppStrings.switchLanguage,
    AppStrings.wishList: AppStrings.wishList,
    AppStrings.emptyWishList: AppStrings.emptyWishList,
    AppStrings.viewAll: AppStrings.viewAll,
    AppStrings.quantity: AppStrings.quantity,
    AppStrings.percentOff: AppStrings.percentOff,
    AppStrings.off: AppStrings.off,
    AppStrings.gotoWishlist: AppStrings.gotoWishlist,
    AppStrings.continueShopping: AppStrings.continueShopping,
    AppStrings.cartIsEmpty: AppStrings.cartIsEmpty,
    AppStrings.aed: AppStrings.aed,

// About Us
    AppStrings.aboutUsEvents: AppStrings.aboutUsEvents,
    AppStrings.ourMissionText: AppStrings.ourMissionText,
    AppStrings.ourVisionText: AppStrings.ourVisionText,
    AppStrings.ourMission: AppStrings.ourMission,
    AppStrings.ourVision: AppStrings.ourVision,
    AppStrings.ourValues: AppStrings.ourValues,
    AppStrings.ourLocation: AppStrings.ourLocation,
    AppStrings.who: AppStrings.who,
    AppStrings.weAre: AppStrings.weAre,
    AppStrings.our: AppStrings.our,
    AppStrings.mission: AppStrings.mission,
    AppStrings.vision: AppStrings.vision,
    AppStrings.values: AppStrings.values,
    AppStrings.simplicity: AppStrings.simplicity,
    AppStrings.innovation: AppStrings.innovation,
    AppStrings.thoughtfulness: AppStrings.thoughtfulness,
    AppStrings.reliability: AppStrings.reliability,

// Vendor
    AppStrings.vendorHeading: AppStrings.vendorHeading,
    AppStrings.vendorContactHeading: AppStrings.vendorContactHeading,
    AppStrings.agreementAccept: AppStrings.agreementAccept,
    AppStrings.registrationDone: AppStrings.registrationDone,
    AppStrings.paymentDone: AppStrings.paymentDone,
    AppStrings.paymentThanks: AppStrings.paymentThanks,

// Countries
    AppStrings.unitedArabEmirates: AppStrings.unitedArabEmirates,
    AppStrings.saudiArabia: AppStrings.saudiArabia,
    AppStrings.bahrain: AppStrings.bahrain,
    AppStrings.kuwait: AppStrings.kuwait,
    AppStrings.oman: AppStrings.oman,
    AppStrings.qatar: AppStrings.qatar,

// Authentication
    AppStrings.forgetPassword: AppStrings.forgetPassword,
    AppStrings.doNotHaveAccountYet: AppStrings.doNotHaveAccountYet,
    AppStrings.createOneNow: AppStrings.createOneNow,
    AppStrings.send: AppStrings.send,
    AppStrings.emailAddress: AppStrings.emailAddress,
    AppStrings.emailRequired: AppStrings.emailRequired,
    AppStrings.login: AppStrings.login,
    AppStrings.enterYourEmail: AppStrings.enterYourEmail,
    AppStrings.passRequired: AppStrings.passRequired,
    AppStrings.enterYourPassword: AppStrings.enterYourPassword,
    AppStrings.continueo: AppStrings.continueo,
    AppStrings.getHelp: AppStrings.getHelp,
    AppStrings.haveTroubleLogging: AppStrings.haveTroubleLogging,
    AppStrings.fullName: AppStrings.fullName,
    AppStrings.confirmPassword: AppStrings.confirmPassword,
    AppStrings.passwordValidation: AppStrings.passwordValidation,
    AppStrings.agreement: AppStrings.agreement,
    AppStrings.terms: AppStrings.terms,
    AppStrings.searchEvents: AppStrings.searchEvents,
    AppStrings.notification: AppStrings.notification,
    AppStrings.confirmLogout: AppStrings.confirmLogout,
    AppStrings.confirmLogoutMessage: AppStrings.confirmLogoutMessage,
    AppStrings.logout: AppStrings.logout,
// Profile & Account
    AppStrings.address: AppStrings.address,
    AppStrings.giftCards: AppStrings.giftCards,
    AppStrings.reviews: AppStrings.reviews,
    AppStrings.orders: AppStrings.orders,
    AppStrings.myAccount: AppStrings.myAccount,
    AppStrings.enterCurrentPassword: AppStrings.enterCurrentPassword,
    AppStrings.currentPasswordCannotBeEmpty: AppStrings.currentPasswordCannotBeEmpty,
    AppStrings.currentPassword: AppStrings.currentPassword,
    AppStrings.enterChangePassword: AppStrings.enterChangePassword,
    AppStrings.enterReEnterPassword: AppStrings.reEnterPassword,
    AppStrings.reEnterPassword: AppStrings.reEnterPassword,
    AppStrings.update: AppStrings.update,
    AppStrings.pleaseEnterFields: AppStrings.pleaseEnterFields,
    AppStrings.noRecord: AppStrings.noRecord,
    AppStrings.edit: AppStrings.edit,
    AppStrings.phone: AppStrings.phone,
    AppStrings.email: AppStrings.email,
    AppStrings.name: AppStrings.name,
    AppStrings.defaultAddress: AppStrings.defaultAddress,
    AppStrings.create: AppStrings.create,
    AppStrings.unknownCountry: AppStrings.unknownCountry,
    AppStrings.pleaseCheckFields: AppStrings.pleaseCheckFields,
    AppStrings.addressSaved: AppStrings.addressSaved,
    AppStrings.save: AppStrings.save,
    AppStrings.useDefaultAddress: AppStrings.useDefaultAddress,
    AppStrings.cityCannotBeEmpty: AppStrings.cityCannotBeEmpty,
    AppStrings.city: AppStrings.city,
    AppStrings.enterCity: AppStrings.enterCity,
    AppStrings.stateCannotBeEmpty: AppStrings.stateCannotBeEmpty,
    AppStrings.enterState: AppStrings.enterState,
    AppStrings.pleaseSelectCountry: AppStrings.pleaseSelectCountry,
    AppStrings.country: AppStrings.country,
    AppStrings.enterCountry: AppStrings.enterCountry,
    AppStrings.enterAddress: AppStrings.enterAddress,
    AppStrings.enterEmailAddress: AppStrings.enterEmailAddress,
    AppStrings.enterPhoneNumber: AppStrings.enterPhoneNumber,
    AppStrings.enterName: AppStrings.enterName,
    AppStrings.enterYourName: AppStrings.enterYourName,
    AppStrings.reviewed: AppStrings.reviewed,
    AppStrings.waitingForReview: AppStrings.waitingForReview,
    AppStrings.nameCannotBeEmpty: AppStrings.nameCannotBeEmpty,
    AppStrings.phoneCannotBeEmpty: AppStrings.phoneCannotBeEmpty,
    AppStrings.pleaseFillAllFields: AppStrings.pleaseFillAllFields,
    AppStrings.emailCannotBeEmpty: AppStrings.emailCannotBeEmpty,
    AppStrings.deleteMyAccount: AppStrings.deleteMyAccount,
    AppStrings.deleteAccount: AppStrings.deleteAccount,
    AppStrings.delete: AppStrings.delete,
    AppStrings.deleteAccountWarning: AppStrings.deleteAccountWarning,
    AppStrings.addressCannotBeEmpty: AppStrings.addressCannotBeEmpty,

// Reviews
    AppStrings.noProductsAvailable: AppStrings.noProductsAvailable,
    AppStrings.uploadPhotos: AppStrings.uploadPhotos,
    AppStrings.uploadPhotosMessage: AppStrings.uploadPhotosMessage,
    AppStrings.submitReview: AppStrings.submitReview,
    AppStrings.errorSubmittingReview: AppStrings.errorSubmittingReview,
    AppStrings.review: AppStrings.review,
    AppStrings.failedToAddPhotos: AppStrings.failedToAddPhotos,
    AppStrings.maxFilesError: AppStrings.maxFilesError,
    AppStrings.noReviews: AppStrings.noReviews,
    AppStrings.customerReviews: AppStrings.customerReviews,
    AppStrings.reviewSeller: AppStrings.reviewSeller,
    AppStrings.reviewProduct: AppStrings.reviewProduct,
    AppStrings.ratings: AppStrings.ratings,
    AppStrings.star: AppStrings.star,
    AppStrings.stars: AppStrings.stars,

// Coupons
    AppStrings.couponAppliedSuccess: AppStrings.couponAppliedSuccess,
    AppStrings.couponRemovedSuccess: AppStrings.couponRemovedSuccess,
    AppStrings.couponInvalidOrExpired: AppStrings.couponInvalidOrExpired,
    AppStrings.couponLabel: AppStrings.couponLabel,
    AppStrings.couponHint: AppStrings.couponHint,

// Checkout & Payment
    AppStrings.continueToPayment: AppStrings.continueToPayment,
    AppStrings.currencyAED: AppStrings.currencyAED,
    AppStrings.acceptTermsAndConditions: AppStrings.acceptTermsAndConditions,
    AppStrings.readOurTermsAndConditions: AppStrings.readOurTermsAndConditions,
    AppStrings.mustAcceptTerms: AppStrings.mustAcceptTerms,
    AppStrings.confirmAndSubmitOrder: AppStrings.confirmAndSubmitOrder,
    AppStrings.byClickingSubmit: AppStrings.byClickingSubmit,
    AppStrings.and: AppStrings.and,

    AppStrings.addNewAddress: AppStrings.addNewAddress,
    AppStrings.saveAddress: AppStrings.saveAddress,
    AppStrings.updateAddress: AppStrings.updateAddress,
    AppStrings.addNewAddressTitle: AppStrings.addNewAddressTitle,
    AppStrings.nameIsRequired: AppStrings.nameIsRequired,
    AppStrings.countryIsRequired: AppStrings.countryIsRequired,
    AppStrings.enterCorrectDetails: AppStrings.enterCorrectDetails,
    AppStrings.enterValidDetails: AppStrings.enterValidDetails,

    AppStrings.unknownAddress: AppStrings.unknownAddress,
    AppStrings.unknownName: AppStrings.unknownName,
    AppStrings.unknownEmail: AppStrings.unknownEmail,
    AppStrings.unknownPhone: AppStrings.unknownPhone,
    AppStrings.unknownCity: AppStrings.unknownCity,
    AppStrings.unknownZipCode: AppStrings.unknownZipCode,
    AppStrings.choosePaymentMethod: AppStrings.choosePaymentMethod,
    AppStrings.shippingAddressDescription: AppStrings.shippingAddressDescription,
    AppStrings.shippingAddress: AppStrings.shippingAddress,
    AppStrings.selectShippingAddress: AppStrings.selectShippingAddress,
    AppStrings.shippingMethod: AppStrings.shippingMethod,
    AppStrings.checkout: AppStrings.checkout,
    AppStrings.selectCountry: AppStrings.selectCountry,
    AppStrings.payment: AppStrings.payment,
    AppStrings.failedToLoadPaymentMethods: AppStrings.failedToLoadPaymentMethods,
    AppStrings.noPaymentMethodsAvailable: AppStrings.noPaymentMethodsAvailable,

// Filters & Sorting
    AppStrings.sortOption: AppStrings.sortOption,
    AppStrings.filters: AppStrings.filters,
    AppStrings.apply: AppStrings.apply,
    AppStrings.filterOptions: AppStrings.filterOptions,
    AppStrings.brands: AppStrings.brands,
    AppStrings.celebrities: AppStrings.celebrities,
    AppStrings.events: AppStrings.events,
    AppStrings.categories: AppStrings.categories,
    AppStrings.account: AppStrings.account,
    AppStrings.tags: AppStrings.tags,
    AppStrings.prices: AppStrings.prices,
    AppStrings.colors: AppStrings.colors,
    AppStrings.sortByDefault: AppStrings.sortByDefault,
    AppStrings.sortByOldest: AppStrings.sortByOldest,
    AppStrings.sortByNewest: AppStrings.sortByNewest,
    AppStrings.sortByNameAz: AppStrings.sortByNameAz,
    AppStrings.sortByNameZa: AppStrings.sortByNameZa,
    AppStrings.sortByPriceLowToHigh: AppStrings.sortByPriceLowToHigh,
    AppStrings.sortByPriceHighToLow: AppStrings.sortByPriceHighToLow,
    AppStrings.sortByRatingLowToHigh: AppStrings.sortByRatingLowToHigh,
    AppStrings.sortByRatingHighToLow: AppStrings.sortByRatingHighToLow,

// Products
    AppStrings.noNotifications: AppStrings.noNotifications,
    AppStrings.enterYourMessage: AppStrings.enterYourMessage,
    AppStrings.selectLocation: AppStrings.selectLocation,
    AppStrings.selectDate: AppStrings.selectDate,
    AppStrings.selectedDate: AppStrings.selectedDate,
    AppStrings.messageCanNotBeEmpty: AppStrings.messageCanNotBeEmpty,
    AppStrings.pleaseSelectValidDate: AppStrings.pleaseSelectValidDate,
    AppStrings.pleaseSelectLocation: AppStrings.pleaseSelectLocation,
    AppStrings.failedToLoadImage: AppStrings.failedToLoadImage,
    AppStrings.wishlist: AppStrings.wishlist,
    AppStrings.pleaseLogInToWishList: AppStrings.pleaseLogInToWishList,
    AppStrings.pleaseLogInToCart: AppStrings.pleaseLogInToCart,
    AppStrings.noAttributesAvailable: AppStrings.noAttributesAvailable,
    AppStrings.view: AppStrings.view,
    AppStrings.sellingBy: AppStrings.sellingBy,
    AppStrings.productDetails: AppStrings.productDetails,
    AppStrings.outOfStockStr: AppStrings.outOfStockStr,
    AppStrings.includingVAT: AppStrings.includingVAT,
    AppStrings.interestFreeInstallment: AppStrings.interestFreeInstallment,
    AppStrings.moreColors: AppStrings.moreColors,
    AppStrings.relatedProducts: AppStrings.relatedProducts,
    AppStrings.search: AppStrings.search,
    AppStrings.products: AppStrings.products,
    AppStrings.packages: AppStrings.packages,
    AppStrings.errorFetchingData: AppStrings.errorFetchingData,
    AppStrings.productDescription: AppStrings.productDescription,
    AppStrings.noProductsFound: AppStrings.noProductsFound,
    AppStrings.searchGifts: AppStrings.searchGifts,
    AppStrings.searchBrands: AppStrings.searchBrands,

// Common Actions
    AppStrings.removeWishlistTitle: AppStrings.removeWishlistTitle,
    AppStrings.removeWishlistMessage: AppStrings.removeWishlistMessage,
    AppStrings.cancel: AppStrings.cancel,
    AppStrings.yes: AppStrings.yes,
    AppStrings.no: AppStrings.no,
    AppStrings.soldBy: AppStrings.soldBy,
    AppStrings.loading: AppStrings.loading,
    AppStrings.error: AppStrings.error,
    AppStrings.confirmation: AppStrings.confirmation,
    AppStrings.cancelOrderConfirmationMessage: AppStrings.cancelOrderConfirmationMessage,
    AppStrings.allow: AppStrings.allow,
    AppStrings.pending: AppStrings.pending,
    AppStrings.completed: AppStrings.completed,
    AppStrings.purchased: AppStrings.purchased,
    AppStrings.noDataAvailable: AppStrings.noDataAvailable,
// Orders
    AppStrings.orderPlaced: AppStrings.orderPlaced,
    AppStrings.orderNoPrefix: AppStrings.orderNoPrefix,
    AppStrings.orderDatePrefix: AppStrings.orderDatePrefix,
    AppStrings.estimatedDeliveryPrefix: AppStrings.estimatedDeliveryPrefix,
    AppStrings.itemsSuffix: AppStrings.itemsSuffix,
    AppStrings.itemBrandPrefix: AppStrings.itemBrandPrefix,
    AppStrings.itemColor: AppStrings.itemColor,
    AppStrings.itemUKSize: AppStrings.itemUKSize,
    AppStrings.itemQuantityValue: AppStrings.itemQuantityValue,
    AppStrings.colorLabel: AppStrings.colorLabel,
    AppStrings.sizeLabel: AppStrings.sizeLabel,
    AppStrings.quantityLabel: AppStrings.quantityLabel,
    AppStrings.subTotal: AppStrings.subTotal,
    AppStrings.discount: AppStrings.discount,
    AppStrings.tax: AppStrings.tax,
    AppStrings.delivery: AppStrings.delivery,
    AppStrings.total: AppStrings.total,
    AppStrings.deliveryDetails: AppStrings.deliveryDetails,
    AppStrings.deliveryMethod: AppStrings.deliveryMethod,
    AppStrings.standardDelivery: AppStrings.standardDelivery,
    AppStrings.deliveryAddress: AppStrings.deliveryAddress,
    AppStrings.paymentDetails: AppStrings.paymentDetails,
    AppStrings.paymentType: AppStrings.paymentType,
    AppStrings.mastercard: AppStrings.mastercard,
    AppStrings.changedYourMind: AppStrings.changedYourMind,
    AppStrings.cancellingTheOrder: AppStrings.cancellingTheOrder,
    AppStrings.cancellationInfo: AppStrings.cancellationInfo,
    AppStrings.cancelWithinOneHour: AppStrings.cancelWithinOneHour,
    AppStrings.returnOrder: AppStrings.returnOrder,
    AppStrings.viewOrderUppercase: AppStrings.returnOrder,
    AppStrings.ordersCancelled: AppStrings.ordersCancelled,
    AppStrings.oneItemCancelled: AppStrings.oneItemCancelled,
    AppStrings.perfume: AppStrings.perfume,
    AppStrings.refundDetails: AppStrings.refundDetails,
    AppStrings.refundNotApplicable: AppStrings.refundNotApplicable,
    AppStrings.refund: AppStrings.refund,
    AppStrings.noOrders: AppStrings.noOrders,
    AppStrings.orderViewed: AppStrings.orderViewed,
    AppStrings.viewProduct: AppStrings.viewProduct,
    AppStrings.viewOrder: AppStrings.viewOrder,
    AppStrings.orderDetails: AppStrings.orderDetails,
    AppStrings.orderInfo: AppStrings.orderInfo,
    AppStrings.orderNumber: AppStrings.orderNumber,
    AppStrings.time: AppStrings.time,
    AppStrings.orderStatus: AppStrings.orderStatus,
    AppStrings.charges: AppStrings.charges,
    AppStrings.totalAmount: AppStrings.totalAmount,
    AppStrings.shippingInfo: AppStrings.shippingInfo,
    AppStrings.shippingStatus: AppStrings.shippingStatus,
    AppStrings.dateShipped: AppStrings.dateShipped,
    AppStrings.uploadPaymentProof: AppStrings.uploadPaymentProof,

    AppStrings.viewReceipt: AppStrings.viewReceipt,
    AppStrings.uploadedProofNote: AppStrings.uploadedProofNote,
    AppStrings.reUploadNote: AppStrings.reUploadNote,
    AppStrings.noProofUploaded: AppStrings.noProofUploaded,
    AppStrings.invoice: AppStrings.invoice,

// File Operations
    AppStrings.permissionDenied: AppStrings.permissionDenied,
    AppStrings.userCancelled: AppStrings.userCancelled,
    AppStrings.fileSavedSuccess: AppStrings.fileSavedSuccess,
    AppStrings.fileSaveError: AppStrings.fileSaveError,
    AppStrings.storagePermissionTitle: AppStrings.storagePermissionTitle,

    AppStrings.storagePermissionMessage: AppStrings.storagePermissionMessage,
// Gift Cards
    AppStrings.selectGiftCardAmount: 'Select gift card amount',
    AppStrings.selectOrAddAmount: 'Select or add an amount',
    AppStrings.amountMustBeLessThan: 'Amount must be less than AED 10,000',
    AppStrings.invalidAmountEntered: 'Invalid amount entered',
    AppStrings.enterReceiptName: 'Enter recipient name *',
    AppStrings.enterReceiptEmail: 'Enter recipient email *',
    AppStrings.additionalNotes: 'Additional notes',
    AppStrings.discount50: '50% off',
    AppStrings.searchDiscounts: 'Search discounts',

// Placeholder values
    AppStrings.actualPrice: 'Actual price',
    AppStrings.standardPrice: 'Standard price',
    AppStrings.fiftyPercentOffPrice: '50% off price',

// VendorAppStrings (add your vendor strings here)

// Title Strings

    VendorAppStrings.titleGender: VendorAppStrings.titleGender,

// Hint Strings
    VendorAppStrings.hintEnterEmail: VendorAppStrings.hintEnterEmail,
    VendorAppStrings.hintEnterFullName: VendorAppStrings.hintEnterFullName,
    VendorAppStrings.hintSelectGender: VendorAppStrings.hintSelectGender,

// Error Strings
    VendorAppStrings.errorEmailRequired: VendorAppStrings.errorEmailRequired,
    VendorAppStrings.errorValidEmail: VendorAppStrings.errorValidEmail,

// Common Strings
    VendorAppStrings.asterick: VendorAppStrings.asterick,

// Navigation and Drawer
    VendorAppStrings.home: VendorAppStrings.home,
    VendorAppStrings.shop: VendorAppStrings.shop,
    VendorAppStrings.dashboard: VendorAppStrings.dashboard,
    VendorAppStrings.orderReturns: VendorAppStrings.orderReturns,
    VendorAppStrings.withdrawals: VendorAppStrings.withdrawals,
    VendorAppStrings.revenues: VendorAppStrings.revenues,
    VendorAppStrings.settings: VendorAppStrings.settings,
    VendorAppStrings.logoutFromVendor: VendorAppStrings.logoutFromVendor,

// Button Titles
    VendorAppStrings.saveAndContinue: VendorAppStrings.saveAndContinue,
    VendorAppStrings.previewAgreement: VendorAppStrings.previewAgreement,

// App Bar Titles

// Tab and Section Titles
    VendorAppStrings.packageProducts: VendorAppStrings.packageProducts,
    VendorAppStrings.uploadImages: VendorAppStrings.uploadImages,
    VendorAppStrings.packageProductsTab: VendorAppStrings.packageProductsTab,
    VendorAppStrings.productOptions: VendorAppStrings.productOptions,
    VendorAppStrings.searchEngineOptimization: VendorAppStrings.searchEngineOptimization,
    VendorAppStrings.relatedProducts: VendorAppStrings.relatedProducts,
    VendorAppStrings.crossSellingProducts: VendorAppStrings.crossSellingProducts,
    VendorAppStrings.productVariations: VendorAppStrings.productVariations,
    VendorAppStrings.digitalAttachments: VendorAppStrings.digitalAttachments,
    VendorAppStrings.digitalAttachmentLinks: VendorAppStrings.digitalAttachmentLinks,
    VendorAppStrings.attributes: VendorAppStrings.attributes,
    VendorAppStrings.productFaqs: VendorAppStrings.productFaqs,
    VendorAppStrings.recentOrders: VendorAppStrings.recentOrders,
    VendorAppStrings.topSellingProducts: VendorAppStrings.topSellingProducts,
    VendorAppStrings.editSeoMeta: VendorAppStrings.editSeoMeta,
    VendorAppStrings.index: VendorAppStrings.index,
    VendorAppStrings.noIndex: VendorAppStrings.noIndex,
    VendorAppStrings.productOverviewShipping: VendorAppStrings.productOverviewShipping,
    VendorAppStrings.editVariations: VendorAppStrings.editVariations,
    VendorAppStrings.autoGenerateSku: VendorAppStrings.autoGenerateSku,
    VendorAppStrings.productHasVariations: VendorAppStrings.productHasVariations,
    VendorAppStrings.isDefault: VendorAppStrings.isDefault,
    VendorAppStrings.withStorehouseManagement: VendorAppStrings.withStorehouseManagement,
    VendorAppStrings.logo: VendorAppStrings.logo,
    VendorAppStrings.coverImage: VendorAppStrings.coverImage,
    VendorAppStrings.priceField: VendorAppStrings.priceField,
    VendorAppStrings.typeField: VendorAppStrings.typeField,

// Settings Tab Titles
    VendorAppStrings.store: VendorAppStrings.store,
    VendorAppStrings.taxInfo: VendorAppStrings.taxInfo,
    VendorAppStrings.payoutInfo: VendorAppStrings.payoutInfo,

// Switch Titles
    VendorAppStrings.unlimitedCoupon: VendorAppStrings.unlimitedCoupon,
    VendorAppStrings.displayCouponCodeAtCheckout: VendorAppStrings.displayCouponCodeAtCheckout,
    VendorAppStrings.neverExpired: VendorAppStrings.neverExpired,
    VendorAppStrings.generateLicenseCodeAfterPurchase: VendorAppStrings.generateLicenseCodeAfterPurchase,
    VendorAppStrings.required: VendorAppStrings.required,
// Form Labels
    VendorAppStrings.bankName: VendorAppStrings.bankName,
    VendorAppStrings.ibanNumber: VendorAppStrings.ibanNumber,
    VendorAppStrings.accountName: VendorAppStrings.accountName,
    VendorAppStrings.accountNumber: VendorAppStrings.accountNumber,
    VendorAppStrings.bankLetterPdf: VendorAppStrings.bankLetterPdf,
    VendorAppStrings.password: VendorAppStrings.password,
    VendorAppStrings.companyName: VendorAppStrings.companyName,
    VendorAppStrings.companySlug: VendorAppStrings.companySlug,
    VendorAppStrings.companyMobileNumber: VendorAppStrings.companyMobileNumber,
    VendorAppStrings.uploadCompanyLogo: VendorAppStrings.uploadCompanyLogo,
    VendorAppStrings.companyCategoryType: VendorAppStrings.companyCategoryType,
    VendorAppStrings.companyEmail: VendorAppStrings.companyEmail,
    VendorAppStrings.phoneNumberLandline: VendorAppStrings.phoneNumberLandline,
    VendorAppStrings.mobileNumber: VendorAppStrings.mobileNumber,
    VendorAppStrings.tradeLicenseNumber: VendorAppStrings.tradeLicenseNumber,
    VendorAppStrings.uploadTradeLicensePdf: VendorAppStrings.uploadTradeLicensePdf,
    VendorAppStrings.companyAddress: VendorAppStrings.companyAddress,
    VendorAppStrings.region: VendorAppStrings.region,
    VendorAppStrings.emiratesIdNumber: VendorAppStrings.emiratesIdNumber,
    VendorAppStrings.emiratesIdNumberExpiryDate: VendorAppStrings.emiratesIdNumberExpiryDate,
    VendorAppStrings.uploadEidPdf: VendorAppStrings.uploadEidPdf,
    VendorAppStrings.uploadPassportPdf: VendorAppStrings.uploadPassportPdf,
    VendorAppStrings.poaMoaPdf: VendorAppStrings.poaMoaPdf,
    VendorAppStrings.companyStamp: VendorAppStrings.companyStamp,
    VendorAppStrings.note: VendorAppStrings.note,
    VendorAppStrings.amount: VendorAppStrings.amount,
    VendorAppStrings.fee: VendorAppStrings.fee,
    VendorAppStrings.createCouponCode: VendorAppStrings.createCouponCode,
    VendorAppStrings.couponName: VendorAppStrings.couponName,
    VendorAppStrings.enterNumber: VendorAppStrings.enterNumber,
    VendorAppStrings.businessName: VendorAppStrings.businessName,
    VendorAppStrings.taxId: VendorAppStrings.taxId,
    VendorAppStrings.shopUrl: VendorAppStrings.shopUrl,
    VendorAppStrings.title: VendorAppStrings.title,
    VendorAppStrings.company: VendorAppStrings.company,
    VendorAppStrings.selectPaymentMethod: VendorAppStrings.selectPaymentMethod,
    VendorAppStrings.bankCodeIfsc: VendorAppStrings.bankCodeIfsc,
    VendorAppStrings.accountHolderName: VendorAppStrings.accountHolderName,
    VendorAppStrings.upiId: VendorAppStrings.upiId,
    VendorAppStrings.paypalId: VendorAppStrings.paypalId,
    VendorAppStrings.weightG: VendorAppStrings.weightG,
    VendorAppStrings.lengthCm: VendorAppStrings.lengthCm,
    VendorAppStrings.widthCm: VendorAppStrings.widthCm,
    VendorAppStrings.heightCm: VendorAppStrings.heightCm,
    VendorAppStrings.sku: VendorAppStrings.sku,
    VendorAppStrings.price: VendorAppStrings.price,
    VendorAppStrings.salePrice: VendorAppStrings.salePrice,
    VendorAppStrings.fromDate: VendorAppStrings.fromDate,
    VendorAppStrings.toDate: VendorAppStrings.toDate,
    VendorAppStrings.costPerItem: VendorAppStrings.costPerItem,
    VendorAppStrings.barcodeIsbnUpcGtin: VendorAppStrings.barcodeIsbnUpcGtin,
    VendorAppStrings.quantity: VendorAppStrings.quantity,
    VendorAppStrings.question: VendorAppStrings.question,
    VendorAppStrings.answer: VendorAppStrings.answer,
    VendorAppStrings.seoKeywords: VendorAppStrings.seoKeywords,
    VendorAppStrings.permalink: VendorAppStrings.permalink,

// Form Hints
    VendorAppStrings.enterBankName: VendorAppStrings.enterBankName,
    VendorAppStrings.enterIbanNumber: VendorAppStrings.enterIbanNumber,
    VendorAppStrings.enterAccountName: VendorAppStrings.enterAccountName,
    VendorAppStrings.enterAccountNumber: VendorAppStrings.enterAccountNumber,
    VendorAppStrings.noFileChosen: VendorAppStrings.noFileChosen,
    VendorAppStrings.enterCouponName: VendorAppStrings.enterCouponName,
    VendorAppStrings.enterNumberOfCoupons: VendorAppStrings.enterNumberOfCoupons,
    VendorAppStrings.selectCouponType: VendorAppStrings.selectCouponType,
    VendorAppStrings.selectBrand: VendorAppStrings.selectBrand,
    VendorAppStrings.selectCategories: VendorAppStrings.selectCategories,
    VendorAppStrings.selectProductCollection: VendorAppStrings.selectProductCollection,
    VendorAppStrings.selectLabels: VendorAppStrings.selectLabels,
    VendorAppStrings.selectTaxes: VendorAppStrings.selectTaxes,
    VendorAppStrings.selectTags: VendorAppStrings.selectTags,
    VendorAppStrings.enterAmount: VendorAppStrings.enterAmount,
    VendorAppStrings.enterFee: VendorAppStrings.enterFee,
    VendorAppStrings.enterDescription: VendorAppStrings.enterDescription,
    VendorAppStrings.addNote: VendorAppStrings.addNote,
    VendorAppStrings.selectShipmentStatus: VendorAppStrings.selectShipmentStatus,
    VendorAppStrings.enterShopUrl: VendorAppStrings.enterShopUrl,
    VendorAppStrings.enterTitle: VendorAppStrings.enterTitle,
    VendorAppStrings.enterBusinessName: VendorAppStrings.enterBusinessName,
    VendorAppStrings.enterTaxId: VendorAppStrings.enterTaxId,
    VendorAppStrings.selectAttributeName: VendorAppStrings.selectAttributeName,
    VendorAppStrings.selectAttributeValue: VendorAppStrings.selectAttributeValue,
    VendorAppStrings.enterWeight: VendorAppStrings.enterWeight,
    VendorAppStrings.enterLength: VendorAppStrings.enterLength,
    VendorAppStrings.enterWidth: VendorAppStrings.enterWidth,
    VendorAppStrings.enterHeight: VendorAppStrings.enterHeight,
    VendorAppStrings.selectAnOption: VendorAppStrings.selectAnOption,
    VendorAppStrings.enterSeoKeywords: VendorAppStrings.enterSeoKeywords,
    VendorAppStrings.enterSku: VendorAppStrings.enterSku,
    VendorAppStrings.enterPrice: VendorAppStrings.enterPrice,
    VendorAppStrings.enterSalePrice: VendorAppStrings.enterSalePrice,
    VendorAppStrings.yyyyMmDdHhMmSs: VendorAppStrings.yyyyMmDdHhMmSs,
    VendorAppStrings.enterCostPerItem: VendorAppStrings.enterCostPerItem,
    VendorAppStrings.enterBarcode: VendorAppStrings.enterBarcode,
    VendorAppStrings.enterQuantity: VendorAppStrings.enterQuantity,
    VendorAppStrings.enterNameField: VendorAppStrings.enterNameField,
    VendorAppStrings.enterLabel: VendorAppStrings.enterLabel,
    VendorAppStrings.enterYourPassword: VendorAppStrings.enterYourPassword,
    VendorAppStrings.enterYourCompanyName: VendorAppStrings.enterYourCompanyName,
    VendorAppStrings.enterCompanySlug: VendorAppStrings.enterCompanySlug,
    VendorAppStrings.enterCompanyName: VendorAppStrings.enterCompanyName,
    VendorAppStrings.pleaseSelectCcType: VendorAppStrings.pleaseSelectCcType,
    VendorAppStrings.enterCompanyEmail: VendorAppStrings.enterCompanyEmail,
    VendorAppStrings.enterPhoneNumberField: VendorAppStrings.enterPhoneNumberField,
    VendorAppStrings.enterMobileNumber: VendorAppStrings.enterMobileNumber,
    VendorAppStrings.enterTradeLicenseNumber: VendorAppStrings.enterTradeLicenseNumber,
    VendorAppStrings.enterCompanyAddress: VendorAppStrings.enterCompanyAddress,
    VendorAppStrings.yyyyMmDd: VendorAppStrings.yyyyMmDd,
    VendorAppStrings.pleaseSelectCountry: VendorAppStrings.pleaseSelectCountry,
    VendorAppStrings.pleaseSelectRegion: VendorAppStrings.pleaseSelectRegion,

    VendorAppStrings.enterYourNumber: VendorAppStrings.enterYourNumber,
    VendorAppStrings.enterIdNumber: VendorAppStrings.enterIdNumber,
    VendorAppStrings.ddMmYyyy: VendorAppStrings.ddMmYyyy,
    VendorAppStrings.noFileChosenAlt: VendorAppStrings.noFileChosenAlt,
    VendorAppStrings.enterBankNameField: VendorAppStrings.enterBankNameField,
    VendorAppStrings.enterBankCodeIfsc: VendorAppStrings.enterBankCodeIfsc,
    VendorAppStrings.enterAccountHolderName: VendorAppStrings.enterAccountHolderName,

    VendorAppStrings.enterUpiId: VendorAppStrings.enterUpiId,
    VendorAppStrings.enterDescriptionFieldAlt: VendorAppStrings.enterDescriptionFieldAlt,
    VendorAppStrings.enterPaypalId: VendorAppStrings.enterPaypalId,

// Dropdown Options
    VendorAppStrings.selectGender: VendorAppStrings.selectGender,
    VendorAppStrings.selectRegion: VendorAppStrings.selectRegion,
    VendorAppStrings.selectCcType: VendorAppStrings.selectCcType,
    VendorAppStrings.amountFixed: VendorAppStrings.amountFixed,
    VendorAppStrings.discountPercentage: VendorAppStrings.discountPercentage,
    VendorAppStrings.freeShipping: VendorAppStrings.freeShipping,
    VendorAppStrings.noResultsFound: VendorAppStrings.noResultsFound,

// Table Headers
    VendorAppStrings.id: VendorAppStrings.id,
    VendorAppStrings.product: VendorAppStrings.product,
    VendorAppStrings.amountHeader: VendorAppStrings.amountHeader,
    VendorAppStrings.status: VendorAppStrings.status,
    VendorAppStrings.createdAt: VendorAppStrings.createdAt,

// Table Column Headers (from buildRow functions)
    VendorAppStrings.customer: VendorAppStrings.customer,
    VendorAppStrings.taxAmount: VendorAppStrings.taxAmount,
    VendorAppStrings.shippingAmount: VendorAppStrings.shippingAmount,
    VendorAppStrings.orderCode: VendorAppStrings.orderCode,
    VendorAppStrings.subAmount: VendorAppStrings.subAmount,
    VendorAppStrings.type: VendorAppStrings.type,
    VendorAppStrings.user: VendorAppStrings.user,
    VendorAppStrings.comment: VendorAppStrings.comment,
    VendorAppStrings.couponCode: VendorAppStrings.couponCode,
    VendorAppStrings.startDate: VendorAppStrings.startDate,
    VendorAppStrings.endDate: VendorAppStrings.endDate,
    VendorAppStrings.order: VendorAppStrings.order,
    VendorAppStrings.paypalIdHeader: VendorAppStrings.paypalIdHeader,
    VendorAppStrings.upiIdHeader: VendorAppStrings.upiIdHeader,

// Empty State Messages
    VendorAppStrings.noImagesSelected: VendorAppStrings.noImagesSelected,
    VendorAppStrings.noAttachmentsSelected: VendorAppStrings.noAttachmentsSelected,

// Copyright
    VendorAppStrings.copyrightText: VendorAppStrings.copyrightText,

// Search Placeholder
    VendorAppStrings.searchPlaceholder: VendorAppStrings.searchPlaceholder,

// Shipping
    VendorAppStrings.shippingFee: VendorAppStrings.shippingFee,
    VendorAppStrings.orderSuffix: VendorAppStrings.orderSuffix,

// Error Messages
    VendorAppStrings.error: VendorAppStrings.error,
    VendorAppStrings.downloadAgreement: VendorAppStrings.downloadAgreement,

// Screen Titles
    VendorAppStrings.bankDetails: VendorAppStrings.bankDetails,
    VendorAppStrings.loginInformation: VendorAppStrings.loginInformation,
    VendorAppStrings.businessOwnerInformation: VendorAppStrings.businessOwnerInformation,
    VendorAppStrings.emailVerificationPending: VendorAppStrings.emailVerificationPending,
    VendorAppStrings.pleaseVerifyEmail: VendorAppStrings.pleaseVerifyEmail,
    VendorAppStrings.checkInboxSpam: VendorAppStrings.checkInboxSpam,
    VendorAppStrings.accountVerified: VendorAppStrings.accountVerified,
    VendorAppStrings.emailVerificationPendingStatus: VendorAppStrings.emailVerificationPendingStatus,
    VendorAppStrings.verify: VendorAppStrings.verify,
    VendorAppStrings.resend: VendorAppStrings.resend,

// Additional Screen Titles
    VendorAppStrings.authorizedSignatoryInformation: VendorAppStrings.authorizedSignatoryInformation,
    VendorAppStrings.companyInformation: VendorAppStrings.companyInformation,
    VendorAppStrings.contractAgreement: VendorAppStrings.contractAgreement,
    VendorAppStrings.pleaseSignHere: VendorAppStrings.pleaseSignHere,

    VendorAppStrings.clear: VendorAppStrings.clear,

    VendorAppStrings.pleaseSignAgreement: VendorAppStrings.pleaseSignAgreement,
    VendorAppStrings.youMustAgreeToProceed: VendorAppStrings.youMustAgreeToProceed,
// Additional Form Labels
    VendorAppStrings.tradeLicenseNumberExpiryDate: VendorAppStrings.tradeLicenseNumberExpiryDate,
    VendorAppStrings.nocPoaIfApplicablePdf: VendorAppStrings.nocPoaIfApplicablePdf,
    VendorAppStrings.vatCertificateIfApplicablePdf: VendorAppStrings.vatCertificateIfApplicablePdf,

// Additional Form Hints

// Additional Dropdown Options

// Additional Error Messages
    VendorAppStrings.nowAed: VendorAppStrings.nowAed,
    VendorAppStrings.youWillBeRedirectedToTelrTabby: VendorAppStrings.youWillBeRedirectedToTelrTabby,
    VendorAppStrings.paymentFailure: VendorAppStrings.paymentFailure,
    VendorAppStrings.congratulations: VendorAppStrings.congratulations,

// Business and Authorization
    VendorAppStrings.areYouBusinessOwner: VendorAppStrings.areYouBusinessOwner,
    VendorAppStrings.areYouAuthorizedSignatory: VendorAppStrings.areYouAuthorizedSignatory,
  },
  // Arabic
  'ar': {
    'walletApplicable': 'متاح الدفع باستخدام المحفظة',
    AppStrings.vendorSubscriptionOneYear: 'اشتراك البائع (سنة واحدة)',
    AppStrings.vendorSubscriptionDescription: 'هذه رسوم لمرة واحدة لتسجيل البائع.',
    'loginSuccessfully': 'تم تسجيل الدخول بنجاح',
    'paidAmount': 'المبلغ المدفوع',
    'saveLower': 'حفظ',
    'shippingUp': 'الشحن',
    'statusUp': 'الحالة',
    'shippingMethodUp': 'طريقة الشحن',
    'downloadInvoice': 'تحميل الفاتورة',
    'ordersLower': 'الطلبات',
    'updateShippingStatusFull': 'تحديث حالة الشحن',
    'weightUp': 'الوزن (غرام)',
    'editOrder': 'تعديل الطلب',
    'orderInformation': 'معلومات الطلب',
    'vendorSubscriptionExpired': 'انتهى اشتراكك',
    'youMustAddAddressFirstToContinue': 'يجب إضافة عنوان أولاً للمتابعة',
    'noShippingMethodAvailable': 'لا توجد طريقة شحن متاحة',
    'addingNewAttributesHelps': 'إضافة سمات جديدة تساعد المنتج على الحصول على العديد من الخيارات مثل الحجم أو اللون.',
    'digitalLinks': 'روابط رقمية',
    'fileName': 'اسم الملف',
    'externalLink': 'رابط خارجي',
    'size': 'الحجم',
    'saved': 'تم الحفظ',
    'unsaved': 'غير محفوظ',
    'authenticationFailed': 'فشل المصادقة. يرجى تسجيل الدخول مرة أخرى.',
    'authenticationRequired': 'مطلوب المصادقة',
    'requestCancelled': 'تم إلغاء الطلب',
    'failedToAddItemToCart': 'فشل في إضافة العنصر إلى السلة',
    'somethingWentWrong': 'حدث خطأ ما.',
    'anErrorOccurred': 'حدث خطأ. حاول مرة أخرى.',
    'failedToLoadCartData': 'فشل في تحميل بيانات السلة.',
    'failedToLoadCheckoutData': 'فشل في تحميل بيانات الدفع.',
    'anErrorOccurredDuringCheckout': 'حدث خطأ أثناء عملية الدفع.',
    'anErrorOccurredWhileUpdatingCart': 'حدث خطأ أثناء تحديث السلة.',
    'noOrdersFound': 'لم يتم العثور على أي طلبات.',
    'failedToLoadAddresses': 'فشل في تحميل العناوين.',
    'addressDeleteSuccess': 'تم حذف العنوان بنجاح!',
    'failedToDeleteAddress': 'فشل في حذف العنوان.',
    'errorDeletingAddress': 'حدث خطأ أثناء حذف العنوان.',
    'addressUpdateSuccess': 'تم تحديث العنوان بنجاح!',
    'invalidAddressData': 'الرجاء إدخال بيانات صالحة.',
    'failedToLoadData': 'فشل في تحميل البيانات.',
    'pleaseLoginWishlist': 'يرجى تسجيل الدخول لإدارة قائمة المفضلات.',
    'wishlistUpdateFailed': 'فشل في تحديث قائمة المفضلات.',
    'unknownError': 'حدث خطأ غير معروف.',

    'pleaseSelectShipmentStatus': 'يرجى تحديد حالة الشحنة',
    'failedToUpdateShipmentStatus': 'فشل في تحديث حالة الشحنة',
    'resendEmail': 'إعادة إرسال البريد الإلكتروني',
    'paymentMethod': 'طريقة الدفع',
    'paymentStatus': 'حالة الدفع',
    'shippingInformation': 'معلومات الشحن',
    'updateShippingStatus': 'تحديث حالة الشحن',
    'errorFetchingProducts': 'حدث خطأ أثناء جلب المنتجات',
    'camera': 'الكاميرا',
    'gallery': 'المعرض',
    // Validator messages (Arabic placeholders - to be translated)
    'valEmailEmpty': 'Email cannot be empty',
    'valEmailInvalid': 'Enter a valid email address.',
    'valRequiredField': 'This field is required',
    'valUrlInvalid': 'Please enter a valid link',
    'valPhoneEmpty': 'Phone number cannot be empty',
    'valPhone9Digits': 'Phone number should be 9 digits long',
    'valPhoneDigitsOnly': 'Phone number should contain only numbers.',
    'valCompanyMobileRequired': 'Company mobile number is required',
    'valCompanyMobile9Digits': 'Company mobile number should be 9 digits long',
    'valCompanyMobileDigitsOnly': 'Company mobile number should contain only numbers.',
    'valLandlineRequired': 'Phone number (Landline) is required',
    'valLandline8Digits': 'Phone number (Landline) should be 8 digits long',
    'valLandlineDigitsOnly': 'Phone number (Landline) should contain only numbers.',
    'valPhoneRequired': 'Phone is required',
    'valGenderRequired': 'Please select gender',
    'valNameEmpty': 'Name cannot be empty',
    'valNameRequired': 'Name is required',
    'valNameMax25': 'Name cannot be more than 25 characters',
    'valBankNameRequired': 'Bank name is required',
    'valAccountNameRequired': 'Account name is required',
    'valAccountNumberRequired': 'Account number is required',
    'valRegionRequired': 'Please select region',
    'valCountryRequired': 'Please select country',
    'valEidRequired': 'Emirates ID number is required',
    'valEid15Digits': 'Emirates ID number must be 15 digits long.',
    'valCompanyCategoryRequired': 'Company category type is required',
    'valEidExpiryRequired': "EID number's expiry date is required",
    'valTradingNumberRequired': 'Trading number is required',
    'valTradingNumberLength': 'Trading License number must be between 10 and 15 characters long.',
    'valTradeLicenseExpiryRequired': "Trade License number's expiry date is required",
    'valFieldRequiredAlt': 'This Field cannot be empty.',
    'valCompanyAddressRequired': 'Company address is required',
    'valCompanyNameRequired': 'Company name is required',
    'valCompanyNameMax50': 'Company name cannot be more than 50 characters',
    'valCompanySlugRequired': 'Company slug is required',
    'valCompanySlugMax20': 'Company slug cannot be more than 20 characters',
    'valZipEmpty': 'Zip code cannot be empty',
    'valZip5Digits': 'Zip Code must be 5 digits long.',
    'valZipDigitsOnly': 'Zip Code should contain only numbers.',
    'valPasswordEmpty': 'Password cannot be empty.',
    'valPasswordMin9': 'Password should be at least 9 characters long.',
    'valPasswordPolicyFull':
        'Password must include at least one uppercase letter, one lowercase letter, one digit, and one special character.',
    'valVendorPasswordMin9': 'Password should be at least 9 characters long',
    'valVendorPasswordCaseReq': 'Password must contain at least one uppercase and one lowercase letter.',
    'valPaypalIdMax120': 'PayPal ID must not be greater than 120 characters.',
    'valPaypalEmailInvalid': 'Enter a valid PayPal email ID.',
    'valIFSCMax120': 'Bank code/IFSC must not be greater than 120 characters.',
    'valAccountNumberMax120': 'Account number must not be greater than 120 characters.',
    'valCouponsNumMin1': 'Number of coupons must be greater than or equal to 1',
    'valDiscountMin1': 'Discount must be greater than or equal to 1',
    'valPermalinkRequired': 'Product permanent link is required.',
    'valPermalinkUnique': 'Please generate unique permanent link.',
    'valStartDateAfterEnd': 'Start date cannot be after end date.',
    'valInvalidDateFormat': 'Invalid date format.',
    'valAddressRequired': 'Address field is required.',
    'valAddressMin5': 'Address must be at least 5 characters long.',
    'valAddressMax100': 'Address must not exceed 100 characters.',
    'valCityRequired': 'City field is required.',
    'valCityMin2': 'City name must be at least 2 characters long.',
    'valCityMax50': 'City name must not exceed 50 characters.',
    'valCityChars': 'City name can only contain letters, spaces, and hyphens.',
    'valIbanRequired': 'IBAN number is required',
    'valIbanLength': 'Invalid IBAN length',
    'valIbanFormat': 'Invalid IBAN format',
    'chooseDiscountPeriod': 'اختر فترة الخصم',
    'customerWontSeeThisPrice': 'لن يرى العملاء هذا السعر',
    'In stock': 'متوفر في المخزون',
    'Out of stock': 'غير متوفر في المخزون',
    'On backorder': 'قيد الطلب المسبق',
    'percentFromOriginalPrice': 'النسبة المئوية من السعر الأصلي',
    'allowCustomerCheckoutWhenOut of stock': 'السماح للعميل بإتمام الشراء عند نفاد المخزون',
    'stockStatus': 'حالة المخزون',
    'priceField': 'حقل السعر',
    'priceFieldDescription':
        'أدخل المبلغ الذي تريد خصمه من السعر الأصلي. مثال: إذا كان السعر الأصلي 100 دولار، أدخل 20 لتقليل السعر إلى 80 دولارًا.',
    'typeField': 'حقل النوع',
    'typeFieldDescription': 'اختر نوع الخصم: ثابت (خصم مبلغ محدد) أو نسبة مئوية (خصم بنسبة مئوية من السعر).',

    'searchProducts': 'ابحث عن المنتجات',
    'selectedProductAlreadyAdded': 'تمت إضافة المنتج المحدد بالفعل في القائمة',
    'pleaseSearchAndAddProducts': 'يرجى البحث وإضافة المنتجات',
    'productOptionsDes': 'يرجى إضافة خيارات المنتج بالضغط على زر + في الزاوية اليمنى السفلية.',
    'pleaseSelectType': 'يرجى اختيار النوع',
    'selectSectionType': 'اختر نوع القسم',
    'addGlobalOptions': 'إضافة خيارات عامة',
    'addNewRow': 'إضافة صف جديد',
    'selectFromExistingFAQs': 'اختر من الأسئلة الشائعة الموجودة',
    'or': 'أو',
    'add': 'إضافة',
    'addKeyword': 'إضافة كلمة مفتاحية',
    'addMoreAttribute': 'أضف سمة أخرى',
    'pendingProducts': 'المنتجات المعلقة',
    'pendingPackages': 'الباقات المعلقة',
    'request': 'طلب',
    'publish': 'نشر',
    'afterCancelAmountAndFeeWillBeRefundedBackInYourBalance': 'بعد الإلغاء، سيتم استرجاع المبلغ والرسوم إلى رصيدك.',
    'doYouWantToCancelThisWithdrawal': 'هل تريد إلغاء عملية السحب هذه؟',
    'youWillReceiveMoneyThroughTheInformation': 'ستتلقى الأموال من خلال المعلومات التالية:',
    'payoutInfo': 'معلومات الدفع',
    'noRecordFound': 'لم يتم العثور على سجلات',
    'sku': 'رمز المنتج (SKU)',
    'code': 'الرمز',
    'amount': 'المبلغ',
    'totalUsed': 'إجمالي الاستخدام',
    'noGiftCardsFound': 'لم يتم العثور على بطاقات هدايا',
    'createFirstGiftCard': 'أنشئ أول بطاقة هدايا لك',
    'createGiftCard': 'إنشاء بطاقة هدايا',
    'becomeSeller': 'كن بائعًا',
    'yesBecomeSeller': 'نعم، أريد أن أصبح بائعًا',
    'becomeSellerConfirmation': 'هل أنت متأكد أنك تريد أن تصبح بائعًا؟',
    'menu': 'القائمة',
    'pleaseLogInToContinue': 'يرجى تسجيل الدخول للمتابعة',
    'pleaseAddNewAddress': 'يرجى إضافة عنوان جديد',
    'pleaseSelectAnAddress': 'يرجى اختيار عنوان',
    'other': 'أخرى',
    'Transaction Confirmations': 'تأكيدات المعاملات',
    'Deposits, purchases, confirmations': 'الإيداعات، المشتريات، التأكيدات',

    'Achievement Alerts': 'تنبيهات الإنجازات',
    'Milestones, rewards, goals': 'المعالم، المكافآت، الأهداف',

    'Expiry Reminders': 'تذكيرات بانتهاء الصلاحية',
    'Product expiry, renewal alerts': 'انتهاء صلاحية المنتج، تنبيهات التجديد',

    'Promotional Messages': 'رسائل ترويجية',
    'Marketing updates, special offers': 'تحديثات تسويقية، عروض خاصة',

    'Security Alerts': 'تنبيهات الأمان',
    'Login alerts, security updates': 'تنبيهات تسجيل الدخول، تحديثات الأمان',

    'System Updates': 'تحديثات النظام',
    'App updates, maintenance notices': 'تحديثات التطبيق، إشعارات الصيانة',

    'database': 'قاعدة البيانات',
    'sms': 'رسالة نصية',
    'broadcast': 'بث',
    'mail': 'البريد',
    'Transaction': 'المعاملات',
    'Expiry Reminder': 'تذكير بانتهاء الصلاحية',
    'Promotional': 'ترويجي',
    'Security': 'الأمان',
    'System': 'النظام',
    'Achievements': 'الإنجازات',
    'copyrightText': '© 2025 ذا إيفنتس. جميع الحقوق محفوظة.',
    'enterYourCouponCode': 'أدخل رمز القسيمة الخاص بك',
    'redeemYourGiftCard': 'استرد بطاقة الهدايا الخاصة بك',
    'noFees': 'بدون رسوم',
    AppStrings.markAsUnread: 'تحديد كغير مقروء',
    AppStrings.markAsRead: 'تحديد كمقروء',
    AppStrings.noExpiringFundsFound: 'لم يتم العثور على صناديق منتهية',
    AppStrings.notificationSettings: 'إعدادات الإشعارات',
    AppStrings.notificationTypes: 'أنواع الإشعارات',
    'fundExpiryAlert': 'تنبيه انتهاء الرصيد',
    'criticalActionRequired': 'حرج - مطلوب اتخاذ إجراء',
    'transactionsCount': 'إجمالي المعاملات',
    '7Days': '٧ أيام',
    '30Days': '٣٠ يومًا',
    '90Days': '٩٠ يومًا',
    'currentMonth': 'الشهر الحالي',
    'lastMonth': 'الشهر الماضي',
    'currentYear': 'السنة الحالية',
    'lastYear': 'السنة الماضية',
    'transactionHistory': 'تاريخ المعاملات',
    'export': 'تصدير',
    'searchTransactions': 'البحث في المعاملات...',
    'allTypes': 'جميع الأنواع',
    'deposit': 'إيداع',
    'payment': 'دفع',
    'reward': 'مكافأة',
    'refund': 'استرداد',
    'allMethods': 'جميع الطرق',
    'creditCard': 'بطاقة ائتمان',
    'giftCard': 'بطاقة هدية',
    'bankTransfer': 'تحويل مصرفي',
    'thirtyDays': '30 يوم',
    'sevenDays': '7 أيام',
    'ninetyDays': '90 يوم',
    'allTime': 'كل الأوقات',
    'reset': 'إعادة تعيين',
    // Notifications Screen translations
    'notifications': 'الإشعارات',
    'markAllRead': 'تحديد الكل كمقروء',
    'noNotificationsYet': 'لا توجد إشعارات حتى الآن',
    'notificationsEmptyMessage': 'ستظهر هنا التحديثات المهمة\nوالتنبيهات حول محفظتك.',
    AppStrings.wallet: 'المحفظة',
    AppStrings.digitalWallet: 'المحفظة الرقمية',
    AppStrings.expirySoon: 'ستنتهي قريبًا',
    AppStrings.currentBalanceTitle: 'الرصيد الحالي',
    AppStrings.rewardsEarnedTitle: 'المكافآت المكتسبة',
    AppStrings.walletBalanceTitle: 'رصيد المحفظة',
    AppStrings.lastUpdatedPrefix: 'آخر تحديث',
    AppStrings.addFunds: 'إضافة رصيد',
    AppStrings.history: 'السجل',
    AppStrings.notifications: 'الإشعارات',
    AppStrings.deposits: 'الإيداعات',
    AppStrings.overview: 'نظرة عامة',
    AppStrings.addFundsToWallet: 'إضافة رصيد إلى المحفظة',
    AppStrings.selectDepositMethod: 'اختر طريقة الإيداع',
    AppStrings.couponCodeGiftCard: 'رمز القسيمة (بطاقة هدية)',
    AppStrings.amountAed: 'المبلغ (درهم)',
    AppStrings.instant: 'فوري',
    AppStrings.giftCard: 'بطاقة هدية',
    AppStrings.creditDebitCard: 'بطاقة ائتمان/خصم',
    AppStrings.visaMasterAccepted: 'فيزا وماستركارد مقبولتان',
    AppStrings.processingFeeSuffix: 'رسوم معالجة',
    AppStrings.balanceLabel: 'الرصيد: ',
    AppStrings.was: 'كان: ',
    AppStrings.applePay: 'أبل للدفع',
    AppStrings.applePaySubtitle: 'ادفع باستخدام محفظة أبل الخاصة بك',
    AppStrings.paymentCard: 'بطاقة',
    AppStrings.paymentTabby: 'تابي',
    AppStrings.paymentTamara: 'تمارا',
    AppStrings.termsNote: 'طلبكم يعني موافقتكم على الشروط والأحكام بعد قراءتها',
    AppStrings.selectFromExistingAddresses: 'اختر من العناوين الحالية',
    AppStrings.orderSummary: 'ملخص الطلب',
    AppStrings.subtotalUpper: 'المجموع الفرعي',
    AppStrings.taxVat: 'الضريبة (VAT)',
    AppStrings.shipping: 'الشحن',
    AppStrings.couponDiscount: 'خصم الكوبون',
    AppStrings.promotionDiscount: 'خصم الترويج',
    AppStrings.totalUpper: 'الإجمالي',
    AppStrings.deliverTo: 'التسليم إلى',
    AppStrings.noAddressSelected: 'لم يتم اختيار عنوان',
    AppStrings.addressDetailsNotFound: 'لم يتم العثور على تفاصيل العنوان',
    AppStrings.areaState: 'المنطقة/الولاية',
    AppStrings.phoneNumber: 'رقم الهاتف',
    AppStrings.grandTotal: 'الإجمالي الكلي',
    AppStrings.payNowTitle: 'ادفع الآن',
    AppStrings.paymentCompletedSuccessfully: 'تم الدفع بنجاح',
    AppStrings.applePayFailed: 'فشل دفع Apple Pay. حاول مرة أخرى.',
    AppStrings.applePayErrorPrefix: 'خطأ في دفع Apple Pay: ',
    'confirmPaymentCancel': 'إلغاء الدفع؟',
    'paymentCancelWarning': 'هل أنت متأكد من أنك تريد إلغاء الدفع؟',
    'continuePayment': 'متابعة الدفع',
    'cancelPayment': 'إلغاء الدفع',
    'noOrderDetailsFound': 'لم يتم العثور على تفاصيل الطلب',
    'retry': 'إعادة المحاولة',
    'orderPlacedSuccessfully': 'تم تقديم الطلب بنجاح! تحقق من طلباتك للحصول على التفاصيل.',
    'payment_successful': 'تم الدفع بنجاح',
    'payment_failed': 'فشل الدفع',
    'payment_cancelled': 'تم إلغاء الدفع',
    'payment_link_error': 'فشل في إنشاء رابط الدفع',
    'vendorAccountUnderReview': 'حساب البائع الخاص بك قيد المراجعة وفي انتظار الموافقة.',
    AppStrings.vendorAccountUnderReview: 'حسابك كبائع قيد المراجعة وينتظر الموافقة.',
    'content': 'المحتوى',
    'pleaseSelectRequiredOptions': 'يرجى تحديد جميع الخيارات المطلوبة',
    'dismiss': 'إغلاق',
    'Bazaar': 'بازار',
    'state': 'الولاية',
    'stateIsRequired': 'الولاية مطلوبة',
    'cityIsRequired': 'المدينة مطلوبة',
    'selectState': 'اختر الولاية',
    'selectCity': 'اختر المدينة',
    'unknownState': 'ولاية غير معروفة',
// Core App Strings (Arabic translations)
    AppStrings.darkMode: 'الوضع الداكن',
    AppStrings.giftsByOccasion: 'هدايا حسب المناسبة',
    AppStrings.changeLanguage: 'تغيير اللغة',
    AppStrings.welcomeMessage: 'مرحبًا بك في تطبيقنا!',
    AppStrings.loginSignUp: 'تسجيل الدخول/التسجيل',
    AppStrings.cart: 'عربة التسوق',
    AppStrings.changePassword: 'تغيير كلمة المرور',
    AppStrings.redeemCard: 'استرداد بطاقة الهدية',
    AppStrings.joinAsSeller: 'انضم كبائع',
    AppStrings.joinUsSeller: 'انضم إلينا كبائع',
    AppStrings.privacyPolicy: 'سياسة الخصوصية',
    AppStrings.aboutUs: 'من نحن',
    AppStrings.location: 'الموقع',
    AppStrings.helpAndSupport: 'المساعدة والدعم',
    AppStrings.signUp: 'التسجيل',
    AppStrings.signIn: 'تسجيل الدخول',

    AppStrings.description: 'الوصف',
    AppStrings.termsAndConditions: 'الشروط والأحكام',
    AppStrings.buyAndRedeem: 'شراء واسترداد',
    AppStrings.vendor: 'لوحة تحكم البائع',
    AppStrings.vendorAgreement: 'اتفاقية البائع',

// Descriptions (Arabic)
    AppStrings.descriptionGiftCard:
        'تبحث عن الهدية المثالية؟ بطاقات الهدايا الإلكترونية للأحداث هنا لجعل الإهداء أمرًا سهلاً. هديتنا الإلكترونية هي الطريقة الأسهل والأكثر ملاءمة لإعطاء أحبائك بالضبط ما يريدون. قم بتخصيصها برسالة صادقة واترك الباقي لنا.',
    AppStrings.termsAndConditionsText:
        'يمكن استرداد بطاقات الهدايا الإلكترونية للحصول على رصيد على موقعنا الإلكتروني أو تطبيق الهاتف المحمول. بطاقة الهدية الإلكترونية صالحة لمدة سنة واحدة من تاريخ الشراء. لا توجد رسوم أو تكاليف إضافية لشراء بطاقات الهدايا الإلكترونية الخاصة بنا. ومع ذلك، فهي غير قابلة للإلغاء وغير قابلة للاسترداد بمجرد شرائها. يرجى التأكد من دقة جميع معلومات المستلم، حيث لن نكون مسؤولين عن استرداد أو استبدال رمز بطاقة الهدية الإلكترونية الموجه خطأً.',
    AppStrings.redeemFirstLine: 'اختر مبلغ تحميل مسبق أو أدخل مبلغًا مخصصًا',
    AppStrings.redeemSecondLine: 'قدم اسم المستلم وبريده الإلكتروني',
    AppStrings.redeemThirdLine: 'بعد المعاملة، سيتلقى المستلم رمز بطاقة الهدية الإلكترونية عبر البريد الإلكتروني',
    AppStrings.redeemForthLine: 'يمكن للمستلم استرداد مبلغ الهدية بالنقر على الرابط وإدخال الرمز',
    AppStrings.redeemFifthLine: 'بمجرد الاسترداد، سيتم إضافة المبلغ إلى رصيد أحداث المستلم',

// Cart & Shopping (Arabic)
    AppStrings.myCart: 'عربة التسوق الخاصة بي',
    AppStrings.back: 'العودة',
    AppStrings.totalColon: 'المجموع: ',
    AppStrings.profile: 'الملف الشخصي',
    AppStrings.shippingFees: '(رسوم الشحن غير مشمولة)',
    AppStrings.proceedToCheckOut: 'المتابعة للدفع',
    AppStrings.addToCart: 'إضافة إلى العربة',
    AppStrings.subTotalColon: 'المجموع الفرعي: ',
    AppStrings.taxColon: 'الضريبة: ',
    AppStrings.couponCodeText: 'كود الكوبون',
    AppStrings.couponCodeAmount: 'مبلغ خصم كود الكوبون: ',
    AppStrings.shippingFee: 'رسوم الشحن',
    AppStrings.switchLanguage: 'تبديل اللغة',
    AppStrings.wishList: 'قائمة الأماني',
    AppStrings.emptyWishList: 'قائمة أمانيك فارغة!',
    AppStrings.viewAll: 'عرض الكل',
    AppStrings.quantity: 'الكمية:',
    AppStrings.percentOff: '% خصم',
    AppStrings.off: 'خصم',
    AppStrings.gotoWishlist: 'الذهاب إلى قائمة الأماني',
    AppStrings.continueShopping: 'متابعة التسوق',
    AppStrings.cartIsEmpty: 'عربة التسوق فارغة \n ابدأ بالإضافة إلى عربتك',
    AppStrings.aed: 'درهم',

    // About Us (Arabic)
    AppStrings.aboutUsEvents:
        'في إيفنتس نؤمن أن كل مناسبة تستحق أن تُحتفل بها بتميز. تأسسنا في دولة الإمارات العربية المتحدة، وتمكنا خلال فترة قصيرة من أن نصبح من أبرز المنصات الإلكترونية المتخصصة في المناسبات والهدايا وتجارب أسلوب الحياة في المنطقة. نربط عملاءنا مع مجموعة واسعة من البائعين والعلامات التجارية ومقدمي الخدمات الموثوقين – بدءًا من الزهور والهدايا الفاخرة، مرورًا بالمنتجات الراقية، ووصولًا إلى التجارب والخدمات الخاصة بالمناسبات – وذلك من خلال منصة رقمية واحدة سهلة الاستخدام. رسالتنا بسيطة: أن نجعل عملية الاكتشاف، والحجز، والإهداء تجربة سلسة وملهمة. ومن خلال الجمع بين التقنيات الحديثة وفهمنا العميق للثقافة المحلية والاتجاهات العالمية، نضمن أن تصل كل طلبية بجودة وموثوقية عالية. وانطلاقًا من رؤيتنا المستقبلية، فإننا نتوسع اليوم خارج حدود الإمارات، واضعين هدفًا واضحًا يتمثل في تغطية جميع دول مجلس التعاون الخليجي لنقدم خدماتنا المبتكرة وتجربتنا المميزة لعملائنا في مختلف أنحاء المنطقة. في إيفنتس لسنا مجرد منصة إلكترونية، بل نحن شريككم في صناعة لحظات لا تُنسى تدوم مدى الحياة.',
    AppStrings.ourMissionText:
        'في إيفنتس، تتمثل مهمتنا في تبسيط أسلوب الاحتفال والتواصل بين الناس. نسعى إلى توفير منصة رقمية متكاملة تجمع بين البائعين الموثوقين، والمنتجات الفاخرة، والخدمات المميزة، لنُسهّل تنظيم كل مناسبة، ونجعلها أكثر متعة في تجربتها، وأكثر جمالًا في ذكراها.',
    AppStrings.ourVisionText:
        'رؤيتنا أن نصبح الوجهة الإلكترونية الأولى للمناسبات والهدايا وتجارب أسلوب الحياة على مستوى دول مجلس التعاون الخليجي. ومن خلال الابتكار والموثوقية والالتزام بالأصالة الثقافية، نطمح إلى إلهام الملايين من العملاء والشركاء للاحتفال بلحظات الحياة وتميزها.',
    AppStrings.ourMission: 'مهمتنا',
    AppStrings.ourVision: 'رؤيتنا',
    AppStrings.ourValues: 'قيمنا',
    AppStrings.ourLocation: 'نحن نغطي',
    AppStrings.vendorHeading: 'أنشئ حسابًا لتتبع عملائك ومساهميك. بمجرد إنشاء حسابك، سنرسل لك تأكيدًا عبر البريد.',
    AppStrings.vendorContactHeading: 'راجع الاتفاقية وتأكد من دقة جميع المعلومات. ثم تابع إلى الدفع.',
    AppStrings.who: 'من ',
    AppStrings.weAre: 'نحن',
    AppStrings.our: 'لدينا',
    AppStrings.mission: 'مهمة',
    AppStrings.vision: 'رؤية',
    AppStrings.values: 'القيم',
    AppStrings.simplicity: 'البساطة',
    AppStrings.innovation: 'الابتكار',
    AppStrings.thoughtfulness: 'الرعاية',
    AppStrings.reliability: 'الموثوقية',

// Vendor (Arabic)
    AppStrings.agreementAccept: 'أوافق على الشروط والأحكام',
    AppStrings.registrationDone: 'تم التسجيل بنجاح! \n يمكنك الآن المتابعة للدفع.',
    AppStrings.paymentDone: 'تم الدفع بنجاح!',
    AppStrings.paymentThanks: 'شكراً لك على إكمال عملية الدفع.',

// Countries (Arabic)
    AppStrings.unitedArabEmirates: 'الإمارات العربية المتحدة',
    AppStrings.saudiArabia: 'المملكة العربية السعودية',
    AppStrings.bahrain: 'البحرين',
    AppStrings.kuwait: 'الكويت',
    AppStrings.oman: 'عمان',
    AppStrings.qatar: 'قطر',

// Authentication (Arabic)
    AppStrings.forgetPassword: 'نسيت كلمة المرور؟',
    AppStrings.doNotHaveAccountYet: 'ليس لديك حساب بعد؟',
    AppStrings.createOneNow: 'إنشاء حساب الآن',
    AppStrings.send: 'إرسال',
    AppStrings.emailAddress: 'عنوان البريد الإلكتروني',
    AppStrings.emailRequired: 'البريد الإلكتروني مطلوب',
    AppStrings.login: 'تسجيل الدخول',
    AppStrings.enterYourEmail: 'أدخل بريدك الإلكتروني',
    AppStrings.passRequired: 'كلمة المرور مطلوبة',
    AppStrings.enterYourPassword: 'أدخل كلمة مرورك',
    AppStrings.continueo: 'متابعة',
    AppStrings.getHelp: 'احصل على مساعدة',
    AppStrings.haveTroubleLogging: 'هل تواجه مشكلة في تسجيل الدخول؟',
    AppStrings.fullName: 'الاسم الكامل',
    AppStrings.confirmPassword: 'تأكيد كلمة المرور',
    AppStrings.passwordValidation: 'كلمة المرور يجب أن لا تقل عن 6 أحرف.',
    AppStrings.agreement: 'اتفاقية',
    AppStrings.terms: 'الشروط',
    AppStrings.searchEvents: 'ابحث في ايفنتس',
    AppStrings.notification: 'الإشعارات',
    AppStrings.confirmLogout: 'تأكيد تسجيل الخروج',
    AppStrings.confirmLogoutMessage: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
    AppStrings.logout: 'تسجيل الخروج',
// Profile & Account (Arabic)
    AppStrings.address: 'العنوان',
    AppStrings.giftCards: 'بطاقات الهدايا',
    AppStrings.reviews: 'المراجعات',
    AppStrings.orders: 'الطلبات',
    AppStrings.myAccount: 'حسابي',
    AppStrings.enterCurrentPassword: 'أدخل كلمة المرور الحالية',
    AppStrings.currentPasswordCannotBeEmpty: 'كلمة المرور الحالية لا يمكن أن تكون فارغة',
    AppStrings.currentPassword: 'كلمة المرور الحالية',
    AppStrings.enterChangePassword: 'أدخل كلمة المرور الجديدة',
    AppStrings.enterReEnterPassword: 'أعد إدخال كلمة المرور الجديدة',
    AppStrings.reEnterPassword: 'أعد إدخال كلمة المرور',
    AppStrings.update: 'تحديث',
    AppStrings.pleaseEnterFields: 'الرجاء إدخال جميع الحقول',
    AppStrings.noRecord: 'لا يوجد سجلات',
    AppStrings.edit: 'تعديل',
    AppStrings.phone: 'الهاتف',
    AppStrings.email: 'البريد الإلكتروني',
    AppStrings.name: 'الاسم',
    AppStrings.defaultAddress: 'العنوان الافتراضي',
    AppStrings.create: 'إنشاء',
    AppStrings.unknownCountry: 'دولة غير معروفة',
    AppStrings.pleaseCheckFields: 'الرجاء التحقق من الحقول',
    AppStrings.addressSaved: 'تم حفظ العنوان',
    AppStrings.save: 'حفظ',
    AppStrings.useDefaultAddress: 'استخدم هذا العنوان كافتراضي',
    AppStrings.cityCannotBeEmpty: 'المدينة لا يمكن أن تكون فارغة',
    AppStrings.city: 'المدينة',
    AppStrings.enterCity: 'أدخل المدينة',
    AppStrings.stateCannotBeEmpty: 'الولاية لا يمكن أن تكون فارغة',
    AppStrings.enterState: 'أدخل الولاية',
    AppStrings.pleaseSelectCountry: 'الرجاء اختيار الدولة',
    AppStrings.country: 'الدولة',
    AppStrings.enterCountry: 'أدخل الدولة',
    AppStrings.enterAddress: 'أدخل العنوان',
    AppStrings.enterEmailAddress: 'أدخل عنوان البريد الإلكتروني',
    AppStrings.enterPhoneNumber: 'أدخل رقم الهاتف',
    AppStrings.enterName: 'أدخل الاسم',
    AppStrings.enterYourName: 'أدخل اسمك',
    AppStrings.reviewed: 'تمت المراجعة',
    AppStrings.waitingForReview: 'في انتظار المراجعة',
    AppStrings.nameCannotBeEmpty: 'الاسم لا يمكن أن يكون فارغًا',
    AppStrings.phoneCannotBeEmpty: 'رقم الهاتف لا يمكن أن يكون فارغًا',
    AppStrings.pleaseFillAllFields: 'الرجاء ملء جميع الحقول',
    AppStrings.emailCannotBeEmpty: 'البريد الإلكتروني لا يمكن أن يكون فارغًا',
    AppStrings.deleteMyAccount: 'حذف حسابي',
    AppStrings.deleteAccount: 'حذف الحساب',
    AppStrings.delete: 'حذف',
    AppStrings.deleteAccountWarning: 'هل أنت متأكد أنك تريد حذف حسابك؟ لن تتمكن من استعادة بياناتك.',
    AppStrings.addressCannotBeEmpty: 'العنوان لا يمكن أن يكون فارغًا',

// Reviews (Arabic)
    AppStrings.noProductsAvailable: 'لا توجد منتجات متاحة للمراجعة',
    AppStrings.uploadPhotos: 'تحميل الصور',
    AppStrings.uploadPhotosMessage: 'الحد الأقصى 5 صور',
    AppStrings.submitReview: 'إرسال المراجعة',
    AppStrings.errorSubmittingReview: 'حدث خطأ أثناء إرسال المراجعة',
    AppStrings.review: 'مراجعة',
    AppStrings.failedToAddPhotos: 'فشل في إضافة الصور',
    AppStrings.maxFilesError: 'الحد الأقصى لعدد الملفات التي يمكن اختيارها هو 5.',
    AppStrings.noReviews: 'لا توجد مراجعات حتى الآن',
    AppStrings.customerReviews: 'مراجعات العملاء',
    AppStrings.reviewSeller: 'مراجعة البائع',
    AppStrings.reviewProduct: 'مراجعة المنتج',
    AppStrings.ratings: 'التقييمات',
    AppStrings.star: 'نجمة',
    AppStrings.stars: 'نجوم',

// Coupons (Arabic)
    AppStrings.couponAppliedSuccess: 'تم تطبيق الكوبون بنجاح!',
    AppStrings.couponRemovedSuccess: 'تمت إزالة الكوبون بنجاح!',
    AppStrings.couponInvalidOrExpired: 'الكوبون غير صالح أو انتهت صلاحيته.',
    AppStrings.couponLabel: 'أدخل رمز القسيمة',
    AppStrings.couponHint: 'كود الكوبون',

// Checkout & Payment (Arabic)
    AppStrings.continueToPayment: 'متابعة إلى الدفع',
    AppStrings.currencyAED: 'درهم إماراتي',
    AppStrings.acceptTermsAndConditions: 'أوافق على الشروط والأحكام',
    AppStrings.readOurTermsAndConditions: 'اقرأ الشروط والأحكام الخاصة بنا',
    AppStrings.mustAcceptTerms: 'يجب أن توافق على الشروط والأحكام للمتابعة',
    AppStrings.confirmAndSubmitOrder: 'تأكيد وتقديم الطلب',
    AppStrings.byClickingSubmit: 'بالضغط على "تأكيد وتقديم الطلب"، فإنك توافق على',
    AppStrings.and: 'و',
    AppStrings.addNewAddress: 'إضافة عنوان جديد',
    AppStrings.saveAddress: 'حفظ العنوان',
    AppStrings.updateAddress: 'تحديث العنوان',
    AppStrings.addNewAddressTitle: 'إضافة عنوان جديد',
    AppStrings.nameIsRequired: 'الاسم مطلوب',
    AppStrings.countryIsRequired: 'الدولة مطلوبة',
    AppStrings.enterCorrectDetails: 'الرجاء إدخال التفاصيل الصحيحة',
    AppStrings.enterValidDetails: 'الرجاء إدخال تفاصيل صالحة',
    AppStrings.unknownAddress: 'عنوان غير معروف',
    AppStrings.unknownName: 'اسم غير معروف',
    AppStrings.unknownEmail: 'بريد إلكتروني غير معروف',
    AppStrings.unknownPhone: 'هاتف غير معروف',
    AppStrings.unknownCity: 'مدينة غير معروفة',
    AppStrings.unknownZipCode: 'رمز بريدي غير معروف',
    AppStrings.choosePaymentMethod: 'اختر طريقة الدفع',
    AppStrings.shippingAddressDescription: 'لن يتم خصم أي مبلغ حتى تراجع هذا الطلب في الصفحة التالية.',
    AppStrings.shippingAddress: 'عنوان الشحن',
    AppStrings.selectShippingAddress: 'اختر عنوان الشحن',
    AppStrings.shippingMethod: 'طريقة الشحن',
    AppStrings.checkout: 'الدفع',
    AppStrings.selectCountry: 'اختر الدولة',
    AppStrings.payment: 'الدفع',
    AppStrings.failedToLoadPaymentMethods: 'فشل في تحميل طرق الدفع',
    AppStrings.noPaymentMethodsAvailable: 'لا توجد طرق دفع متاحة',

// Filters & Sorting (Arabic)
    AppStrings.sortOption: 'خيارات الفرز',
    AppStrings.filters: 'الفلاتر',
    AppStrings.apply: 'تطبيق',
    AppStrings.filterOptions: 'خيارات التصفية',
    AppStrings.brands: 'العلامات التجارية',
    AppStrings.categories: 'الفئات',
    AppStrings.celebrities: 'المشاهير',
    AppStrings.events: AppStrings.events,
    AppStrings.account: 'الحساب',
    AppStrings.tags: 'العلامات',
    AppStrings.prices: 'الأسعار',
    AppStrings.colors: 'الألوان',
    AppStrings.sortByDefault: 'الفرز الافتراضي',
    AppStrings.sortByOldest: 'الفرز حسب الأقدم',
    AppStrings.sortByNewest: 'الفرز حسب الأحدث',
    AppStrings.sortByNameAz: 'الفرز حسب الاسم (أ-ي)',
    AppStrings.sortByNameZa: 'الفرز حسب الاسم (ي-أ)',
    AppStrings.sortByPriceLowToHigh: 'الفرز حسب السعر (من الأقل للأعلى)',
    AppStrings.sortByPriceHighToLow: 'الفرز حسب السعر (من الأعلى للأقل)',
    AppStrings.sortByRatingLowToHigh: 'الفرز حسب التقييم (من الأقل للأعلى)',
    AppStrings.sortByRatingHighToLow: 'الفرز حسب التقييم (من الأعلى للأقل)',

// Products (Arabic)
    AppStrings.noNotifications: 'لا توجد إشعارات',
    AppStrings.enterYourMessage: 'أدخل رسالتك',
    AppStrings.selectLocation: 'اختر الموقع',
    AppStrings.selectDate: 'اختر التاريخ',
    AppStrings.selectedDate: 'التاريخ المحدد:',
    AppStrings.messageCanNotBeEmpty: 'الرسالة لا يمكن أن تكون فارغة',
    AppStrings.pleaseSelectValidDate: 'الرجاء اختيار تاريخ صالح',
    AppStrings.pleaseSelectLocation: 'الرجاء اختيار الموقع',
    AppStrings.failedToLoadImage: 'فشل في تحميل الصورة',
    AppStrings.wishlist: 'قائمة الأماني',
    AppStrings.pleaseLogInToWishList: 'الرجاء تسجيل الدخول لإضافة المنتج إلى قائمة الأماني.',
    AppStrings.pleaseLogInToCart: 'الرجاء تسجيل الدخول لإضافة المنتج إلى عربة التسوق.',
    AppStrings.noAttributesAvailable: 'لا توجد خصائص متاحة',
    AppStrings.view: 'عرض',
    AppStrings.sellingBy: 'يباع بواسطة:',
    AppStrings.productDetails: 'تفاصيل المنتج',
    AppStrings.outOfStockStr: 'غير متوفر',
    AppStrings.includingVAT: 'شامل ضريبة القيمة المضافة',
    AppStrings.interestFreeInstallment: 'قسط بدون فائدة',
    AppStrings.moreColors: 'المزيد من الألوان',
    AppStrings.relatedProducts: 'منتجات ذات صلة',
    AppStrings.search: 'بحث',
    AppStrings.products: 'المنتجات',
    AppStrings.packages: ' الباقات',
    AppStrings.errorFetchingData: 'خطأ في جلب البيانات',
    AppStrings.productDescription: 'وصف المنتج',
    AppStrings.noProductsFound: 'لم يتم العثور على منتجات',
    AppStrings.searchGifts: 'بحث عن هدايا',
    AppStrings.searchBrands: 'بحث عن علامات تجارية',

// Common Actions (Arabic)
    AppStrings.removeWishlistTitle: 'إزالة من قائمة الأماني',
    AppStrings.removeWishlistMessage: 'هل أنت متأكد أنك تريد إزالة هذا المنتج من قائمة الأماني؟',
    AppStrings.cancel: 'إلغاء',
    AppStrings.yes: 'نعم',
    AppStrings.no: 'لا',
    AppStrings.soldBy: 'يباع بواسطة',
    AppStrings.loading: 'جار التحميل...',
    AppStrings.error: 'خطأ: ',
    AppStrings.confirmation: 'تأكيد',
    AppStrings.cancelOrderConfirmationMessage: 'هل أنت متأكد من المتابعة؟',
    AppStrings.allow: 'السماح',
    AppStrings.pending: 'المعلقة',
    AppStrings.completed: 'مكتمل',
    AppStrings.purchased: 'تم الشراء',
    AppStrings.noDataAvailable: 'لا توجد بيانات متاحة',
// Orders (Arabic)
    AppStrings.orderPlaced: 'تم تقديم الطلب',
    AppStrings.orderNoPrefix: 'رقم الطلب: ',
    AppStrings.orderDatePrefix: 'تاريخ الطلب: ',
    AppStrings.estimatedDeliveryPrefix: 'تاريخ التسليم المقدر: ',
    AppStrings.itemsSuffix: ' عناصر',
    AppStrings.itemBrandPrefix: 'العلامة التجارية للمنتج: ',
    AppStrings.itemColor: 'اللون: ',
    AppStrings.itemUKSize: 'المقاس (المملكة المتحدة): ',
    AppStrings.itemQuantityValue: 'الكمية: ',
    AppStrings.colorLabel: 'اللون',
    AppStrings.sizeLabel: 'المقاس',
    AppStrings.quantityLabel: 'الكمية',
    AppStrings.subTotal: 'المجموع الفرعي',
    AppStrings.discount: 'الخصم',
    AppStrings.tax: 'الضريبة',
    AppStrings.delivery: 'التوصيل',
    AppStrings.total: 'الإجمالي',
    AppStrings.deliveryDetails: 'تفاصيل التسليم',
    AppStrings.deliveryMethod: 'طريقة التسليم',
    AppStrings.standardDelivery: 'توصيل عادي',
    AppStrings.deliveryAddress: 'عنوان التسليم',
    AppStrings.paymentDetails: 'تفاصيل الدفع',
    AppStrings.paymentType: 'نوع الدفع',
    AppStrings.mastercard: 'ماستركارد',
    AppStrings.changedYourMind: 'غيرت رأيك؟',
    AppStrings.cancellingTheOrder: 'إلغاء الطلب',
    AppStrings.cancellationInfo: 'لا يمكننا إلغاء الطلب بعد تأكيده.',
    AppStrings.cancelWithinOneHour: 'إلغاء خلال ساعة واحدة',
    AppStrings.returnOrder: 'إرجاع الطلب',
    AppStrings.viewOrderUppercase: 'عرض الطلب',
    AppStrings.ordersCancelled: 'تم إلغاء الطلبات',
    AppStrings.oneItemCancelled: 'تم إلغاء عنصر واحد',
    AppStrings.perfume: 'عطر',
    AppStrings.refundDetails: 'تفاصيل الاسترداد',
    AppStrings.refundNotApplicable: 'لا ينطبق الاسترداد على هذا الطلب لأنه دفع عند الاستلام',
    AppStrings.refund: 'استرداد',
    AppStrings.noOrders: 'لا توجد طلبات',
    AppStrings.orderViewed: 'تم عرض الطلب',
    AppStrings.viewProduct: 'عرض المنتج',
    AppStrings.viewOrder: 'عرض الطلب',
    AppStrings.orderDetails: 'تفاصيل الطلب',
    AppStrings.orderInfo: 'معلومات الطلب',
    AppStrings.orderNumber: 'رقم الطلب',
    AppStrings.time: 'الوقت',
    AppStrings.orderStatus: 'حالة الطلب',
    AppStrings.charges: 'الرسوم',
    AppStrings.totalAmount: 'المبلغ الإجمالي',
    AppStrings.shippingInfo: 'معلومات الشحن',
    AppStrings.shippingStatus: 'حالة الشحن',
    AppStrings.dateShipped: 'تاريخ الشحن',
    AppStrings.uploadPaymentProof: 'تحميل إثبات الدفع',

    AppStrings.viewReceipt: 'عرض الإيصال: ',
    AppStrings.uploadedProofNote: 'لقد قمت بتحميل نسخة من إثبات الدفع.\n\n',
    AppStrings.reUploadNote: 'يمكنك أيضاً تحميل نسخة جديدة، وسيتم استبدال القديمة.',
    AppStrings.noProofUploaded: 'الطلب قيد المعالجة حالياً. لتسريع المعالجة، يرجى تحميل نسخة من إثبات الدفع:',
    AppStrings.invoice: 'فاتورة',

// File Operations
    AppStrings.permissionDenied: 'تم رفض الإذن',
    AppStrings.userCancelled: 'قام المستخدم بإلغاء اختيار الملف',
    AppStrings.fileSavedSuccess: 'تم حفظ الملف في وحدة التخزين المحلية',
    AppStrings.fileSaveError: 'خطأ في حفظ الملف:',
    AppStrings.storagePermissionTitle: 'مطلوب إذن التخزين',
    AppStrings.storagePermissionMessage:
        'يتطلب هذا التطبيق الوصول إلى وحدة التخزين الخارجية لجهازك لحفظ الفاتورة. يرجى منح الإذن للمتابعة.',

// Gift Cards
    AppStrings.selectGiftCardAmount: 'اختر مبلغ بطاقة الهدية',
    AppStrings.selectOrAddAmount: 'اختر أو أضف مبلغاً',
    AppStrings.amountMustBeLessThan: 'يجب أن يكون المبلغ أقل من 10000 درهم',
    AppStrings.invalidAmountEntered: 'تم إدخال مبلغ غير صالح',
    AppStrings.enterReceiptName: 'أدخل اسم المستلم *',
    AppStrings.enterReceiptEmail: 'أدخل بريد المستلم *',
    AppStrings.additionalNotes: 'ملاحظات إضافية',
    AppStrings.discount50: 'خصم 50%',
    AppStrings.searchDiscounts: 'ابحث عن الخصومات',

// Placeholder values
    AppStrings.actualPrice: 'السعر الفعلي',
    AppStrings.standardPrice: 'السعر القياسي',
    AppStrings.fiftyPercentOffPrice: 'سعر خصم 50%',

// VendorAppStrings (Arabic translations for vendor strings)

// Title Strings
    VendorAppStrings.titleGender: 'النوع',

// Hint Strings
    VendorAppStrings.hintEnterEmail: 'أدخل البريد الإلكتروني',
    VendorAppStrings.hintEnterFullName: 'أدخل الاسم الكامل',
    VendorAppStrings.hintSelectGender: 'اختر نوعك',

// Error Strings
    VendorAppStrings.errorEmailRequired: 'البريد الإلكتروني مطلوب',
    VendorAppStrings.errorValidEmail: 'أدخل بريدًا إلكترونيًا صالحًا',

// Common Strings
    VendorAppStrings.asterick: ' *',

// Navigation and Drawer
    VendorAppStrings.home: 'المنزل',
    VendorAppStrings.shop: 'المتجر',
    VendorAppStrings.dashboard: 'لوحة القيادة',
    VendorAppStrings.orderReturns: 'إرجاع الطلبات',
    VendorAppStrings.withdrawals: 'السحوبات',
    VendorAppStrings.revenues: 'الإيرادات',
    VendorAppStrings.settings: 'الإعدادات',
    VendorAppStrings.logoutFromVendor: 'تسجيل الخروج من البائع',

// Button Titles
    VendorAppStrings.saveAndContinue: 'حفظ ومتابعة',
    VendorAppStrings.previewAgreement: 'معاينة الاتفاقية',

// App Bar Titles

// Tab and Section Titles
    VendorAppStrings.packageProducts: 'منتجات الحزمة',
    VendorAppStrings.uploadImages: 'تحميل الصور',

    VendorAppStrings.packageProductsTab: 'منتجات الحزمة',
    VendorAppStrings.productOptions: 'خيارات المنتج',
    VendorAppStrings.searchEngineOptimization: 'تحسين محركات البحث',
    VendorAppStrings.relatedProducts: 'المنتجات ذات الصلة',
    VendorAppStrings.crossSellingProducts: 'منتجات البيع المتقاطع',
    VendorAppStrings.productVariations: 'تغيرات المنتج',
    VendorAppStrings.digitalAttachments: 'المرفقات الرقمية',
    VendorAppStrings.digitalAttachmentLinks: 'روابط المرفقات الرقمية',
    VendorAppStrings.attributes: 'الخصائص',
    VendorAppStrings.productFaqs: 'أسئلة متكررة عن المنتج',
    VendorAppStrings.recentOrders: 'الطلبات الأخيرة',
    VendorAppStrings.topSellingProducts: 'المنتجات الأكثر مبيعاً',
    VendorAppStrings.editSeoMeta: 'تعديل بيانات SEO',
    VendorAppStrings.index: 'فهرس',
    VendorAppStrings.noIndex: 'لا فهرس',
    VendorAppStrings.productOverviewShipping: 'نظرة عامة على المنتج (الشحن)',
    VendorAppStrings.editVariations: 'تعديل التغيرات',
    VendorAppStrings.autoGenerateSku: 'توليد SKU تلقائيًا؟',
    VendorAppStrings.productHasVariations: 'المنتج له تغيرات',
    VendorAppStrings.isDefault: 'افتراضي',
    VendorAppStrings.withStorehouseManagement: 'مع إدارة المستودع.',
    VendorAppStrings.logo: 'الشعار',
    VendorAppStrings.coverImage: 'صورة الغلاف',
    VendorAppStrings.priceField: 'حقل السعر',
    VendorAppStrings.typeField: 'حقل النوع',

// Settings Tab Titles
    VendorAppStrings.store: 'المتجر',
    VendorAppStrings.taxInfo: 'معلومات الضريبة',
    VendorAppStrings.payoutInfo: 'معلومات الدفع',

// Switch Titles
    VendorAppStrings.unlimitedCoupon: 'قسيمة غير محدودة؟',
    VendorAppStrings.displayCouponCodeAtCheckout: 'عرض رمز القسيمة في صفحة الدفع؟',
    VendorAppStrings.neverExpired: 'لا تنتهي أبدًا؟',
    VendorAppStrings.generateLicenseCodeAfterPurchase: 'توليد رمز الترخيص بعد شراء هذا المنتج؟',
    VendorAppStrings.required: 'مطلوب',
// Form Labels
    VendorAppStrings.bankName: 'اسم البنك',
    VendorAppStrings.ibanNumber: 'رقم الحساب المصرفي الدولي (IBAN)',
    VendorAppStrings.accountName: 'اسم الحساب',
    VendorAppStrings.accountNumber: 'رقم الحساب',
    VendorAppStrings.bankLetterPdf: 'خطاب البنك (pdf)',
    VendorAppStrings.password: 'كلمة المرور',
    VendorAppStrings.companyName: 'اسم الشركة',
    VendorAppStrings.companySlug: 'اسم الشركة المختصر',
    VendorAppStrings.companyMobileNumber: 'رقم هاتف الشركة المحمول',
    VendorAppStrings.uploadCompanyLogo: 'تحميل شعار الشركة',
    VendorAppStrings.companyCategoryType: 'نوع فئة الشركة',
    VendorAppStrings.companyEmail: 'بريد الشركة الإلكتروني',
    VendorAppStrings.phoneNumberLandline: 'رقم الهاتف (أرضي)',
    VendorAppStrings.mobileNumber: 'رقم الهاتف المحمول',
    VendorAppStrings.tradeLicenseNumber: 'رقم الرخصة التجارية',
    VendorAppStrings.uploadTradeLicensePdf: 'تحميل الرخصة التجارية (pdf)',
    VendorAppStrings.companyAddress: 'عنوان الشركة',
    VendorAppStrings.region: 'المنطقة',
    VendorAppStrings.emiratesIdNumber: 'رقم الهوية الإماراتية',
    VendorAppStrings.emiratesIdNumberExpiryDate: 'تاريخ انتهاء صلاحية رقم الهوية الإماراتية',
    VendorAppStrings.uploadEidPdf: 'تحميل الهوية الإماراتية (pdf)',
    VendorAppStrings.uploadPassportPdf: 'تحميل جواز السفر (pdf)',
    VendorAppStrings.poaMoaPdf: 'توكيل / مذكرة تفاهم (pdf)',
    VendorAppStrings.companyStamp: 'ختم الشركة (500*500)',
    VendorAppStrings.note: 'ملاحظة',
    VendorAppStrings.amount: 'المبلغ',
    VendorAppStrings.fee: 'الرسوم',
    VendorAppStrings.createCouponCode: 'إنشاء رمز قسيمة',
    VendorAppStrings.couponName: 'اسم القسيمة',
    VendorAppStrings.enterNumber: 'أدخل الرقم',
    VendorAppStrings.businessName: 'اسم العمل',
    VendorAppStrings.taxId: 'الرقم الضريبي',
    VendorAppStrings.shopUrl: 'رابط المتجر',
    VendorAppStrings.title: 'العنوان',
    VendorAppStrings.company: 'الشركة',
    VendorAppStrings.selectPaymentMethod: 'اختر طريقة الدفع',
    VendorAppStrings.bankCodeIfsc: 'رمز البنك/IFSC',
    VendorAppStrings.accountHolderName: 'اسم صاحب الحساب',
    VendorAppStrings.upiId: 'معرف UPI',
    VendorAppStrings.paypalId: 'معرف PayPal',
    VendorAppStrings.weightG: 'الوزن (جرام)',
    VendorAppStrings.lengthCm: 'الطول (سم)',
    VendorAppStrings.widthCm: 'العرض (سم)',
    VendorAppStrings.heightCm: 'الارتفاع (سم)',
    VendorAppStrings.sku: 'رمز المخزون (SKU)',
    VendorAppStrings.price: 'السعر',
    VendorAppStrings.salePrice: 'سعر البيع',
    VendorAppStrings.fromDate: 'من تاريخ',
    VendorAppStrings.toDate: 'إلى تاريخ',
    VendorAppStrings.costPerItem: 'التكلفة لكل قطعة',
    VendorAppStrings.barcodeIsbnUpcGtin: 'الباركود (ISBN, UPC, GTIN, إلخ.)',
    VendorAppStrings.quantity: 'الكمية',
    VendorAppStrings.question: 'السؤال',
    VendorAppStrings.answer: 'الإجابة',
    VendorAppStrings.seoKeywords: 'كلمات مفتاحية لتحسين محركات البحث',
    VendorAppStrings.permalink: 'الرابط الدائم',

// Form Hints
    VendorAppStrings.enterBankName: 'أدخل اسم البنك',
    VendorAppStrings.enterIbanNumber: 'أدخل رقم IBAN',
    VendorAppStrings.enterAccountName: 'أدخل اسم الحساب',
    VendorAppStrings.enterAccountNumber: 'أدخل رقم الحساب',
    VendorAppStrings.noFileChosen: 'لم يتم اختيار ملف',
    VendorAppStrings.enterCouponName: 'أدخل اسم القسيمة',
    VendorAppStrings.enterNumberOfCoupons: 'أدخل عدد القسائم',
    VendorAppStrings.selectCouponType: 'اختر نوع القسيمة',
    VendorAppStrings.selectBrand: 'اختر العلامة التجارية',
    VendorAppStrings.selectCategories: 'اختر الفئات',
    VendorAppStrings.selectProductCollection: 'اختر مجموعة المنتج',
    VendorAppStrings.selectLabels: 'اختر الملصقات',
    VendorAppStrings.selectTaxes: 'اختر الضرائب',
    VendorAppStrings.selectTags: 'اختر العلامات',
    VendorAppStrings.enterAmount: 'أدخل المبلغ',
    VendorAppStrings.enterFee: 'أدخل الرسوم',
    VendorAppStrings.enterDescription: 'أدخل الوصف',
    VendorAppStrings.addNote: 'أضف ملاحظة..',
    VendorAppStrings.selectShipmentStatus: 'اختر حالة الشحن',
    VendorAppStrings.enterShopUrl: 'أدخل رابط المتجر',
    VendorAppStrings.enterTitle: 'أدخل العنوان',
    VendorAppStrings.enterBusinessName: 'أدخل اسم العمل',
    VendorAppStrings.enterTaxId: 'أدخل الرقم الضريبي',
    VendorAppStrings.selectAttributeName: 'اختر اسم السمة',
    VendorAppStrings.selectAttributeValue: 'اختر قيمة السمة',
    VendorAppStrings.enterWeight: 'أدخل الوزن',
    VendorAppStrings.enterLength: 'أدخل الطول',
    VendorAppStrings.enterWidth: 'أدخل العرض',
    VendorAppStrings.enterHeight: 'أدخل الارتفاع',
    VendorAppStrings.selectAnOption: 'اختر خيارًا',
    VendorAppStrings.enterSeoKeywords: 'أدخل كلمات مفتاحية لتحسين محركات البحث',
    VendorAppStrings.enterSku: 'أدخل رمز المخزون (SKU)',
    VendorAppStrings.enterPrice: 'أدخل السعر',
    VendorAppStrings.enterSalePrice: 'أدخل سعر البيع',
    VendorAppStrings.yyyyMmDdHhMmSs: 'س س-ش ش-ي ي س س:د د:ث ث',
    VendorAppStrings.enterCostPerItem: 'أدخل التكلفة لكل قطعة',
    VendorAppStrings.enterBarcode: 'أدخل الباركود',
    VendorAppStrings.enterQuantity: 'أدخل الكمية',
    VendorAppStrings.enterNameField: 'أدخل الاسم',
    VendorAppStrings.enterLabel: 'ملصق',
    VendorAppStrings.enterYourPassword: 'أدخل كلمة مرورك',
    VendorAppStrings.enterYourCompanyName: 'أدخل اسم شركتك',
    VendorAppStrings.enterCompanySlug: 'أدخل اسم الشركة المختصر',
    VendorAppStrings.enterCompanyName: 'أدخل اسم الشركة',
    VendorAppStrings.pleaseSelectCcType: 'الرجاء اختيار نوع بطاقة الائتمان',
    VendorAppStrings.enterCompanyEmail: 'أدخل بريد الشركة الإلكتروني',
    VendorAppStrings.enterPhoneNumberField: 'أدخل رقم الهاتف',
    VendorAppStrings.enterMobileNumber: 'أدخل رقم الهاتف المحمول',
    VendorAppStrings.enterTradeLicenseNumber: 'أدخل رقم الرخصة التجارية',
    VendorAppStrings.enterCompanyAddress: 'أدخل عنوان الشركة',
    VendorAppStrings.ddMmYyyy: 'يوم-شهر-سنة',
    VendorAppStrings.yyyyMmDd: 'سنة-شهر-يوم',
    VendorAppStrings.pleaseSelectCountry: 'الرجاء اختيار الدولة',
    VendorAppStrings.pleaseSelectRegion: 'الرجاء اختيار المنطقة',
    VendorAppStrings.enterYourNumber: 'أدخل رقمك',
    VendorAppStrings.enterIdNumber: 'أدخل رقم الهوية',
    VendorAppStrings.noFileChosenAlt: 'لم يتم اختيار ملف',
    VendorAppStrings.enterBankNameField: 'أدخل اسم البنك',
    VendorAppStrings.enterBankCodeIfsc: 'أدخل رمز البنك/IFSC',
    VendorAppStrings.enterAccountHolderName: 'أدخل اسم صاحب الحساب',
    VendorAppStrings.enterUpiId: 'أدخل معرف UPI',
    VendorAppStrings.enterDescriptionFieldAlt: 'أدخل الوصف',
    VendorAppStrings.enterPaypalId: 'أدخل معرف PayPal',

// Dropdown Options
    VendorAppStrings.selectGender: 'اختر النوع',
    VendorAppStrings.selectRegion: 'اختر المنطقة',
    VendorAppStrings.selectCcType: 'اختر نوع بطاقة الائتمان',
    VendorAppStrings.amountFixed: 'المبلغ - ثابت',
    VendorAppStrings.discountPercentage: 'نسبة الخصم %',
    VendorAppStrings.freeShipping: 'شحن مجاني',
    VendorAppStrings.noResultsFound: 'لم يتم العثور على نتائج',

// Table Headers
    VendorAppStrings.id: 'المعرف',
    VendorAppStrings.product: 'المنتج',
    VendorAppStrings.amountHeader: 'المبلغ',
    VendorAppStrings.status: 'الحالة',
    VendorAppStrings.createdAt: 'تاريخ الإنشاء',

// Table Column Headers (from buildRow functions)
    VendorAppStrings.customer: 'العميل',
    VendorAppStrings.taxAmount: 'مبلغ الضريبة',
    VendorAppStrings.shippingAmount: 'مبلغ الشحن',
    VendorAppStrings.orderCode: 'رمز الطلب',
    VendorAppStrings.subAmount: 'المبلغ الفرعي',
    VendorAppStrings.type: 'النوع',
    VendorAppStrings.user: 'المستخدم',
    VendorAppStrings.comment: 'التعليق',
    VendorAppStrings.couponCode: 'رمز القسيمة',
    VendorAppStrings.startDate: 'تاريخ البدء',
    VendorAppStrings.endDate: 'تاريخ الانتهاء',
    VendorAppStrings.order: 'الطلب',
    VendorAppStrings.paypalIdHeader: 'معرف PayPal',
    VendorAppStrings.upiIdHeader: 'معرف UPI', // Empty State Messages
    VendorAppStrings.noImagesSelected: 'لم يتم اختيار صور.',
    VendorAppStrings.noAttachmentsSelected: 'لم يتم اختيار مرفقات.',
// Copyright
    VendorAppStrings.copyrightText: '© 2025 جميع الحقوق محفوظة لـ The Events.',
// Search Placeholder
    VendorAppStrings.searchPlaceholder: 'بحث..',
// Shipping
    VendorAppStrings.shippingFee: 'رسوم الشحن',
    VendorAppStrings.orderSuffix: 'طلب (طلبات)',
// Error Messages
    VendorAppStrings.error: 'خطأ: ',
    VendorAppStrings.downloadAgreement: 'تنزيل الاتفاقية',

// Screen Titles
    VendorAppStrings.bankDetails: 'تفاصيل البنك',
    VendorAppStrings.loginInformation: 'معلومات تسجيل الدخول',
    VendorAppStrings.businessOwnerInformation: 'معلومات مالك العمل',
    VendorAppStrings.emailVerificationPending: 'تحقق من البريد الإلكتروني معلق!',
    VendorAppStrings.pleaseVerifyEmail: 'يرجى التحقق من عنوان بريدك الإلكتروني! والضغط على التحقق.',
    VendorAppStrings.checkInboxSpam:
        'للتحقق من عنوان البريد الإلكتروني، يرجى التحقق من صندوق الوارد ومجلد الرسائل غير المرغوب فيها!',
    VendorAppStrings.accountVerified: 'تم التحقق من الحساب.',
    VendorAppStrings.emailVerificationPendingStatus: 'تحقق البريد الإلكتروني معلق.',
    VendorAppStrings.verify: 'تحقق',
    VendorAppStrings.resend: 'إعادة إرسال',

// Additional Screen Titles
    VendorAppStrings.authorizedSignatoryInformation: 'معلومات الموقع المفوض',
    VendorAppStrings.companyInformation: 'معلومات الشركة',
    VendorAppStrings.contractAgreement: 'اتفاقية العقد',
    VendorAppStrings.pleaseSignHere: 'يرجى التوقيع هنا *',
    VendorAppStrings.clear: 'مسح',
    VendorAppStrings.pleaseSignAgreement: 'يرجى توقيع هذه الاتفاقية',
    VendorAppStrings.youMustAgreeToProceed: 'يجب أن توافق للمتابعة',

// Additional Form Labels
    VendorAppStrings.tradeLicenseNumberExpiryDate: 'تاريخ انتهاء صلاحية الرخصة التجارية',
    VendorAppStrings.nocPoaIfApplicablePdf: 'شهادة عدم ممانعة/توكيل (إن كان مطبقاً - pdf)',
    VendorAppStrings.vatCertificateIfApplicablePdf: 'شهادة ضريبة القيمة المضافة (إن كانت مطبقة - pdf)',
// Additional Form Hints

    VendorAppStrings.nowAed: 'الآن درهم إماراتي',
    VendorAppStrings.youWillBeRedirectedToTelrTabby: 'سيتم توجيهك إلى Telr لإكمال الدفع',
    VendorAppStrings.paymentFailure: 'فشل في الدفع',
    VendorAppStrings.congratulations: 'تهانينا!',

// Company Information

// Form Hints

// Business and Authorization
    VendorAppStrings.areYouBusinessOwner: 'هل أنت صاحب العمل؟',
    VendorAppStrings.areYouAuthorizedSignatory: 'هل أنت الموقع المفوض؟',
  },
  // Russian
  'ru': {
    'walletApplicable': 'Кошелек применим',
    AppStrings.vendorSubscriptionOneYear: 'Подписка продавца (1 год)',
    AppStrings.vendorSubscriptionDescription: 'Это единовременная плата за регистрацию продавца.',
    'loginSuccessfully': 'Вход выполнен успешно',
    'paidAmount': 'Оплаченная сумма',
    'saveLower': 'Сохранить',
    'shippingUp': 'ДОСТАВКА',
    'statusUp': 'СТАТУС',
    'shippingMethodUp': 'СПОСОБ ДОСТАВКИ',
    'downloadInvoice': 'Скачать счет',
    'ordersLower': 'заказы',
    'updateShippingStatusFull': 'Обновить статус доставки',
    'weightUp': 'ВЕС (Г)',
    'editOrder': 'Редактировать заказ',
    'orderInformation': 'Информация о заказе',
    'vendorSubscriptionExpired': 'Ваша подписка закончилась',
    'youMustAddAddressFirstToContinue': 'Сначала добавьте адрес, чтобы продолжить',
    'noShippingMethodAvailable': 'Нет доступных способов доставки',
    'addingNewAttributesHelps':
        'Добавление новых атрибутов помогает продукту иметь больше вариантов, таких как размер или цвет.',
    'digitalLinks': 'Цифровые ссылки',
    'fileName': 'Имя файла',
    'externalLink': 'Внешняя ссылка',
    'size': 'Размер',
    'saved': 'Сохранено',
    'unsaved': 'Не сохранено',
    'authenticationFailed': 'Ошибка аутентификации. Пожалуйста, войдите снова.',
    'authenticationRequired': 'Требуется аутентификация',
    'requestCancelled': 'Запрос отменён',
    'failedToAddItemToCart': 'Не удалось добавить товар в корзину',
    'somethingWentWrong': 'Что-то пошло не так.',
    'anErrorOccurred': 'Произошла ошибка. Пожалуйста, попробуйте снова.',
    'failedToLoadCartData': 'Не удалось загрузить данные корзины.',
    'failedToLoadCheckoutData': 'Не удалось загрузить данные оформления заказа.',
    'anErrorOccurredDuringCheckout': 'Произошла ошибка при оформлении заказа.',
    'anErrorOccurredWhileUpdatingCart': 'Произошла ошибка при обновлении корзины.',
    'noOrdersFound': 'Заказы не найдены.',
    'failedToLoadAddresses': 'Не удалось загрузить адреса.',
    'addressDeleteSuccess': 'Адрес успешно удалён!',
    'failedToDeleteAddress': 'Не удалось удалить адрес.',
    'errorDeletingAddress': 'Произошла ошибка при удалении адреса.',
    'addressUpdateSuccess': 'Адрес успешно обновлён!',
    'invalidAddressData': 'Пожалуйста, введите правильные данные.',
    'failedToLoadData': 'Не удалось загрузить данные.',
    'pleaseLoginWishlist': 'Пожалуйста, войдите, чтобы управлять списком желаний.',
    'wishlistUpdateFailed': 'Не удалось обновить список желаний.',
    'unknownError': 'Произошла неизвестная ошибка.',
    'pleaseSelectShipmentStatus': 'Пожалуйста, выберите статус доставки',
    'failedToUpdateShipmentStatus': 'Не удалось обновить статус доставки',
    'resendEmail': 'Отправить письмо повторно',
    'paymentMethod': 'Способ оплаты',
    'paymentStatus': 'Статус оплаты',
    'shippingInformation': 'Информация о доставке',
    'updateShippingStatus': 'Обновить статус доставки',
    'errorFetchingProducts': 'Ошибка при загрузке товаров',
    'camera': 'Камера',
    'gallery': 'Галерея',
    // Validator messages (Russian placeholders - to be translated)
    'valEmailEmpty': 'Email cannot be empty',
    'valEmailInvalid': 'Enter a valid email address.',
    'valRequiredField': 'This field is required',
    'valUrlInvalid': 'Please enter a valid link',
    'valPhoneEmpty': 'Phone number cannot be empty',
    'valPhone9Digits': 'Phone number should be 9 digits long',
    'valPhoneDigitsOnly': 'Phone number should contain only numbers.',
    'valCompanyMobileRequired': 'Company mobile number is required',
    'valCompanyMobile9Digits': 'Company mobile number should be 9 digits long',
    'valCompanyMobileDigitsOnly': 'Company mobile number should contain only numbers.',
    'valLandlineRequired': 'Phone number (Landline) is required',
    'valLandline8Digits': 'Phone number (Landline) should be 8 digits long',
    'valLandlineDigitsOnly': 'Phone number (Landline) should contain only numbers.',
    'valPhoneRequired': 'Phone is required',
    'valGenderRequired': 'Please select gender',
    'valNameEmpty': 'Name cannot be empty',
    'valNameRequired': 'Name is required',
    'valNameMax25': 'Name cannot be more than 25 characters',
    'valBankNameRequired': 'Bank name is required',
    'valAccountNameRequired': 'Account name is required',
    'valAccountNumberRequired': 'Account number is required',
    'valRegionRequired': 'Please select region',
    'valCountryRequired': 'Please select country',
    'valEidRequired': 'Emirates ID number is required',
    'valEid15Digits': 'Emirates ID number must be 15 digits long.',
    'valCompanyCategoryRequired': 'Company category type is required',
    'valEidExpiryRequired': "EID number's expiry date is required",
    'valTradingNumberRequired': 'Trading number is required',
    'valTradingNumberLength': 'Trading License number must be between 10 and 15 characters long.',
    'valTradeLicenseExpiryRequired': "Trade License number's expiry date is required",
    'valFieldRequiredAlt': 'This Field cannot be empty.',
    'valCompanyAddressRequired': 'Company address is required',
    'valCompanyNameRequired': 'Company name is required',
    'valCompanyNameMax50': 'Company name cannot be more than 50 characters',
    'valCompanySlugRequired': 'Company slug is required',
    'valCompanySlugMax20': 'Company slug cannot be more than 20 characters',
    'valZipEmpty': 'Zip code cannot be empty',
    'valZip5Digits': 'Zip Code must be 5 digits long.',
    'valZipDigitsOnly': 'Zip Code should contain only numbers.',
    'valPasswordEmpty': 'Password cannot be empty.',
    'valPasswordMin9': 'Password should be at least 9 characters long.',
    'valPasswordPolicyFull':
        'Password must include at least one uppercase letter, one lowercase letter, one digit, and one special character.',
    'valVendorPasswordMin9': 'Password should be at least 9 characters long',
    'valVendorPasswordCaseReq': 'Password must contain at least one uppercase and one lowercase letter.',
    'valPaypalIdMax120': 'PayPal ID must not be greater than 120 characters.',
    'valPaypalEmailInvalid': 'Enter a valid PayPal email ID.',
    'valIFSCMax120': 'Bank code/IFSC must not be greater than 120 characters.',
    'valAccountNumberMax120': 'Account number must not be greater than 120 characters.',
    'valCouponsNumMin1': 'Number of coupons must be greater than or equal to 1',
    'valDiscountMin1': 'Discount must be greater than or equal to 1',
    'valPermalinkRequired': 'Product permanent link is required.',
    'valPermalinkUnique': 'Please generate unique permanent link.',
    'valStartDateAfterEnd': 'Start date cannot be after end date.',
    'valInvalidDateFormat': 'Invalid date format.',
    'valAddressRequired': 'Address field is required.',
    'valAddressMin5': 'Address must be at least 5 characters long.',
    'valAddressMax100': 'Address must not exceed 100 characters.',
    'valCityRequired': 'City field is required.',
    'valCityMin2': 'City name must be at least 2 characters long.',
    'valCityMax50': 'City name must not exceed 50 characters.',
    'valCityChars': 'City name can only contain letters, spaces, and hyphens.',
    'valIbanRequired': 'IBAN number is required',
    'valIbanLength': 'Invalid IBAN length',
    'valIbanFormat': 'Invalid IBAN format',
    'chooseDiscountPeriod': 'Выберите период скидки',
    'customerWontSeeThisPrice': 'Клиенты не увидят эту цену',
    'In stock': 'В наличии',
    'Out of stock': 'Нет в наличии',
    'On backorder': 'Предзаказ',

    'percentFromOriginalPrice': 'Процент от исходной цены',
    'allowCustomerCheckoutWhenOut of stock': 'Разрешить оформление заказа при отсутствии на складе',
    'stockStatus': 'Статус наличия',
    'priceField': 'Поле цены',
    'priceFieldDescription':
        'Введите сумму, на которую хотите снизить исходную цену. Пример: если исходная цена \$100, введите 20, чтобы снизить цену до \$80.',
    'typeField': 'Поле типа',
    'typeFieldDescription':
        'Выберите тип скидки: фиксированная (уменьшить на определенную сумму) или процентная (уменьшить на процент).',

    'searchProducts': 'Поиск товаров',
    'selectedProductAlreadyAdded': 'Выбранный товар уже добавлен в список',
    'pleaseSearchAndAddProducts': 'Пожалуйста, найдите и добавьте товары',
    'productOptionsDes': 'Пожалуйста, добавьте варианты продукта, нажав кнопку + в правом нижнем углу.',
    'pleaseSelectType': 'Пожалуйста, выберите тип',
    'selectSectionType': 'Выберите тип раздела',
    'addGlobalOptions': 'Добавить глобальные параметры',
    'addNewRow': 'Добавить новую строку',
    'selectFromExistingFAQs': 'Выбрать из существующих FAQ',
    'or': 'или',
    'add': 'Добавить',
    'addKeyword': 'Добавить ключевое слово',
    'addMoreAttribute': 'Добавить ещё атрибут',
    'productOverviewShipping': 'Обзор продукта (доставка)',
    'pendingProducts': 'Ожидающие продукты',
    'pendingPackages': 'Ожидающие пакеты',
    'request': 'Запрос',
    'publish': 'Опубликовать',
    'afterCancelAmountAndFeeWillBeRefundedBackInYourBalance':
        'После отмены сумма и комиссия будут возвращены на ваш баланс.',
    'doYouWantToCancelThisWithdrawal': 'Вы хотите отменить этот вывод средств?',
    'youWillReceiveMoneyThroughTheInformation': 'Вы получите деньги по следующей информации:',
    'payoutInfo': 'Информация о выплате',
    'noRecordFound': 'Записей не найдено',
    'sku': 'Артикул (SKU)',
    'code': 'Код',
    'amount': 'Сумма',
    'totalUsed': 'Всего использовано',
    'noGiftCardsFound': 'Подарочные карты не найдены',
    'createFirstGiftCard': 'Создайте свою первую подарочную карту',
    'createGiftCard': 'Создать подарочную карту',
    'becomeSeller': 'Стать продавцом',
    'yesBecomeSeller': 'Да, стать продавцом',
    'becomeSellerConfirmation': 'Вы уверены, что хотите стать продавцом?',
    'menu': 'Меню',
    'pleaseLogInToContinue': 'Пожалуйста, войдите, чтобы продолжить',
    'pleaseAddNewAddress': 'Пожалуйста, добавьте новый адрес',
    'pleaseSelectAnAddress': 'Пожалуйста, выберите адрес',
    'other': 'Другое',
    'Transaction Confirmations': 'Подтверждения транзакций',
    'Deposits, purchases, confirmations': 'Депозиты, покупки, подтверждения',

    'Achievement Alerts': 'Оповещения о достижениях',
    'Milestones, rewards, goals': 'Этапы, награды, цели',

    'Expiry Reminders': 'Напоминания о сроке действия',
    'Product expiry, renewal alerts': 'Истечение срока продукта, напоминания о продлении',

    'Promotional Messages': 'Рекламные сообщения',
    'Marketing updates, special offers': 'Маркетинговые обновления, специальные предложения',

    'Security Alerts': 'Оповещения безопасности',
    'Login alerts, security updates': 'Оповещения о входе, обновления безопасности',

    'System Updates': 'Системные обновления',
    'App updates, maintenance notices': 'Обновления приложения, уведомления о техническом обслуживании',

    'database': 'База данных',
    'sms': 'СМС',
    'broadcast': 'Трансляция',
    'mail': 'Почта',
    'Transaction': 'Транзакция',
    'Expiry Reminder': 'Напоминание о сроке действия',
    'Promotional': 'Рекламное',
    'Security': 'Безопасность',
    'System': 'Система',
    'Achievements': 'Достижения',
    'copyrightText': '© 2025 The Events. Все права защищены.',
    'enterYourCouponCode': 'Введите свой код купона',
    'redeemYourGiftCard': 'Использовать подарочную карту',
    'noFees': 'Без комиссий',
    AppStrings.markAsUnread: 'Отметить как непрочитанное',
    AppStrings.markAsRead: 'Отметить как прочитанное',
    AppStrings.noExpiringFundsFound: 'Истекающих фондов не найдено',
    AppStrings.notificationSettings: 'Настройки уведомлений',
    AppStrings.notificationTypes: 'Типы уведомлений',
    'fundExpiryAlert': 'Оповещение об истечении средств',
    'criticalActionRequired': 'Критично — требуется действие',
    'transactionsCount': 'Всего транзакций',
    '7Days': '7 дней',
    '30Days': '30 дней',
    '90Days': '90 дней',
    'currentMonth': 'Текущий месяц',
    'lastMonth': 'Прошлый месяц',
    'currentYear': 'Текущий год',
    'lastYear': 'Прошлый год',
    // History Screen translations
    'transactionHistory': 'История транзакций',
    'export': 'Экспорт',
    'searchTransactions': 'Поиск транзакций...',
    'allTypes': 'Все типы',
    'deposit': 'Депозит',
    'payment': 'Платеж',
    'reward': 'Награда',
    'refund': 'Возврат',
    'allMethods': 'Все методы',
    'creditCard': 'Кредитная карта',
    'giftCard': 'Подарочная карта',
    'bankTransfer': 'Банковский перевод',
    'thirtyDays': '30 дней',
    'sevenDays': '7 дней',
    'ninetyDays': '90 дней',
    'allTime': 'Все время',
    'reset': 'Сбросить',

    // Notifications Screen translations
    'notifications': 'Уведомления',
    'markAllRead': 'Отметить все как прочитанные',
    'noNotificationsYet': 'Пока нет уведомлений',
    'notificationsEmptyMessage': 'Здесь будут отображаться важные\nобновления и уведомления о кошельке.',
    AppStrings.wallet: 'Кошелек',
    AppStrings.digitalWallet: 'Цифровой кошелек',
    AppStrings.expirySoon: 'Скоро истекает',
    AppStrings.currentBalanceTitle: 'Текущий баланс',
    AppStrings.rewardsEarnedTitle: 'Заработанные бонусы',
    AppStrings.walletBalanceTitle: 'Баланс кошелька',
    AppStrings.lastUpdatedPrefix: 'Обновлено',
    AppStrings.addFunds: 'Пополнить',
    AppStrings.history: 'История',
    AppStrings.notifications: 'Уведомления',
    AppStrings.deposits: 'Пополнения',
    AppStrings.overview: 'Обзор',
    AppStrings.addFundsToWallet: 'Пополнить кошелек',
    AppStrings.selectDepositMethod: 'Выберите способ пополнения',
    AppStrings.couponCodeGiftCard: 'Код купона (подарочная карта)',
    AppStrings.amountAed: 'Сумма (AED)',
    AppStrings.instant: 'Мгновенно',
    AppStrings.giftCard: 'Подарочная карта',
    AppStrings.creditDebitCard: 'Кредитная/Дебетовая карта',
    AppStrings.visaMasterAccepted: 'Visa, MasterCard принимаются',
    AppStrings.processingFeeSuffix: 'комиссия',
    AppStrings.balanceLabel: 'Баланс: ',
    AppStrings.was: 'Было: ',
    AppStrings.applePay: 'Apple Pay',
    AppStrings.applePaySubtitle: 'Оплатите через ваш Apple Wallet',
    AppStrings.paymentCard: 'Карта',
    AppStrings.paymentTabby: 'Tabby',
    AppStrings.paymentTamara: 'Tamara',
    AppStrings.termsNote: 'Оформляя заказ, вы подтверждаете, что прочитали и согласны с условиями.',
    AppStrings.selectFromExistingAddresses: 'Выбрать из существующих адресов',
    AppStrings.orderSummary: 'Сводка заказа',
    AppStrings.subtotalUpper: 'Промежуточный итог',
    AppStrings.taxVat: 'Налог (НДС)',
    AppStrings.shipping: 'Доставка',
    AppStrings.couponDiscount: 'Скидка по купону',
    AppStrings.promotionDiscount: 'Промо-скидка',
    AppStrings.totalUpper: 'Итого',
    AppStrings.deliverTo: 'Доставить по адресу',
    AppStrings.noAddressSelected: 'Адрес не выбран',
    AppStrings.addressDetailsNotFound: 'Детали адреса не найдены',
    AppStrings.areaState: 'Район/Штат',
    AppStrings.phoneNumber: 'Номер телефона',
    AppStrings.grandTotal: 'Итого к оплате',
    AppStrings.payNowTitle: 'Оплатить сейчас',
    AppStrings.paymentCompletedSuccessfully: 'Оплата успешно завершена',
    AppStrings.applePayFailed: 'Оплата через Apple Pay не удалась. Попробуйте снова.',
    AppStrings.applePayErrorPrefix: 'Ошибка Apple Pay: ',
    AppStrings.shippingAddressDescription: 'С вас не будет списано до проверки заказа на следующей странице.',
    AppStrings.shippingAddress: 'Адрес доставки',
    AppStrings.selectShippingAddress: 'Выберите адрес доставки',
    'confirmPaymentCancel': 'Отменить платёж?',
    'paymentCancelWarning': 'Вы уверены, что хотите отменить платёж?',
    'continuePayment': 'Продолжить платёж',
    'cancelPayment': 'Отменить платёж',
    'noOrderDetailsFound': 'Детали заказа не найдены',
    'retry': 'Повторить',
    'orderPlacedSuccessfully': 'Заказ успешно оформлен! Проверьте свои заказы для получения деталей.',

    'payment_successful': 'Оплата прошла успешно',
    'payment_failed': 'Платеж не прошёл',
    'payment_cancelled': 'Платёж был отменён',
    'payment_link_error': 'Не удалось создать ссылку для оплаты',
    'vendorAccountUnderReview': 'Ваша учетная запись продавца находится на рассмотрении и ожидает одобрения.',
    'content': 'содержание',
    'pleaseSelectRequiredOptions': 'Пожалуйста, выберите все обязательные параметры',
    'dismiss': 'Закрыть',
    'Bazaar': 'Базар',
    'state': 'Штат',
    'stateIsRequired': 'Штат обязателен',
    'cityIsRequired': 'Город обязателен',
    'selectState': 'Выберите штат',
    'selectCity': 'Выберите город',
    'unknownState': 'Неизвестный штат',
// Core App Strings (Russian translations)
    AppStrings.darkMode: 'Тёмный режим',
    AppStrings.giftsByOccasion: 'Подарки по случаю',
    AppStrings.changeLanguage: 'Изменить язык',
    AppStrings.welcomeMessage: 'Добро пожаловать в наше приложение!',
    AppStrings.loginSignUp: 'Вход/Регистрация',
    AppStrings.cart: 'Корзина',
    AppStrings.changePassword: 'Изменить пароль',
    AppStrings.redeemCard: 'Использовать подарочную карту',
    AppStrings.joinAsSeller: 'Присоединиться как продавец',
    AppStrings.joinUsSeller: 'Присоединяйтесь к нам как продавец',
    AppStrings.privacyPolicy: 'Политика конфиденциальности',
    AppStrings.aboutUs: 'О нас',
    AppStrings.location: 'Местоположение',
    AppStrings.helpAndSupport: 'Помощь и поддержка',
    AppStrings.signUp: 'Регистрация',
    AppStrings.signIn: 'Войти',
    AppStrings.description: 'Описание',
    AppStrings.termsAndConditions: 'Условия и положения',
    AppStrings.buyAndRedeem: 'Купить и использовать',
    AppStrings.vendor: 'Панель продавца',
    AppStrings.vendorAgreement: 'Соглашение с продавцом',

// Descriptions (Russian)
    AppStrings.descriptionGiftCard:
        'Ищете идеальный подарок? Электронные подарочные карты Events здесь, чтобы сделать дарение легким. Наш электронный подарок — самый простой и удобный способ подарить своим близким именно то, что они хотят. Персонализируйте его искренним сообщением и оставьте остальное нам.',
    AppStrings.termsAndConditionsText:
        'Электронные подарочные карты можно обменять на кредит на нашем веб-сайте или в мобильном приложении. Электронная подарочная карта действительна в течение одного года с даты покупки. Нет дополнительных сборов или расходов на покупку наших электронных подарочных карт. Однако они не подлежат отмене и возврату после покупки. Пожалуйста, убедитесь в точности всей информации о получателе, поскольку мы не будем нести ответственность за возврат или замену неправильно направленного кода электронной подарочной карты.',
    AppStrings.redeemFirstLine: 'Выберите предварительно загруженную сумму или введите пользовательскую сумму',
    AppStrings.redeemSecondLine: 'Укажите имя и адрес электронной почты получателя',
    AppStrings.redeemThirdLine:
        'После транзакции получатель получит код электронной подарочной карты по электронной почте',
    AppStrings.redeemForthLine: 'Получатель может использовать сумму подарка, нажав на ссылку и введя код',
    AppStrings.redeemFifthLine: 'После использования сумма будет добавлена к балансу Events получателя',

// Cart & Shopping (Russian)
    AppStrings.myCart: 'Моя корзина',
    AppStrings.back: 'Назад',
    AppStrings.totalColon: 'Итого: ',
    AppStrings.profile: 'Профиль',
    AppStrings.shippingFees: '(стоимость доставки не включена)',
    AppStrings.proceedToCheckOut: 'Перейти к оформлению',
    AppStrings.addToCart: 'Добавить в корзину',
    AppStrings.subTotalColon: 'Промежуточный итог: ',
    AppStrings.taxColon: 'Налог: ',
    AppStrings.couponCodeText: 'Код купона',
    AppStrings.couponCodeAmount: 'Размер скидки по коду купона: ',
    AppStrings.shippingFee: 'Стоимость доставки',
    AppStrings.switchLanguage: 'Переключить язык',
    AppStrings.wishList: 'Список желаний',
    AppStrings.emptyWishList: 'Ваш список желаний пуст!',
    AppStrings.viewAll: 'Посмотреть все',
    AppStrings.quantity: 'Количество:',
    AppStrings.percentOff: '% скидка',
    AppStrings.off: 'скидка',
    AppStrings.gotoWishlist: 'Перейти к списку желаний',
    AppStrings.continueShopping: 'Продолжить покупки',
    AppStrings.cartIsEmpty: 'Корзина пуста \n Начните добавлять в свою корзину',
    AppStrings.aed: 'дирхам',

// About Us (Russian)
    AppStrings.aboutUsEvents:
        'В The Events мы верим, что каждый момент заслуживает стильного празднования. Основанная в Объединённых Арабских Эмиратах, наша платформа стала одной из ведущих онлайн-маркетплейсов в регионе для мероприятий, подарков и лайфстайл-услуг. Мы соединяем клиентов с широким выбором проверенных продавцов, брендов и поставщиков услуг — от цветов и изысканных подарков до роскошных товаров, впечатлений и необходимых аксессуаров для мероприятий — всё в одном цифровом пространстве. Наша миссия проста: сделать процесс поиска, бронирования и дарения максимально лёгким. Объединяя передовые технологии с глубоким пониманием местной культуры и международных трендов, мы обеспечиваем, чтобы каждый заказ доставлялся с заботой, качеством и надёжностью. В рамках нашей стратегии развития мы расширяемся за пределы ОАЭ с чёткой целью охватить весь регион Персидского залива, предлагая инновационный маркетплейс и премиальные услуги клиентам по всему Арабскому заливу. В The Events мы не просто маркетплейс — мы ваш партнёр в создании незабываемых моментов, которые останутся на всю жизнь.',
    AppStrings.ourMissionText:
        'В The Events наша миссия — упростить способ, которым люди празднуют и общаются. Мы стремимся предоставить удобный цифровой маркетплейс, объединяющий проверенных продавцов, премиальные товары и исключительные услуги — делая каждое событие проще в организации, приятнее в проведении и незабываемым в воспоминаниях.',
    AppStrings.ourVisionText:
        'Наша цель — стать ведущим онлайн-направлением для мероприятий, подарков и лайфстайл-услуг по всему региону Персидского залива. Объединяя инновации, надёжность и культурную аутентичность, мы стремимся вдохновлять миллионы клиентов и партнёров отмечать важные моменты жизни со вкусом.',
    AppStrings.ourMission: 'Наша миссия',
    AppStrings.ourVision: 'Наше видение',
    AppStrings.ourValues: 'Наши ценности',
    AppStrings.ourLocation: 'МЫ ОХВАТЫВАЕМ',
    AppStrings.vendorHeading:
        'Создайте аккаунт для отслеживания ваших клиентов и участников. После создания аккаунта мы отправим вам подтверждение по электронной почте.',
    AppStrings.vendorContactHeading:
        'Просмотрите соглашение и убедитесь в правильности всей информации. Затем продолжите оплату.',
    AppStrings.who: 'Кто',
    AppStrings.weAre: 'мы',
    AppStrings.our: 'Наша',
    AppStrings.mission: 'миссия',
    AppStrings.vision: 'видение',
    AppStrings.values: 'ценности',
    AppStrings.simplicity: 'Простота',
    AppStrings.innovation: 'Инновации',
    AppStrings.thoughtfulness: 'Внимательность',
    AppStrings.reliability: 'Надёжность',

// Vendor (Russian)
    AppStrings.agreementAccept: 'Я соглашаюсь с условиями и положениями',
    AppStrings.registrationDone: 'Регистрация завершена успешно! \n Теперь вы можете продолжить с оплатой.',
    AppStrings.paymentDone: 'Платёж прошёл успешно!',
    AppStrings.paymentThanks: 'Спасибо за завершение платежа.',

// Countries (Russian)
    AppStrings.unitedArabEmirates: 'Объединённые Арабские Эмираты',
    AppStrings.saudiArabia: 'Саудовская Аравия',
    AppStrings.bahrain: 'Бахрейн',
    AppStrings.kuwait: 'Кувейт',
    AppStrings.oman: 'Оман',
    AppStrings.qatar: 'Катар',

// Authentication (Russian)
    AppStrings.forgetPassword: 'Забыли пароль?',
    AppStrings.doNotHaveAccountYet: 'У вас ещё нет аккаунта?',
    AppStrings.createOneNow: 'Создать сейчас',
    AppStrings.send: 'Отправить',
    AppStrings.emailAddress: 'Адрес электронной почты',
    AppStrings.emailRequired: 'Требуется электронная почта',
    AppStrings.login: 'Войти',
    AppStrings.enterYourEmail: 'Введите вашу электронную почту',
    AppStrings.passRequired: 'Требуется пароль',
    AppStrings.enterYourPassword: 'Введите ваш пароль',
    AppStrings.continueo: 'Продолжить',
    AppStrings.getHelp: 'Получить помощь',
    AppStrings.haveTroubleLogging: 'Проблемы со входом?',
    AppStrings.fullName: 'Полное имя',
    AppStrings.confirmPassword: 'Подтвердить пароль',
    AppStrings.passwordValidation: 'Пароль должен содержать не менее 6 символов.',
    AppStrings.agreement: 'Соглашение',
    AppStrings.terms: 'Условия',
    AppStrings.searchEvents: 'Поиск событий',
    AppStrings.notification: 'Уведомления',
    AppStrings.confirmLogout: 'Подтвердить выход',
    AppStrings.confirmLogoutMessage: 'Вы уверены, что хотите выйти?',
    AppStrings.logout: 'Выйти',
// Profile & Account (Russian)
    AppStrings.address: 'Адрес',
    AppStrings.giftCards: 'Подарочные карты',
    AppStrings.reviews: 'Отзывы',
    AppStrings.orders: 'Заказы',
    AppStrings.myAccount: 'Мой аккаунт',
    AppStrings.enterCurrentPassword: 'Введите текущий пароль',
    AppStrings.currentPasswordCannotBeEmpty: 'Текущий пароль не может быть пустым',
    AppStrings.currentPassword: 'Текущий пароль',
    AppStrings.enterChangePassword: 'Введите новый пароль',
    AppStrings.enterReEnterPassword: 'Повторите новый пароль',
    AppStrings.reEnterPassword: 'Повторите пароль',
    AppStrings.update: 'Обновить',
    AppStrings.pleaseEnterFields: 'Пожалуйста, заполните все поля',
    AppStrings.noRecord: 'Нет записей',
    AppStrings.edit: 'Редактировать',
    AppStrings.phone: 'Телефон',
    AppStrings.email: 'Электронная почта',
    AppStrings.name: 'Имя',
    AppStrings.defaultAddress: 'Адрес по умолчанию',
    AppStrings.create: 'Создать',
    AppStrings.unknownCountry: 'Неизвестная страна',
    AppStrings.pleaseCheckFields: 'Пожалуйста, проверьте поля',
    AppStrings.addressSaved: 'Адрес сохранён',
    AppStrings.save: 'Сохранить',
    AppStrings.useDefaultAddress: 'Использовать этот адрес по умолчанию',
    AppStrings.cityCannotBeEmpty: 'Город не может быть пустым',
    AppStrings.city: 'Город',
    AppStrings.enterCity: 'Введите город',
    AppStrings.stateCannotBeEmpty: 'Штат не может быть пустым',
    AppStrings.enterState: 'Введите штат',
    AppStrings.pleaseSelectCountry: 'Пожалуйста, выберите страну',
    AppStrings.country: 'Страна',
    AppStrings.enterCountry: 'Введите страну',
    AppStrings.enterAddress: 'Введите адрес',
    AppStrings.enterEmailAddress: 'Введите адрес электронной почты',
    AppStrings.enterPhoneNumber: 'Введите номер телефона',
    AppStrings.enterName: 'Введите имя',
    AppStrings.enterYourName: 'Введите ваше имя',
    AppStrings.reviewed: 'Рассмотрено',
    AppStrings.waitingForReview: 'Ожидает рассмотрения',
    AppStrings.nameCannotBeEmpty: 'Имя не может быть пустым',
    AppStrings.phoneCannotBeEmpty: 'Номер телефона не может быть пустым',
    AppStrings.pleaseFillAllFields: 'Пожалуйста, заполните все поля',
    AppStrings.emailCannotBeEmpty: 'Электронная почта не может быть пустой',
    AppStrings.deleteMyAccount: 'Удалить мой аккаунт',
    AppStrings.deleteAccount: 'Удалить аккаунт',
    AppStrings.delete: 'Удалить',
    AppStrings.deleteAccountWarning:
        'Вы уверены, что хотите удалить свой аккаунт? Вы не сможете восстановить свои данные.',
    AppStrings.addressCannotBeEmpty: 'Адрес не может быть пустым',

// Reviews (Russian)
    AppStrings.noProductsAvailable: 'Нет продуктов для отзыва',
    AppStrings.uploadPhotos: 'Загрузить фотографии',
    AppStrings.uploadPhotosMessage: 'Максимум 5 фотографий',
    AppStrings.submitReview: 'Отправить отзыв',
    AppStrings.errorSubmittingReview: 'Ошибка при отправке отзыва',
    AppStrings.review: 'Отзыв',
    AppStrings.failedToAddPhotos: 'Не удалось добавить фотографии',
    AppStrings.maxFilesError: 'Максимальное количество файлов для выбора — 5.',
    AppStrings.noReviews: 'Пока нет отзывов',
    AppStrings.customerReviews: 'Отзывы клиентов',
    AppStrings.reviewSeller: 'Отзыв о продавце',
    AppStrings.reviewProduct: 'Отзыв о продукте',
    AppStrings.ratings: 'Рейтинги',
    AppStrings.star: 'звезда',
    AppStrings.stars: 'звёзды',

// Coupons (Russian)
    AppStrings.couponAppliedSuccess: 'Купон применён успешно!',
    AppStrings.couponRemovedSuccess: 'Купон удалён успешно!',
    AppStrings.couponInvalidOrExpired: 'Купон недействителен или истёк.',
    AppStrings.couponLabel: 'Введите код купона',
    AppStrings.couponHint: 'Код купона',

// Checkout & Payment (Russian)
    AppStrings.continueToPayment: 'Продолжить к оплате',
    AppStrings.currencyAED: 'дирхам ОАЭ',
    AppStrings.acceptTermsAndConditions: 'Я соглашаюсь с условиями и положениями',
    AppStrings.readOurTermsAndConditions: 'Прочитайте наши условия и положения',
    AppStrings.mustAcceptTerms: 'Вы должны согласиться с условиями и положениями, чтобы продолжить',
    AppStrings.confirmAndSubmitOrder: 'Подтвердить и отправить заказ',
    AppStrings.byClickingSubmit: 'Нажимая "Подтвердить и отправить заказ", вы соглашаетесь с',
    AppStrings.and: 'и',
    AppStrings.addNewAddress: 'Добавить новый адрес',
    AppStrings.saveAddress: 'Сохранить адрес',
    AppStrings.updateAddress: 'Обновить адрес',
    AppStrings.addNewAddressTitle: 'Добавить новый адрес',
    AppStrings.nameIsRequired: 'Имя обязательно',
    AppStrings.countryIsRequired: 'Страна обязательна',
    AppStrings.enterCorrectDetails: 'Пожалуйста, введите правильные данные',
    AppStrings.enterValidDetails: 'Пожалуйста, введите действительные данные',
    AppStrings.unknownAddress: 'Неизвестный адрес',
    AppStrings.unknownName: 'Неизвестное имя',
    AppStrings.unknownEmail: 'Неизвестная электронная почта',
    AppStrings.unknownPhone: 'Неизвестный телефон',
    AppStrings.unknownCity: 'Неизвестный город',
    AppStrings.unknownZipCode: 'Неизвестный почтовый индекс',
    AppStrings.choosePaymentMethod: 'Выберите способ оплаты',

    AppStrings.shippingMethod: 'Способ доставки',
    AppStrings.checkout: 'Оформление заказа',
    AppStrings.selectCountry: 'Выберите страну',
    AppStrings.payment: 'Оплата',
    AppStrings.failedToLoadPaymentMethods: 'Не удалось загрузить способы оплаты',
    AppStrings.noPaymentMethodsAvailable: 'Нет доступных способов оплаты',

// Filters & Sorting (Russian)
    AppStrings.sortOption: 'Параметры сортировки',
    AppStrings.filters: 'Фильтры',
    AppStrings.apply: 'Применить',
    AppStrings.filterOptions: 'Опции фильтра',
    AppStrings.brands: 'Бренды',
    AppStrings.categories: 'Категории',
    AppStrings.celebrities: 'Знаменитости',
    AppStrings.events: 'События',
    AppStrings.account: 'Аккаунт',
    AppStrings.tags: 'Теги',
    AppStrings.prices: 'Цены',
    AppStrings.colors: 'Цвета',
    AppStrings.sortByDefault: 'Сортировка по умолчанию',
    AppStrings.sortByOldest: 'Сортировка по старым',
    AppStrings.sortByNewest: 'Сортировка по новым',
    AppStrings.sortByNameAz: 'Сортировка по имени (А-Я)',
    AppStrings.sortByNameZa: 'Сортировка по имени (Я-А)',
    AppStrings.sortByPriceLowToHigh: 'Сортировка по цене (по возрастанию)',
    AppStrings.sortByPriceHighToLow: 'Сортировка по цене (по убыванию)',
    AppStrings.sortByRatingLowToHigh: 'Сортировка по рейтингу (по возрастанию)',
    AppStrings.sortByRatingHighToLow: 'Сортировка по рейтингу (по убыванию)',

// Products (Russian)
    AppStrings.noNotifications: 'Нет уведомлений',
    AppStrings.enterYourMessage: 'Введите ваше сообщение',
    AppStrings.selectLocation: 'Выберите местоположение',
    AppStrings.selectDate: 'Выберите дату',
    AppStrings.selectedDate: 'Выбранная дата:',
    AppStrings.messageCanNotBeEmpty: 'Сообщение не может быть пустым',
    AppStrings.pleaseSelectValidDate: 'Пожалуйста, выберите действительную дату',
    AppStrings.pleaseSelectLocation: 'Пожалуйста, выберите местоположение',
    AppStrings.failedToLoadImage: 'Не удалось загрузить изображение',
    AppStrings.wishlist: 'Список желаний',
    AppStrings.pleaseLogInToWishList: 'Пожалуйста, войдите, чтобы добавить товар в список желаний.',
    AppStrings.pleaseLogInToCart: 'Пожалуйста, войдите, чтобы добавить товар в корзину.',
    AppStrings.noAttributesAvailable: 'Нет доступных атрибутов',
    AppStrings.view: 'Посмотреть',
    AppStrings.sellingBy: 'Продаётся:',
    AppStrings.productDetails: 'Детали продукта',
    AppStrings.outOfStockStr: 'Нет в наличии',
    AppStrings.includingVAT: 'включая НДС',
    AppStrings.interestFreeInstallment: 'беспроцентный взнос',
    AppStrings.moreColors: 'Больше цветов',
    AppStrings.relatedProducts: 'Похожие товары',
    AppStrings.search: 'Поиск',
    AppStrings.products: 'Товары',
    AppStrings.packages: 'Пакеты',
    AppStrings.errorFetchingData: 'Ошибка получения данных',
    AppStrings.productDescription: 'Описание товара',
    AppStrings.noProductsFound: 'Товары не найдены',
    AppStrings.searchGifts: 'Поиск подарков',
    AppStrings.searchBrands: 'Поиск брендов',

// Common Actions (Russian)
    AppStrings.removeWishlistTitle: 'Удалить из списка желаний',
    AppStrings.removeWishlistMessage: 'Вы уверены, что хотите удалить этот товар из списка желаний?',
    AppStrings.cancel: 'Отмена',
    AppStrings.yes: 'Да',
    AppStrings.no: 'Нет',
    AppStrings.soldBy: 'Продаётся',
    AppStrings.loading: 'Загрузка...',
    AppStrings.error: 'Ошибка: ',
    AppStrings.confirmation: 'Подтверждение',
    AppStrings.cancelOrderConfirmationMessage: 'Вы уверены, что хотите продолжить?',
    AppStrings.allow: 'Разрешить',
    AppStrings.pending: 'В ожидании',
    AppStrings.completed: 'Завершён',
    AppStrings.purchased: 'Куплено',
    AppStrings.noDataAvailable: 'Нет доступных данных',
// Russian VendorAppStrings translations
    VendorAppStrings.titleGender: 'Пол',
    VendorAppStrings.hintEnterEmail: 'Введите email',
    VendorAppStrings.hintEnterFullName: 'Введите полное имя',
    VendorAppStrings.hintSelectGender: 'Выберите ваш пол',
    VendorAppStrings.errorEmailRequired: 'Email обязателен',
    VendorAppStrings.errorValidEmail: 'Введите действительный email',
    VendorAppStrings.asterick: ' *',
    VendorAppStrings.home: 'Главная',
    VendorAppStrings.shop: 'Магазин',
    VendorAppStrings.dashboard: 'Панель управления',
    VendorAppStrings.orderReturns: 'Возврат заказов',
    VendorAppStrings.withdrawals: 'Выводы средств',
    VendorAppStrings.revenues: 'Доходы',
    VendorAppStrings.settings: 'Настройки',
    VendorAppStrings.logoutFromVendor: 'Выйти из продавца',
    VendorAppStrings.saveAndContinue: 'Сохранить и продолжить',
    VendorAppStrings.previewAgreement: 'Просмотр соглашения',
    VendorAppStrings.packageProducts: 'Товары пакета',
    VendorAppStrings.uploadImages: 'Загрузить изображения',

    VendorAppStrings.store: 'Магазин',
    VendorAppStrings.taxInfo: 'Налоговая информация',
    VendorAppStrings.payoutInfo: 'Информация о выплатах',
    VendorAppStrings.bankName: 'Название банка',
    VendorAppStrings.downloadAgreement: 'Скачать соглашение',

// Screen Titles
    VendorAppStrings.bankDetails: 'Банковские реквизиты',
    VendorAppStrings.loginInformation: 'Информация для входа',
    VendorAppStrings.businessOwnerInformation: 'Информация о владельце бизнеса',
    VendorAppStrings.emailVerificationPending: 'Проверка электронной почты в ожидании!',
    VendorAppStrings.pleaseVerifyEmail: 'Пожалуйста, подтвердите ваш адрес электронной почты! и нажмите подтвердить.',
    VendorAppStrings.checkInboxSpam:
        'Для подтверждения адреса электронной почты, пожалуйста, проверьте ваш почтовый ящик и папку спама!',
    VendorAppStrings.accountVerified: 'Аккаунт подтверждён.',
    VendorAppStrings.emailVerificationPendingStatus: 'Подтверждение электронной почты в ожидании.',
    VendorAppStrings.verify: 'Подтвердить',
    VendorAppStrings.resend: 'Отправить повторно',

// Additional Screen Titles
    VendorAppStrings.authorizedSignatoryInformation: 'Информация об уполномоченном подписанте',
    VendorAppStrings.companyInformation: 'Информация о компании',
    VendorAppStrings.contractAgreement: 'Соглашение о контракте',
    VendorAppStrings.pleaseSignHere: 'Пожалуйста, подпишите здесь *',
    VendorAppStrings.clear: 'Очистить',
    VendorAppStrings.pleaseSignAgreement: 'Пожалуйста, подпишите это соглашение',
    VendorAppStrings.youMustAgreeToProceed: 'Вы должны согласиться, чтобы продолжить',

// Additional Form Labels
    VendorAppStrings.poaMoaPdf: 'Доверенность / Меморандум (pdf)',
    VendorAppStrings.uploadCompanyLogo: 'Загрузить логотип компании',
    VendorAppStrings.companyCategoryType: 'Тип категории компании',
    VendorAppStrings.phoneNumberLandline: 'Номер телефона (стационарный)',
    VendorAppStrings.tradeLicenseNumber: 'Номер торговой лицензии',
    VendorAppStrings.uploadTradeLicensePdf: 'Загрузить торговую лицензию (pdf)',
    VendorAppStrings.tradeLicenseNumberExpiryDate: 'Дата истечения торговой лицензии',
    VendorAppStrings.nocPoaIfApplicablePdf: 'Сертификат NOC/POA (если применимо - pdf)',
    VendorAppStrings.vatCertificateIfApplicablePdf: 'Сертификат НДС (если применимо - pdf)',
    VendorAppStrings.companyStamp: 'Печать компании (500*500)',

// Additional Form Hints
    VendorAppStrings.enterCompanyName: 'Введите название компании',
    VendorAppStrings.enterMobileNumber: 'Введите номер мобильного телефона',
    VendorAppStrings.enterTradeLicenseNumber: 'Введите номер торговой лицензии',
    VendorAppStrings.enterCompanyAddress: 'Введите адрес компании',
    VendorAppStrings.enterTradeLicenseExpiryDate: 'гггг-мм-дд',

// Additional Dropdown Options
    VendorAppStrings.selectCcType: 'Пожалуйста, выберите тип кредитной карты',
    VendorAppStrings.selectRegion: 'Пожалуйста, выберите регион',

    VendorAppStrings.nowAed: 'Теперь AED',
    VendorAppStrings.youWillBeRedirectedToTelrTabby: 'Вы будете перенаправлены в Telr для завершения оплаты',
    VendorAppStrings.paymentFailure: 'Ошибка оплаты',
    VendorAppStrings.congratulations: 'Поздравляем!',

// Company Information
    VendorAppStrings.companyName: 'Название компании',
    VendorAppStrings.companyEmail: 'Электронная почта компании',
    VendorAppStrings.mobileNumber: 'Мобильный номер',
    VendorAppStrings.companyAddress: 'Адрес компании',
    VendorAppStrings.region: 'Регион',

// Form Hints
    VendorAppStrings.noFileChosen: 'Файл не выбран',
    VendorAppStrings.enterCompanyEmail: 'Введите электронную почту компании',

// Business and Authorization
    VendorAppStrings.areYouBusinessOwner: 'Вы владелец бизнеса?',
    VendorAppStrings.areYouAuthorizedSignatory: 'Вы уполномоченный подписант?',

// Ensure presence of order and file/gift card keys (fallback to English constants)
    AppStrings.cancellationInfo: AppStrings.cancellationInfo,
    AppStrings.cancelWithinOneHour: AppStrings.cancelWithinOneHour,
    AppStrings.returnOrder: AppStrings.returnOrder,
    AppStrings.viewOrderUppercase: AppStrings.viewOrderUppercase,
    AppStrings.ordersCancelled: AppStrings.ordersCancelled,
    AppStrings.oneItemCancelled: AppStrings.oneItemCancelled,
    AppStrings.perfume: AppStrings.perfume,
    AppStrings.refundDetails: AppStrings.refundDetails,
    AppStrings.refundNotApplicable: AppStrings.refundNotApplicable,
    AppStrings.refund: AppStrings.refund,
    AppStrings.noOrders: AppStrings.noOrders,
    AppStrings.orderViewed: AppStrings.orderViewed,
    AppStrings.viewProduct: AppStrings.viewProduct,
    AppStrings.viewOrder: AppStrings.viewOrder,
    AppStrings.orderDetails: AppStrings.orderDetails,
    AppStrings.orderInfo: AppStrings.orderInfo,
    AppStrings.orderNumber: AppStrings.orderNumber,
    AppStrings.time: AppStrings.time,
    AppStrings.orderStatus: AppStrings.orderStatus,
    AppStrings.charges: AppStrings.charges,
    AppStrings.totalAmount: AppStrings.totalAmount,
    AppStrings.shippingInfo: AppStrings.shippingInfo,
    AppStrings.shippingStatus: AppStrings.shippingStatus,
    AppStrings.dateShipped: AppStrings.dateShipped,
    AppStrings.uploadPaymentProof: AppStrings.uploadPaymentProof,

    AppStrings.viewReceipt: AppStrings.viewReceipt,
    AppStrings.uploadedProofNote: AppStrings.uploadedProofNote,
    AppStrings.reUploadNote: AppStrings.reUploadNote,
    AppStrings.noProofUploaded: AppStrings.noProofUploaded,
    AppStrings.invoice: AppStrings.invoice,

// File Operations
    AppStrings.permissionDenied: AppStrings.permissionDenied,
    AppStrings.userCancelled: AppStrings.userCancelled,
    AppStrings.fileSavedSuccess: AppStrings.fileSavedSuccess,
    AppStrings.fileSaveError: AppStrings.fileSaveError,
    AppStrings.storagePermissionTitle: AppStrings.storagePermissionTitle,
    AppStrings.storagePermissionMessage: AppStrings.storagePermissionMessage,

// Gift Cards
    AppStrings.selectGiftCardAmount: AppStrings.selectGiftCardAmount,
    AppStrings.selectOrAddAmount: AppStrings.selectOrAddAmount,
    AppStrings.amountMustBeLessThan: AppStrings.amountMustBeLessThan,
    AppStrings.invalidAmountEntered: AppStrings.invalidAmountEntered,
    AppStrings.enterReceiptName: AppStrings.enterReceiptName,
    AppStrings.enterReceiptEmail: AppStrings.enterReceiptEmail,
    AppStrings.additionalNotes: AppStrings.additionalNotes,
    AppStrings.discount50: AppStrings.discount50,
    AppStrings.searchDiscounts: AppStrings.searchDiscounts,

// Placeholder values
    AppStrings.actualPrice: AppStrings.actualPrice,
    AppStrings.standardPrice: AppStrings.standardPrice,
    AppStrings.fiftyPercentOffPrice: AppStrings.fiftyPercentOffPrice,
  },
  // Chinese
  'zh': {
    'walletApplicable': '钱包可用',
    AppStrings.vendorSubscriptionOneYear: '供应商订阅（一年）',
    AppStrings.vendorSubscriptionDescription: '这是供应商注册的一次性费用。',
    'loginSuccessfully': '登录成功',
    'paidAmount': '已付金额',
    'saveLower': '保存',
    'shippingUp': '运输',
    'statusUp': '状态',
    'shippingMethodUp': '运输方式',
    'downloadInvoice': '下载发票',
    'ordersLower': '订单',
    'updateShippingStatusFull': '更新运输状态',
    'weightUp': '重量 (克)',
    'editOrder': '编辑订单',
    'orderInformation': '订单信息',
    'vendorSubscriptionExpired': '您的订阅已结束',
    'youMustAddAddressFirstToContinue': '您必须先添加地址才能继续',
    'noShippingMethodAvailable': '没有可用的运输方式',
    'addingNewAttributesHelps': '添加新属性可帮助产品拥有更多选项，例如尺寸或颜色。',
    'digitalLinks': '数字链接',
    'fileName': '文件名',
    'externalLink': '外部链接',
    'size': '大小',
    'saved': '已保存',
    'unsaved': '未保存',
    'authenticationFailed': '身份验证失败。请重新登录。',
    'authenticationRequired': '需要身份验证',
    'requestCancelled': '请求已取消',
    'failedToAddItemToCart': '添加商品到购物车失败',
    'somethingWentWrong': '出现了一些问题。',
    'anErrorOccurred': '发生错误。请再试一次。',
    'failedToLoadCartData': '加载购物车数据失败。',
    'failedToLoadCheckoutData': '加载结账数据失败。',
    'anErrorOccurredDuringCheckout': '结账时发生错误。',
    'anErrorOccurredWhileUpdatingCart': '更新购物车时发生错误。',
    'noOrdersFound': '未找到订单。',
    'failedToLoadAddresses': '加载地址失败。',
    'addressDeleteSuccess': '地址已成功删除！',
    'failedToDeleteAddress': '删除地址失败。',
    'errorDeletingAddress': '删除地址时出错。',
    'addressUpdateSuccess': '地址已成功更新！',
    'invalidAddressData': '请输入有效数据。',
    'failedToLoadData': '加载数据失败。',
    'pleaseLoginWishlist': '请登录以管理您的愿望清单。',
    'wishlistUpdateFailed': '更新愿望清单失败。',
    'unknownError': '发生未知错误。',
    'pleaseSelectShipmentStatus': '请选择运输状态',
    'failedToUpdateShipmentStatus': '更新运输状态失败',
    'resendEmail': '重新发送电子邮件',
    'paymentMethod': '付款方式',
    'paymentStatus': '付款状态',
    'shippingInformation': '运输信息',
    'updateShippingStatus': '更新运输状态',
    'errorFetchingProducts': '获取产品时出错',
    'camera': '相机',
    'gallery': '图库',
    // Validator messages (Chinese placeholders - to be translated)
    'valEmailEmpty': 'Email cannot be empty',
    'valEmailInvalid': 'Enter a valid email address.',
    'valRequiredField': 'This field is required',
    'valUrlInvalid': 'Please enter a valid link',
    'valPhoneEmpty': 'Phone number cannot be empty',
    'valPhone9Digits': 'Phone number should be 9 digits long',
    'valPhoneDigitsOnly': 'Phone number should contain only numbers.',
    'valCompanyMobileRequired': 'Company mobile number is required',
    'valCompanyMobile9Digits': 'Company mobile number should be 9 digits long',
    'valCompanyMobileDigitsOnly': 'Company mobile number should contain only numbers.',
    'valLandlineRequired': 'Phone number (Landline) is required',
    'valLandline8Digits': 'Phone number (Landline) should be 8 digits long',
    'valLandlineDigitsOnly': 'Phone number (Landline) should contain only numbers.',
    'valPhoneRequired': 'Phone is required',
    'valGenderRequired': 'Please select gender',
    'valNameEmpty': 'Name cannot be empty',
    'valNameRequired': 'Name is required',
    'valNameMax25': 'Name cannot be more than 25 characters',
    'valBankNameRequired': 'Bank name is required',
    'valAccountNameRequired': 'Account name is required',
    'valAccountNumberRequired': 'Account number is required',
    'valRegionRequired': 'Please select region',
    'valCountryRequired': 'Please select country',
    'valEidRequired': 'Emirates ID number is required',
    'valEid15Digits': 'Emirates ID number must be 15 digits long.',
    'valCompanyCategoryRequired': 'Company category type is required',
    'valEidExpiryRequired': "EID number's expiry date is required",
    'valTradingNumberRequired': 'Trading number is required',
    'valTradingNumberLength': 'Trading License number must be between 10 and 15 characters long.',
    'valTradeLicenseExpiryRequired': "Trade License number's expiry date is required",
    'valFieldRequiredAlt': 'This Field cannot be empty.',
    'valCompanyAddressRequired': 'Company address is required',
    'valCompanyNameRequired': 'Company name is required',
    'valCompanyNameMax50': 'Company name cannot be more than 50 characters',
    'valCompanySlugRequired': 'Company slug is required',
    'valCompanySlugMax20': 'Company slug cannot be more than 20 characters',
    'valZipEmpty': 'Zip code cannot be empty',
    'valZip5Digits': 'Zip Code must be 5 digits long.',
    'valZipDigitsOnly': 'Zip Code should contain only numbers.',
    'valPasswordEmpty': 'Password cannot be empty.',
    'valPasswordMin9': 'Password should be at least 9 characters long.',
    'valPasswordPolicyFull':
        'Password must include at least one uppercase letter, one lowercase letter, one digit, and one special character.',
    'valVendorPasswordMin9': 'Password should be at least 9 characters long',
    'valVendorPasswordCaseReq': 'Password must contain at least one uppercase and one lowercase letter.',
    'valPaypalIdMax120': 'PayPal ID must not be greater than 120 characters.',
    'valPaypalEmailInvalid': 'Enter a valid PayPal email ID.',
    'valIFSCMax120': 'Bank code/IFSC must not be greater than 120 characters.',
    'valAccountNumberMax120': 'Account number must not be greater than 120 characters.',
    'valCouponsNumMin1': 'Number of coupons must be greater than or equal to 1',
    'valDiscountMin1': 'Discount must be greater than or equal to 1',
    'valPermalinkRequired': 'Product permanent link is required.',
    'valPermalinkUnique': 'Please generate unique permanent link.',
    'valStartDateAfterEnd': 'Start date cannot be after end date.',
    'valInvalidDateFormat': 'Invalid date format.',
    'valAddressRequired': 'Address field is required.',
    'valAddressMin5': 'Address must be at least 5 characters long.',
    'valAddressMax100': 'Address must not exceed 100 characters.',
    'valCityRequired': 'City field is required.',
    'valCityMin2': 'City name must be at least 2 characters long.',
    'valCityMax50': 'City name must not exceed 50 characters.',
    'valCityChars': 'City name can only contain letters, spaces, and hyphens.',
    'valIbanRequired': 'IBAN number is required',
    'valIbanLength': 'Invalid IBAN length',
    'valIbanFormat': 'Invalid IBAN format',
    'chooseDiscountPeriod': '选择折扣期限',
    'customerWontSeeThisPrice': '客户不会看到此价格',
    'In stock': '有库存',
    'Out of stock': '缺货',
    'On backorder': '预购中',
    'percentFromOriginalPrice': '原价的百分比',
    'allowCustomerCheckoutWhenOut of stock': '库存不足时允许客户结账',
    'stockStatus': '库存状态',
    'priceField': '价格字段',
    'priceFieldDescription': '输入要从原价中减少的金额。例如：如果原价为100美元，输入20以将价格降低到80美元。',
    'typeField': '类型字段',
    'typeFieldDescription': '选择折扣类型：固定（减少固定金额）或百分比（按百分比减少）。',
    'searchProducts': '搜索产品',
    'selectedProductAlreadyAdded': '所选产品已添加到列表中',
    'pleaseSearchAndAddProducts': '请搜索并添加产品',
    'productOptionsDes': '请点击右下角的 + 按钮添加产品选项。',
    'pleaseSelectType': '请选择类型',
    'selectSectionType': '选择部分类型',
    'addGlobalOptions': '添加全局选项',
    'addNewRow': '添加新行',
    'selectFromExistingFAQs': '从现有常见问题中选择',
    'or': '或',
    'add': '添加',
    'addKeyword': '添加关键词',
    'addMoreAttribute': '添加更多属性',
    'productOverviewShipping': '产品概览（运输）',
    'pendingProducts': '待处理产品',
    'pendingPackages': '待处理套餐',
    'request': '请求',
    'publish': '发布',
    'afterCancelAmountAndFeeWillBeRefundedBackInYourBalance': '取消后，金额和费用将退还到您的余额中。',
    'doYouWantToCancelThisWithdrawal': '您想取消此次提现吗？',
    'youWillReceiveMoneyThroughTheInformation': '您将通过以下信息收到资金：',
    'payoutInfo': '付款信息',
    'noRecordFound': '未找到记录',
    'sku': 'SKU',
    'code': '代码',
    'amount': '金额',
    'totalUsed': '总使用量',
    'noGiftCardsFound': '未找到礼品卡',
    'createFirstGiftCard': '创建您的第一张礼品卡',
    'createGiftCard': '创建礼品卡',
    'becomeSeller': '成为卖家',
    'yesBecomeSeller': '是的，成为卖家',
    'becomeSellerConfirmation': '您确定要成为卖家吗？',
    'menu': '菜单',
    'pleaseLogInToContinue': '请登录以继续',
    'pleaseAddNewAddress': '请添加新地址',

    'pleaseSelectAnAddress': '请选择一个地址',
    'other': '其他',

    'Transaction Confirmations': '交易确认',
    'Deposits, purchases, confirmations': '存款、购买、确认',

    'Achievement Alerts': '成就提醒',
    'Milestones, rewards, goals': '里程碑、奖励、目标',

    'Expiry Reminders': '到期提醒',
    'Product expiry, renewal alerts': '产品到期、续订提醒',

    'Promotional Messages': '促销信息',
    'Marketing updates, special offers': '营销更新、特别优惠',

    'Security Alerts': '安全提醒',
    'Login alerts, security updates': '登录提醒、安全更新',

    'System Updates': '系统更新',
    'App updates, maintenance notices': '应用更新、维护通知',
    'database': '数据库',
    'sms': '短信',
    'broadcast': '广播',
    'mail': '邮件',
    'Transaction': '交易',
    'Expiry Reminder': '到期提醒',
    'Promotional': '促销',
    'Security': '安全',
    'System': '系统',
    'Achievements': '成就',
    'copyrightText': '© 2025 The Events。版权所有。',
    'enterYourCouponCode': '输入您的优惠券代码',
    'redeemYourGiftCard': '兑换您的礼品卡',
    'noFees': '无费用',
    AppStrings.markAsUnread: '标记为未读',
    AppStrings.markAsRead: '标记为已读',
    AppStrings.noExpiringFundsFound: '未找到即将到期的基金',
    AppStrings.notificationSettings: '通知设置',
    AppStrings.notificationTypes: '通知类型',
    'fundExpiryAlert': '资金到期提醒',
    'criticalActionRequired': '严重 - 需要操作',
    'transactionsCount': '交易总数',
    '7Days': '7天',
    '30Days': '30天',
    '90Days': '90天', 'currentMonth': '本月',
    'lastMonth': '上个月',
    'currentYear': '今年',
    'lastYear': '去年',
    // History Screen translations
    'transactionHistory': '交易历史',
    'export': '导出',
    'searchTransactions': '搜索交易...',
    'allTypes': '所有类型',
    'deposit': '存款',
    'payment': '付款',
    'reward': '奖励',
    'refund': '退款',
    'allMethods': '所有方式',
    'creditCard': '信用卡',
    'giftCard': '礼品卡',
    'bankTransfer': '银行转账',
    'thirtyDays': '30天',
    'sevenDays': '7天',
    'ninetyDays': '90天',
    'allTime': '所有时间',
    'reset': '重置',

    // Notifications Screen translations
    'notifications': '通知',
    'markAllRead': '全部标记为已读',
    'noNotificationsYet': '暂无通知',
    'notificationsEmptyMessage': '您将在这里看到有关钱包的\n重要更新和提醒。',
    AppStrings.wallet: '钱包',
    AppStrings.digitalWallet: '数字钱包',
    AppStrings.expirySoon: '即将到期',
    AppStrings.currentBalanceTitle: '当前余额',
    AppStrings.rewardsEarnedTitle: '获得的奖励',
    AppStrings.walletBalanceTitle: '钱包余额',
    AppStrings.lastUpdatedPrefix: '上次更新',
    AppStrings.addFunds: '添加资金',
    AppStrings.history: '历史记录',
    AppStrings.notifications: '通知',
    AppStrings.deposits: '充值',
    AppStrings.overview: '概览',
    AppStrings.addFundsToWallet: '向钱包添加资金',
    AppStrings.selectDepositMethod: '选择充值方式',
    AppStrings.couponCodeGiftCard: '优惠码（礼品卡）',
    AppStrings.amountAed: '金额（AED）',
    AppStrings.instant: '即时',
    AppStrings.giftCard: '礼品卡',
    AppStrings.creditDebitCard: '信用/借记卡',
    AppStrings.visaMasterAccepted: '支持 Visa、MasterCard',
    AppStrings.processingFeeSuffix: '处理费',
    AppStrings.balanceLabel: '余额：',
    AppStrings.was: '原价: ',
    AppStrings.applePay: '苹果支付',
    AppStrings.applePaySubtitle: '使用您的苹果钱包支付',
    AppStrings.paymentCard: '银行卡',
    AppStrings.paymentTabby: 'Tabby',
    AppStrings.paymentTamara: 'Tamara',
    AppStrings.termsNote: '下单即表示您已阅读并同意条款与条件。',
    AppStrings.selectFromExistingAddresses: '从现有地址中选择',
    AppStrings.orderSummary: '订单摘要',
    AppStrings.subtotalUpper: '小计',
    AppStrings.taxVat: '税费 (VAT)',
    AppStrings.shipping: '配送',
    AppStrings.couponDiscount: '优惠券折扣',
    AppStrings.promotionDiscount: '促销折扣',
    AppStrings.totalUpper: '总计',
    AppStrings.deliverTo: '送达至',
    AppStrings.noAddressSelected: '未选择地址',
    AppStrings.addressDetailsNotFound: '未找到地址详情',
    AppStrings.areaState: '区域/省份',
    AppStrings.phoneNumber: '电话号码',
    AppStrings.grandTotal: '订单总额',
    AppStrings.payNowTitle: '立即支付',
    AppStrings.paymentCompletedSuccessfully: '支付成功',
    AppStrings.applePayFailed: 'Apple Pay 支付失败，请重试。',
    AppStrings.applePayErrorPrefix: 'Apple Pay 支付错误：',
    AppStrings.shippingAddressDescription: '在下一页查看此订单之前不会扣款。',
    AppStrings.shippingAddress: '送货地址',
    AppStrings.selectShippingAddress: '选择送货地址',
    'confirmPaymentCancel': '取消支付？',
    'paymentCancelWarning': '您确定要取消支付吗？',
    'continuePayment': '继续支付',
    'cancelPayment': '取消支付',
    'noOrderDetailsFound': '未找到订单详情',
    'retry': '重试',
    'orderPlacedSuccessfully': '订单已成功提交！请查看您的订单以获取详细信息。',
    'payment_successful': '支付成功',
    'payment_failed': '支付失败',
    'payment_cancelled': '支付已取消',
    'payment_link_error': '生成支付链接失败',
    'vendorAccountUnderReview': '您的卖家账户正在审核中，等待批准。',
    'content': '内容',
    AppStrings.brands: '品牌',
    AppStrings.celebrities: '名人',
    AppStrings.categories: '分类',
    AppStrings.account: '账户',
    'pleaseSelectRequiredOptions': '请选择所有必需的选项',
    'dismiss': '关闭',
    'Bazaar': '集市',
    'state': '州',
    'stateIsRequired': '必须填写州',
    'cityIsRequired': '必须填写城市',
    'selectState': '选择州',
    'selectCity': '选择城市',
    'unknownState': '未知州',
// Core App Strings (Chinese translations)
    AppStrings.darkMode: '深色模式',
    AppStrings.giftsByOccasion: '按场合分类的礼品',
    AppStrings.changeLanguage: '更改语言',
    AppStrings.welcomeMessage: '欢迎来到我们的应用！',
    AppStrings.loginSignUp: '登录/注册',
    AppStrings.cart: '购物车',
    AppStrings.changePassword: '更改密码',
    AppStrings.redeemCard: '兑换礼品卡',
    AppStrings.joinAsSeller: '以卖家身份加入',
    AppStrings.joinUsSeller: '以卖家身份加入我们',
    AppStrings.privacyPolicy: '隐私政策',
    AppStrings.aboutUs: '关于我们',
    AppStrings.location: '位置',
    AppStrings.helpAndSupport: '帮助与支持',
    AppStrings.signUp: '注册',
    AppStrings.signIn: '登录',
    AppStrings.description: '描述',
    AppStrings.termsAndConditions: '条款和条件',
    AppStrings.buyAndRedeem: '购买和兑换',
    AppStrings.vendor: '卖家面板',
    AppStrings.vendorAgreement: '卖家协议',

// Descriptions (Chinese)
    AppStrings.descriptionGiftCard: '寻找完美的礼物？Events电子礼品卡让送礼变得简单。我们的电子礼品是给您的亲人他们真正想要的东西的最简单和最方便的方式。用真诚的信息个性化它，其余的交给我们。',
    AppStrings.termsAndConditionsText:
        '电子礼品卡可以在我们的网站或移动应用程序上兑换信用额度。电子礼品卡自购买之日起一年内有效。购买我们的电子礼品卡没有额外费用或成本。但是，一旦购买，它们不可取消且不可退款。请确保所有收件人信息的准确性，因为我们不会对错误发送的电子礼品卡代码的退款或替换负责。',
    AppStrings.redeemFirstLine: '选择预加载金额或输入自定义金额',
    AppStrings.redeemSecondLine: '提供收件人姓名和电子邮件地址',
    AppStrings.redeemThirdLine: '交易后，收件人将通过电子邮件收到电子礼品卡代码',
    AppStrings.redeemForthLine: '收件人可以通过点击链接并输入代码来兑换礼品金额',
    AppStrings.redeemFifthLine: '一旦兑换，金额将添加到收件人的Events余额中',
    AppStrings.countryIsRequired: '国家是必填项',

// Cart & Shopping (Chinese)
    AppStrings.myCart: '我的购物车',
    AppStrings.back: '返回',
    AppStrings.totalColon: '总计：',
    AppStrings.profile: '个人资料',
    AppStrings.shippingFees: '（不含运费）',
    AppStrings.proceedToCheckOut: '继续结账',
    AppStrings.addToCart: '加入购物车',
    AppStrings.subTotalColon: '小计：',
    AppStrings.taxColon: '税费：',
    AppStrings.couponCodeText: '优惠券代码',
    AppStrings.couponCodeAmount: '优惠券折扣金额：',
    AppStrings.shippingFee: '运费',
    AppStrings.switchLanguage: '切换语言',
    AppStrings.wishList: '愿望清单',
    AppStrings.emptyWishList: '您的愿望清单为空！',
    AppStrings.viewAll: '查看全部',
    AppStrings.quantity: '数量：',
    AppStrings.percentOff: '% 折扣',
    AppStrings.off: '折扣',
    AppStrings.gotoWishlist: '转到愿望清单',
    AppStrings.continueShopping: '继续购物',
    AppStrings.cartIsEmpty: '购物车为空\n开始添加到您的购物车',
    AppStrings.aed: '迪拉姆',

// About Us (Chinese)
    AppStrings.aboutUsEvents:
        '在 The Events，我们相信每一个时刻都值得以优雅的方式庆祝。我们的平台成立于阿拉伯联合酋长国，现已发展成为该地区领先的线上活动、礼品和生活方式体验市场之一。我们为客户连接值得信赖的卖家、品牌和服务提供商——从鲜花、美食礼品到奢侈品、体验和活动必需品——一切尽在一个无缝的数字空间中。我们的使命很简单：让发现、预订和送礼变得轻松无忧。通过将尖端技术与对本地文化和国际趋势的深刻理解相结合，我们确保每一份订单都能以关怀、品质和可靠性完成。作为我们发展愿景的一部分，我们正在从阿联酋扩展，明确目标是覆盖整个海湾合作委员会地区，将我们的创新型市场和优质服务带给整个阿拉伯湾的客户。在 The Events，我们不仅仅是一个市场——我们是您创造终生难忘时刻的伙伴。',
    AppStrings.ourMissionText:
        '在 The Events，我们的使命是简化人们庆祝和联结的方式。我们致力于打造一个无缝的数字化市场，将值得信赖的卖家、优质产品和卓越服务汇聚在一起——让每一个场合更容易筹划、更愉快地体验，并留下难以忘怀的回忆。',
    AppStrings.ourVisionText:
        '我们的愿景是成为覆盖整个海湾合作委员会地区的领先在线目的地，提供活动、礼品和生活方式体验。通过融合创新、可靠性和文化真实感，我们希望激励数百万客户和合作伙伴以时尚的方式庆祝生活中的重要时刻。',
    AppStrings.ourMission: '我们的使命',
    AppStrings.ourVision: '我们的愿景',
    AppStrings.ourValues: '我们的价值观',
    AppStrings.ourLocation: '我们正在覆盖',
    AppStrings.vendorHeading: '创建一个帐户来跟踪您的客户和贡献者。创建帐户后，我们将通过电子邮件向您发送确认。',
    AppStrings.vendorContactHeading: '查看协议并确保所有信息正确。然后继续付款。',
    AppStrings.who: '我们',
    AppStrings.weAre: '是谁',
    AppStrings.our: '我们的',
    AppStrings.mission: '使命',
    AppStrings.vision: '愿景',
    AppStrings.values: '价值观',
    AppStrings.simplicity: '简约',
    AppStrings.innovation: '创新',
    AppStrings.thoughtfulness: '周到',
    AppStrings.reliability: '可靠',

// Vendor (Chinese)
    AppStrings.agreementAccept: '我同意条款和条件',
    AppStrings.registrationDone: '注册成功完成！\n您现在可以继续付款。',
    AppStrings.paymentDone: '付款成功！',
    AppStrings.paymentThanks: '感谢您完成付款。',

// Countries (Chinese)
    AppStrings.unitedArabEmirates: '阿拉伯联合酋长国',
    AppStrings.saudiArabia: '沙特阿拉伯',
    AppStrings.bahrain: '巴林',
    AppStrings.kuwait: '科威特',
    AppStrings.oman: '阿曼',
    AppStrings.qatar: '卡塔尔',

// Authentication (Chinese)
    AppStrings.forgetPassword: '忘记密码？',
    AppStrings.doNotHaveAccountYet: '还没有帐户？',
    AppStrings.createOneNow: '立即创建',
    AppStrings.send: '发送',
    AppStrings.emailAddress: '电子邮件地址',
    AppStrings.emailRequired: '电子邮件必填',
    AppStrings.login: '登录',
    AppStrings.enterYourEmail: '输入您的电子邮件',
    AppStrings.passRequired: '密码必填',
    AppStrings.enterYourPassword: '输入您的密码',
    AppStrings.continueo: '继续',
    AppStrings.getHelp: '获取帮助',
    AppStrings.haveTroubleLogging: '登录遇到问题？',
    AppStrings.fullName: '全名',
    AppStrings.confirmPassword: '确认密码',
    AppStrings.passwordValidation: '密码必须至少6个字符。',
    AppStrings.agreement: '协议',
    AppStrings.terms: '条款',
    AppStrings.searchEvents: '搜索活动',
    AppStrings.notification: '通知',
    AppStrings.confirmLogout: '确认登出',
    AppStrings.confirmLogoutMessage: '您确定要登出吗？',
    AppStrings.logout: '登出',
// Profile & Account (Chinese)
    AppStrings.address: '地址',
    AppStrings.giftCards: '礼品卡',
    AppStrings.reviews: '评论',
    AppStrings.orders: '订单',
    AppStrings.myAccount: '我的账户',
    AppStrings.enterCurrentPassword: '输入当前密码',
    AppStrings.currentPasswordCannotBeEmpty: '当前密码不能为空',
    AppStrings.currentPassword: '当前密码',
    AppStrings.enterChangePassword: '输入新密码',
    AppStrings.enterReEnterPassword: '重新输入新密码',
    AppStrings.reEnterPassword: '重新输入密码',
    AppStrings.update: '更新',
    AppStrings.pleaseEnterFields: '请输入所有字段',
    AppStrings.noRecord: '无记录',
    AppStrings.edit: '编辑',
    AppStrings.phone: '电话',
    AppStrings.email: '电子邮件',
    AppStrings.name: '姓名',
    AppStrings.defaultAddress: '默认地址',
    AppStrings.create: '创建',
    AppStrings.unknownCountry: '未知国家',
    AppStrings.pleaseCheckFields: '请检查字段',
    AppStrings.addressSaved: '地址已保存',
    AppStrings.save: '保存',
    AppStrings.useDefaultAddress: '将此地址设为默认',
    AppStrings.cityCannotBeEmpty: '城市不能为空',
    AppStrings.city: '城市',
    AppStrings.enterCity: '输入城市',
    AppStrings.stateCannotBeEmpty: '州不能为空',
    AppStrings.enterState: '输入州',
    AppStrings.pleaseSelectCountry: '请选择国家',
    AppStrings.country: '国家',
    AppStrings.enterCountry: '输入国家',
    AppStrings.enterAddress: '输入地址',
    AppStrings.enterEmailAddress: '输入电子邮件地址',
    AppStrings.enterPhoneNumber: '输入电话号码',
    AppStrings.enterName: '输入姓名',
    AppStrings.enterYourName: '输入您的姓名',
    AppStrings.reviewed: '已审核',
    AppStrings.waitingForReview: '等待审核',
    AppStrings.nameCannotBeEmpty: '姓名不能为空',
    AppStrings.phoneCannotBeEmpty: '电话号码不能为空',
    AppStrings.pleaseFillAllFields: '请填写所有字段',
    AppStrings.emailCannotBeEmpty: '电子邮件不能为空',
    AppStrings.deleteMyAccount: '删除我的账户',
    AppStrings.deleteAccount: '删除账户',
    AppStrings.delete: '删除',
    AppStrings.deleteAccountWarning: '您确定要删除您的账户吗？您将无法恢复您的数据。',
    AppStrings.addressCannotBeEmpty: '地址不能为空',

// Reviews (Chinese)
    AppStrings.noProductsAvailable: '没有可用于评论的产品',
    AppStrings.uploadPhotos: '上传照片',
    AppStrings.uploadPhotosMessage: '最多5张照片',
    AppStrings.submitReview: '提交评论',
    AppStrings.errorSubmittingReview: '提交评论时出错',
    AppStrings.review: '评论',
    AppStrings.failedToAddPhotos: '添加照片失败',
    AppStrings.maxFilesError: '最多可选择5个文件。',
    AppStrings.noReviews: '暂无评论',
    AppStrings.customerReviews: '客户评论',
    AppStrings.reviewSeller: '评论卖家',
    AppStrings.reviewProduct: '评论产品',
    AppStrings.ratings: '评分',
    AppStrings.star: '星',
    AppStrings.stars: '星',

// Coupons (Chinese)
    AppStrings.couponAppliedSuccess: '优惠券应用成功！',
    AppStrings.couponRemovedSuccess: '优惠券移除成功！',
    AppStrings.couponInvalidOrExpired: '优惠券无效或已过期。',
    AppStrings.couponLabel: '输入优惠券代码',
    AppStrings.couponHint: '优惠券代码',

// Checkout & Payment (Chinese)
    AppStrings.continueToPayment: '继续付款',
    AppStrings.currencyAED: '阿联酋迪拉姆',
    AppStrings.acceptTermsAndConditions: '我接受条款和条件',
    AppStrings.readOurTermsAndConditions: '阅读我们的条款和条件',
    AppStrings.mustAcceptTerms: '您必须接受条款和条件才能继续',
    AppStrings.confirmAndSubmitOrder: '确认并提交订单',
    AppStrings.byClickingSubmit: '点击"确认并提交订单"，您同意',
    AppStrings.and: '和',

// Chinese VendorAppStrings translations
    VendorAppStrings.titleGender: '性别',
    VendorAppStrings.hintEnterEmail: '输入电子邮件',
    VendorAppStrings.hintEnterFullName: '输入全名',
    VendorAppStrings.hintSelectGender: '选择您的性别',
    VendorAppStrings.errorEmailRequired: '电子邮件必填',
    VendorAppStrings.errorValidEmail: '输入有效的电子邮件',
    VendorAppStrings.asterick: ' *',
    VendorAppStrings.home: '首页',
    VendorAppStrings.shop: '商店',
    VendorAppStrings.dashboard: '仪表板',
    VendorAppStrings.orderReturns: '订单退货',
    VendorAppStrings.withdrawals: '提款',
    VendorAppStrings.revenues: '收入',
    VendorAppStrings.settings: '设置',
    VendorAppStrings.logoutFromVendor: '从卖家登出',
    VendorAppStrings.saveAndContinue: '保存并继续',
    VendorAppStrings.previewAgreement: '预览协议',
    VendorAppStrings.downloadAgreement: '下载协议',

// Screen Titles
    VendorAppStrings.bankDetails: '银行详情',
    VendorAppStrings.loginInformation: '登录信息',
    VendorAppStrings.businessOwnerInformation: '企业主信息',
    VendorAppStrings.emailVerificationPending: '电子邮件验证待处理！',
    VendorAppStrings.pleaseVerifyEmail: '请验证您的电子邮件地址！然后点击验证。',
    VendorAppStrings.checkInboxSpam: '为了验证电子邮件地址，请检查您的收件箱和垃圾邮件文件夹！',
    VendorAppStrings.accountVerified: '账户已验证。',
    VendorAppStrings.emailVerificationPendingStatus: '电子邮件验证待处理。',
    VendorAppStrings.verify: '验证',
    VendorAppStrings.resend: '重新发送',

// Additional Screen Titles
    VendorAppStrings.authorizedSignatoryInformation: '授权签署人信息',
    VendorAppStrings.companyInformation: '公司信息',
    VendorAppStrings.contractAgreement: '合同协议',
    VendorAppStrings.pleaseSignHere: '请在此签名 *',
    VendorAppStrings.clear: '清除',
    VendorAppStrings.pleaseSignAgreement: '请签署此协议',
    VendorAppStrings.youMustAgreeToProceed: '您必须同意才能继续',

// Additional Form Labels
    VendorAppStrings.poaMoaPdf: '授权书/谅解备忘录 (pdf)',
    VendorAppStrings.uploadCompanyLogo: '上传公司标志',
    VendorAppStrings.companyCategoryType: '公司类别类型',
    VendorAppStrings.phoneNumberLandline: '电话号码 (固定电话)',
    VendorAppStrings.tradeLicenseNumber: '贸易许可证号码',
    VendorAppStrings.uploadTradeLicensePdf: '上传贸易许可证 (pdf)',
    VendorAppStrings.tradeLicenseNumberExpiryDate: '贸易许可证到期日期',
    VendorAppStrings.nocPoaIfApplicablePdf: 'NOC/POA证书 (如适用 - pdf)',
    VendorAppStrings.vatCertificateIfApplicablePdf: '增值税证书 (如适用 - pdf)',
    VendorAppStrings.companyStamp: '公司印章 (500*500)',

// Additional Form Hints
    VendorAppStrings.enterCompanyName: '输入公司名称',
    VendorAppStrings.enterMobileNumber: '输入手机号码',
    VendorAppStrings.enterTradeLicenseNumber: '输入贸易许可证号码',
    VendorAppStrings.enterCompanyAddress: '输入公司地址',
    VendorAppStrings.enterTradeLicenseExpiryDate: 'yyyy-MM-dd',

// Additional Dropdown Options
    VendorAppStrings.selectCcType: '请选择信用卡类型',
    VendorAppStrings.selectCountry: '请选择国家',
    VendorAppStrings.selectRegion: '请选择地区',

// Additional Error Messages

// Additional Button Titles
    VendorAppStrings.cancelButton: '取消',

// Payment and Subscription
    VendorAppStrings.payment: '付款',
    VendorAppStrings.nowAed: '现在 AED',
    VendorAppStrings.youWillBeRedirectedToTelrTabby: '您将被重定向到 Telr 完成付款',
    VendorAppStrings.paymentFailure: '付款失败',
    VendorAppStrings.congratulations: '恭喜！',

// Company Information
    VendorAppStrings.companyName: '公司名称',
    VendorAppStrings.companyEmail: '公司邮箱',
    VendorAppStrings.mobileNumber: '手机号码',
    VendorAppStrings.companyAddress: '公司地址',
    VendorAppStrings.region: '地区',

// Form Hints
    VendorAppStrings.noFileChosen: '未选择文件',
    VendorAppStrings.enterCompanyEmail: '输入公司邮箱',

// Business and Authorization
    VendorAppStrings.areYouBusinessOwner: '您是企业主吗？',
    VendorAppStrings.areYouAuthorizedSignatory: '您是授权签署人吗？',
// Ensure presence of order and file/gift card keys (fallback to English constants)
    AppStrings.cancellationInfo: AppStrings.cancellationInfo,
    AppStrings.cancelWithinOneHour: AppStrings.cancelWithinOneHour,
    AppStrings.returnOrder: AppStrings.returnOrder,
    AppStrings.viewOrderUppercase: AppStrings.viewOrderUppercase,
    AppStrings.ordersCancelled: AppStrings.ordersCancelled,
    AppStrings.oneItemCancelled: AppStrings.oneItemCancelled,
    AppStrings.perfume: AppStrings.perfume,
    AppStrings.refundDetails: AppStrings.refundDetails,
    AppStrings.refundNotApplicable: AppStrings.refundNotApplicable,
    AppStrings.refund: AppStrings.refund,
    AppStrings.noOrders: AppStrings.noOrders,
    AppStrings.orderViewed: AppStrings.orderViewed,
    AppStrings.viewProduct: AppStrings.viewProduct,
    AppStrings.viewOrder: AppStrings.viewOrder,
    AppStrings.orderDetails: AppStrings.orderDetails,
    AppStrings.orderInfo: AppStrings.orderInfo,
    AppStrings.orderNumber: AppStrings.orderNumber,
    AppStrings.time: AppStrings.time,
    AppStrings.orderStatus: AppStrings.orderStatus,
    AppStrings.charges: AppStrings.charges,
    AppStrings.totalAmount: AppStrings.totalAmount,
    AppStrings.shippingInfo: AppStrings.shippingInfo,
    AppStrings.shippingStatus: AppStrings.shippingStatus,
    AppStrings.dateShipped: AppStrings.dateShipped,
    AppStrings.uploadPaymentProof: AppStrings.uploadPaymentProof,

    AppStrings.viewReceipt: AppStrings.viewReceipt,
    AppStrings.uploadedProofNote: AppStrings.uploadedProofNote,
    AppStrings.reUploadNote: AppStrings.reUploadNote,
    AppStrings.noProofUploaded: AppStrings.noProofUploaded,
    AppStrings.invoice: AppStrings.invoice,

// File Operations
    AppStrings.permissionDenied: AppStrings.permissionDenied,
    AppStrings.userCancelled: AppStrings.userCancelled,
    AppStrings.fileSavedSuccess: AppStrings.fileSavedSuccess,
    AppStrings.fileSaveError: AppStrings.fileSaveError,
    AppStrings.storagePermissionTitle: AppStrings.storagePermissionTitle,
    AppStrings.storagePermissionMessage: AppStrings.storagePermissionMessage,

// Gift Cards
    AppStrings.selectGiftCardAmount: AppStrings.selectGiftCardAmount,
    AppStrings.selectOrAddAmount: AppStrings.selectOrAddAmount,
    AppStrings.amountMustBeLessThan: AppStrings.amountMustBeLessThan,
    AppStrings.invalidAmountEntered: AppStrings.invalidAmountEntered,
    AppStrings.enterReceiptName: AppStrings.enterReceiptName,
    AppStrings.enterReceiptEmail: AppStrings.enterReceiptEmail,
    AppStrings.additionalNotes: AppStrings.additionalNotes,
    AppStrings.discount50: AppStrings.discount50,
    AppStrings.searchDiscounts: AppStrings.searchDiscounts,

// Placeholder values
    AppStrings.actualPrice: AppStrings.actualPrice,
    AppStrings.standardPrice: AppStrings.standardPrice,
    AppStrings.fiftyPercentOffPrice: AppStrings.fiftyPercentOffPrice,
  },

// Hindi
  'hi': {
    'walletApplicable': 'वॉलेट लागू है',
    AppStrings.vendorSubscriptionOneYear: 'विक्रेता सदस्यता (1 वर्ष)',
    AppStrings.vendorSubscriptionDescription: 'यह विक्रेता पंजीकरण के लिए एक बार का शुल्क है।',
    'loginSuccessfully': 'सफलतापूर्वक लॉगिन हुआ',
    'paidAmount': 'भुगतान की गई राशि',
    'saveLower': 'सहेजें',
    'shippingUp': 'शिपिंग',
    'statusUp': 'स्थिति',
    'shippingMethodUp': 'शिपिंग विधि',
    'downloadInvoice': 'चालान डाउनलोड करें',
    'ordersLower': 'ऑर्डर',
    'updateShippingStatusFull': 'शिपिंग स्थिति अपडेट करें',
    'weightUp': 'वजन (ग्राम)',
    'editOrder': 'ऑर्डर संपादित करें',
    'orderInformation': 'ऑर्डर जानकारी',

    'vendorSubscriptionExpired': 'आपकी सदस्यता समाप्त हो गई है',
    'youMustAddAddressFirstToContinue': 'जारी रखने के लिए आपको पहले पता जोड़ना होगा',
    'noShippingMethodAvailable': 'कोई शिपिंग विधि उपलब्ध नहीं है',
    'addingNewAttributesHelps': 'नए गुण जोड़ने से उत्पाद को आकार या रंग जैसे कई विकल्प मिलते हैं।',
    'digitalLinks': 'डिजिटल लिंक',
    'fileName': 'फ़ाइल नाम',
    'externalLink': 'बाहरी लिंक',
    'size': 'आकार',
    'saved': 'सहेजा गया',
    'unsaved': 'असहेजा गया',
    'authenticationFailed': 'प्रमाणीकरण विफल रहा। कृपया फिर से लॉगिन करें।',
    'authenticationRequired': 'प्रमाणीकरण आवश्यक है',
    'requestCancelled': 'अनुरोध रद्द किया गया',
    'failedToAddItemToCart': 'कार्ट में आइटम जोड़ने में विफल रहा',
    'somethingWentWrong': 'कुछ गलत हो गया।',
    'anErrorOccurred': 'एक त्रुटि हुई। कृपया पुनः प्रयास करें।',
    'failedToLoadCartData': 'कार्ट डेटा लोड करने में विफल रहा।',
    'failedToLoadCheckoutData': 'चेकआउट डेटा लोड करने में विफल रहा।',
    'anErrorOccurredDuringCheckout': 'चेकआउट के दौरान एक त्रुटि हुई।',
    'anErrorOccurredWhileUpdatingCart': 'कार्ट अपडेट करते समय त्रुटि हुई।',
    'noOrdersFound': 'कोई ऑर्डर नहीं मिला।',
    'failedToLoadAddresses': 'पते लोड करने में विफल रहा।',
    'addressDeleteSuccess': 'पता सफलतापूर्वक हटाया गया!',
    'failedToDeleteAddress': 'पता हटाने में विफल रहा।',
    'errorDeletingAddress': 'पता हटाते समय त्रुटि हुई।',
    'addressUpdateSuccess': 'पता सफलतापूर्वक अपडेट किया गया!',
    'invalidAddressData': 'कृपया वैध डेटा दर्ज करें।',
    'failedToLoadData': 'डेटा लोड करने में विफल रहा।',
    'pleaseLoginWishlist': 'अपनी विशलिस्ट प्रबंधित करने के लिए कृपया लॉगिन करें।',
    'wishlistUpdateFailed': 'विशलिस्ट अपडेट करने में विफल रहा।',
    'unknownError': 'अज्ञात त्रुटि हुई।',
    'pleaseSelectShipmentStatus': 'कृपया शिपमेंट स्थिति चुनें',
    'failedToUpdateShipmentStatus': 'शिपमेंट स्थिति अपडेट करने में विफल',
    'resendEmail': 'ईमेल फिर से भेजें',
    'paymentMethod': 'भुगतान विधि',
    'paymentStatus': 'भुगतान स्थिति',
    'shippingInformation': 'शिपिंग जानकारी',
    'updateShippingStatus': 'शिपमेंट स्थिति अपडेट करें',
    'errorFetchingProducts': 'उत्पाद प्राप्त करने में त्रुटि',
    'camera': 'कैमरा',
    'gallery': 'गैलरी',
    // Validator messages (Hindi placeholders - to be translated)
    'valEmailEmpty': 'Email cannot be empty',
    'valEmailInvalid': 'Enter a valid email address.',
    'valRequiredField': 'This field is required',
    'valUrlInvalid': 'Please enter a valid link',
    'valPhoneEmpty': 'Phone number cannot be empty',
    'valPhone9Digits': 'Phone number should be 9 digits long',
    'valPhoneDigitsOnly': 'Phone number should contain only numbers.',
    'valCompanyMobileRequired': 'Company mobile number is required',
    'valCompanyMobile9Digits': 'Company mobile number should be 9 digits long',
    'valCompanyMobileDigitsOnly': 'Company mobile number should contain only numbers.',
    'valLandlineRequired': 'Phone number (Landline) is required',
    'valLandline8Digits': 'Phone number (Landline) should be 8 digits long',
    'valLandlineDigitsOnly': 'Phone number (Landline) should contain only numbers.',
    'valPhoneRequired': 'Phone is required',
    'valGenderRequired': 'Please select gender',
    'valNameEmpty': 'Name cannot be empty',
    'valNameRequired': 'Name is required',
    'valNameMax25': 'Name cannot be more than 25 characters',
    'valBankNameRequired': 'Bank name is required',
    'valAccountNameRequired': 'Account name is required',
    'valAccountNumberRequired': 'Account number is required',
    'valRegionRequired': 'Please select region',
    'valCountryRequired': 'Please select country',
    'valEidRequired': 'Emirates ID number is required',
    'valEid15Digits': 'Emirates ID number must be 15 digits long.',
    'valCompanyCategoryRequired': 'Company category type is required',
    'valEidExpiryRequired': "EID number's expiry date is required",
    'valTradingNumberRequired': 'Trading number is required',
    'valTradingNumberLength': 'Trading License number must be between 10 and 15 characters long.',
    'valTradeLicenseExpiryRequired': "Trade License number's expiry date is required",
    'valFieldRequiredAlt': 'This Field cannot be empty.',
    'valCompanyAddressRequired': 'Company address is required',
    'valCompanyNameRequired': 'Company name is required',
    'valCompanyNameMax50': 'Company name cannot be more than 50 characters',
    'valCompanySlugRequired': 'Company slug is required',
    'valCompanySlugMax20': 'Company slug cannot be more than 20 characters',
    'valZipEmpty': 'Zip code cannot be empty',
    'valZip5Digits': 'Zip Code must be 5 digits long.',
    'valZipDigitsOnly': 'Zip Code should contain only numbers.',
    'valPasswordEmpty': 'Password cannot be empty.',
    'valPasswordMin9': 'Password should be at least 9 characters long.',
    'valPasswordPolicyFull':
        'Password must include at least one uppercase letter, one lowercase letter, one digit, and one special character.',
    'valVendorPasswordMin9': 'Password should be at least 9 characters long',
    'valVendorPasswordCaseReq': 'Password must contain at least one uppercase and one lowercase letter.',
    'valPaypalIdMax120': 'PayPal ID must not be greater than 120 characters.',
    'valPaypalEmailInvalid': 'Enter a valid PayPal email ID.',
    'valIFSCMax120': 'Bank code/IFSC must not be greater than 120 characters.',
    'valAccountNumberMax120': 'Account number must not be greater than 120 characters.',
    'valCouponsNumMin1': 'Number of coupons must be greater than or equal to 1',
    'valDiscountMin1': 'Discount must be greater than or equal to 1',
    'valPermalinkRequired': 'Product permanent link is required.',
    'valPermalinkUnique': 'Please generate unique permanent link.',
    'valStartDateAfterEnd': 'Start date cannot be after end date.',
    'valInvalidDateFormat': 'Invalid date format.',
    'valAddressRequired': 'Address field is required.',
    'valAddressMin5': 'Address must be at least 5 characters long.',
    'valAddressMax100': 'Address must not exceed 100 characters.',
    'valCityRequired': 'City field is required.',
    'valCityMin2': 'City name must be at least 2 characters long.',
    'valCityMax50': 'City name must not exceed 50 characters.',
    'valCityChars': 'City name can only contain letters, spaces, and hyphens.',
    'valIbanRequired': 'IBAN number is required',
    'valIbanLength': 'Invalid IBAN length',
    'valIbanFormat': 'Invalid IBAN format',
    'chooseDiscountPeriod': 'छूट की अवधि चुनें',
    'customerWontSeeThisPrice': 'ग्राहक इस कीमत को नहीं देखेंगे',
    'In stock': 'स्टॉक में उपलब्ध',
    'Out of stock': 'स्टॉक से बाहर',
    'On backorder': 'बैकऑर्डर पर',
    'percentFromOriginalPrice': 'मूल कीमत से प्रतिशत',
    'allowCustomerCheckoutWhenOut of stock': 'स्टॉक खत्म होने पर ग्राहक को चेकआउट की अनुमति दें',
    'stockStatus': 'स्टॉक की स्थिति',
    'priceField': 'मूल्य फ़ील्ड',
    'priceFieldDescription':
        'मूल मूल्य से घटाने के लिए राशि दर्ज करें। उदाहरण: यदि मूल मूल्य \$100 है, तो \$80 तक घटाने के लिए 20 दर्ज करें।',
    'typeField': 'प्रकार फ़ील्ड',
    'typeFieldDescription':
        'छूट का प्रकार चुनें: स्थिर (एक निश्चित राशि घटाएं) या प्रतिशत (प्रतिशत के हिसाब से घटाएं)।',

    'searchProducts': 'उत्पाद खोजें',
    'selectedProductAlreadyAdded': 'चयनित उत्पाद पहले से सूची में जोड़ा गया है',
    'pleaseSearchAndAddProducts': 'कृपया खोजें और उत्पाद जोड़ें',
    'productOptionsDes': 'कृपया नीचे दाईं ओर + बटन पर टैप करके उत्पाद विकल्प जोड़ें।',
    'pleaseSelectType': 'कृपया प्रकार चुनें',
    'selectSectionType': 'सेक्शन प्रकार चुनें',
    'addGlobalOptions': 'ग्लोबल विकल्प जोड़ें',
    'addNewRow': 'नई पंक्ति जोड़ें',
    'selectFromExistingFAQs': 'मौजूदा FAQs से चुनें',
    'or': 'या',
    'add': 'जोड़ें',
    'addKeyword': 'कीवर्ड जोड़ें',
    'addMoreAttribute': 'और विशेषता जोड़ें',
    'productOverviewShipping': 'उत्पाद का अवलोकन (शिपिंग)',
    'pendingProducts': 'लंबित उत्पाद',
    'pendingPackages': 'लंबित पैकेज',
    'request': 'अनुरोध',
    'publish': 'प्रकाशित करें',
    'afterCancelAmountAndFeeWillBeRefundedBackInYourBalance':
        'रद्द करने के बाद राशि और शुल्क आपके बैलेंस में वापस कर दिए जाएंगे।',
    'doYouWantToCancelThisWithdrawal': 'क्या आप इस निकासी को रद्द करना चाहते हैं?',
    'youWillReceiveMoneyThroughTheInformation': 'आपको निम्न जानकारी के माध्यम से पैसे प्राप्त होंगे:',
    'payoutInfo': 'भुगतान जानकारी',

    'noRecordFound': 'कोई रिकॉर्ड नहीं मिला',
    'sku': 'एसकेयू',
    'code': 'कोड',
    'amount': 'राशि',
    'totalUsed': 'कुल उपयोग',
    'noGiftCardsFound': 'कोई गिफ्ट कार्ड नहीं मिला',
    'createFirstGiftCard': 'अपना पहला गिफ्ट कार्ड बनाएं',
    'createGiftCard': 'गिफ्ट कार्ड बनाएं',
    'becomeSeller': 'विक्रेता बनें',
    'yesBecomeSeller': 'हाँ, विक्रेता बनें',
    'becomeSellerConfirmation': 'क्या आप सुनिश्चित हैं कि आप विक्रेता बनना चाहते हैं?',
    'menu': 'मेन्यू',
    'pleaseLogInToContinue': 'कृपया जारी रखने के लिए लॉगिन करें',

    'pleaseAddNewAddress': 'कृपया एक नया पता जोड़ें',
    'pleaseSelectAnAddress': 'कृपया एक पता चुनें',
    'other': 'अन्य',
    'Transaction Confirmations': 'लेन-देन पुष्टिकरण',
    'Deposits, purchases, confirmations': 'जमा, खरीद, पुष्टिकरण',

    'Achievement Alerts': 'उपलब्धि अलर्ट',
    'Milestones, rewards, goals': 'मील के पत्थर, इनाम, लक्ष्य',

    'Expiry Reminders': 'समाप्ति अनुस्मारक',
    'Product expiry, renewal alerts': 'उत्पाद समाप्ति, नवीनीकरण अलर्ट',

    'Promotional Messages': 'प्रचार संदेश',
    'Marketing updates, special offers': 'मार्केटिंग अपडेट, विशेष ऑफ़र',

    'Security Alerts': 'सुरक्षा अलर्ट',
    'Login alerts, security updates': 'लॉगिन अलर्ट, सुरक्षा अपडेट',

    'System Updates': 'सिस्टम अपडेट',
    'App updates, maintenance notices': 'ऐप अपडेट, रखरखाव नोटिस',

    'database': 'डेटाबेस',
    'sms': 'एसएमएस',
    'broadcast': 'प्रसारण',
    'mail': 'मेल',
    'Transaction': 'लेन-देन',
    'Expiry Reminder': 'समाप्ति अनुस्मारक',
    'Promotional': 'प्रचार',
    'Security': 'सुरक्षा',
    'System': 'प्रणाली',
    'Achievements': 'उपलब्धियां',
    'copyrightText': '© 2025 द इवेंट्स। सर्वाधिकार सुरक्षित।',
    'enterYourCouponCode': 'अपना कूपन कोड दर्ज करें',
    'redeemYourGiftCard': 'अपना गिफ्ट कार्ड रिडीम करें',
    'noFees': 'कोई शुल्क नहीं',
    AppStrings.markAsUnread: 'अपठित चिह्नित करें',
    AppStrings.markAsRead: 'पढ़ा हुआ चिह्नित करें',
    AppStrings.noExpiringFundsFound: 'कोई समाप्त होने वाले फंड नहीं मिले',
    AppStrings.notificationSettings: 'सूचना सेटिंग्स',
    AppStrings.notificationTypes: 'सूचना प्रकार',
    'fundExpiryAlert': 'फंड समाप्ति अलर्ट',
    'criticalActionRequired': 'गंभीर - कार्रवाई आवश्यक',
    'transactionsCount': 'कुल लेन-देन',
    '7Days': '7 दिन',
    '30Days': '30 दिन',
    '90Days': '90 दिन', 'currentMonth': 'वर्तमान माह',
    'lastMonth': 'पिछला माह',
    'currentYear': 'वर्तमान वर्ष',
    'lastYear': 'पिछला वर्ष',
    // History Screen translations
    'transactionHistory': 'लेन-देन इतिहास',
    'export': 'निर्यात',
    'searchTransactions': 'लेन-देन खोजें...',
    'allTypes': 'सभी प्रकार',
    'deposit': 'जमा',
    'payment': 'भुगतान',
    'reward': 'पुरस्कार',
    'refund': 'वापसी',
    'allMethods': 'सभी तरीके',
    'creditCard': 'क्रेडिट कार्ड',
    'giftCard': 'उपहार कार्ड',
    'bankTransfer': 'बैंक ट्रांसफर',
    'thirtyDays': '30 दिन',
    'sevenDays': '7 दिन',
    'ninetyDays': '90 दिन',
    'allTime': 'सभी समय',
    'reset': 'रीसेट',

    // Notifications Screen translations
    'notifications': 'सूचनाएं',
    'markAllRead': 'सभी को पढ़ा गया चिह्नित करें',
    'noNotificationsYet': 'अभी तक कोई सूचना नहीं',
    'notificationsEmptyMessage': 'आपको यहां अपने वॉलेट के बारे में\nमहत्वपूर्ण अपडेट और अलर्ट दिखेंगे।',

    AppStrings.wallet: 'बटुआ',
    AppStrings.digitalWallet: 'डिजिटल वॉलेट',
    AppStrings.expirySoon: 'जल्द समाप्त',
    AppStrings.currentBalanceTitle: 'वर्तमान शेष',
    AppStrings.rewardsEarnedTitle: 'कमाए गए रिवार्ड्स',
    AppStrings.walletBalanceTitle: 'वॉलेट बैलेंस',
    AppStrings.lastUpdatedPrefix: 'अंतिम अपडेट',
    AppStrings.addFunds: 'राशि जोड़ें',
    AppStrings.history: 'इतिहास',
    AppStrings.notifications: 'सूचनाएं',
    AppStrings.deposits: 'जमा',
    AppStrings.overview: 'सारांश',
    AppStrings.addFundsToWallet: 'वॉलेट में राशि जोड़ें',
    AppStrings.selectDepositMethod: 'जमा विधि चुनें',
    AppStrings.couponCodeGiftCard: 'कूपन कोड (गिफ्ट कार्ड)',
    AppStrings.amountAed: 'राशि (AED)',
    AppStrings.instant: 'तुरंत',
    AppStrings.giftCard: 'गिफ्ट कार्ड',
    AppStrings.creditDebitCard: 'क्रेडिट/डेबिट कार्ड',
    AppStrings.visaMasterAccepted: 'वीजा, मास्टरकार्ड स्वीकार्य',
    AppStrings.processingFeeSuffix: 'प्रोसेसिंग शुल्क',
    AppStrings.balanceLabel: 'बैलेंस: ',
    AppStrings.was: 'था: ',
    AppStrings.applePay: 'एप्पल पे',
    AppStrings.applePaySubtitle: 'अपने एप्पल वॉलेट से भुगतान करें',
    AppStrings.paymentCard: 'कार्ड',
    AppStrings.paymentTabby: 'Tabby',
    AppStrings.paymentTamara: 'Tamara',
    AppStrings.termsNote: 'ऑर्डर देने से, आप पुष्टि करते हैं कि आपने शर्तें पढ़ ली हैं और सहमत हैं।',
    AppStrings.selectFromExistingAddresses: 'मौजूदा पतों में से चुनें',
    AppStrings.orderSummary: 'ऑर्डर सारांश',
    AppStrings.subtotalUpper: 'उप-योग',
    AppStrings.taxVat: 'कर (VAT)',
    AppStrings.shipping: 'शिपिंग',
    AppStrings.couponDiscount: 'कूपन छूट',
    AppStrings.promotionDiscount: 'प्रमोशन छूट',
    AppStrings.totalUpper: 'कुल',
    AppStrings.deliverTo: 'वितरण करें',
    AppStrings.noAddressSelected: 'कोई पता चयनित नहीं',
    AppStrings.addressDetailsNotFound: 'पते का विवरण नहीं मिला',
    AppStrings.areaState: 'क्षेत्र/राज्य',
    AppStrings.phoneNumber: 'फ़ोन नंबर',
    AppStrings.grandTotal: 'कुल योग',
    AppStrings.payNowTitle: 'अभी भुगतान करें',
    AppStrings.paymentCompletedSuccessfully: 'भुगतान सफलतापूर्वक पूर्ण हुआ',
    AppStrings.applePayFailed: 'Apple Pay भुगतान विफल हुआ। कृपया पुन: प्रयास करें।',
    AppStrings.applePayErrorPrefix: 'Apple Pay भुगतान त्रुटि: ',
    AppStrings.shippingAddressDescription: 'अगले पेज पर इस ऑर्डर की समीक्षा करने तक आपसे शुल्क नहीं लिया जाएगा।',
    AppStrings.shippingAddress: 'शिपिंग पता',
    AppStrings.selectShippingAddress: 'शिपिंग पता चुनें',
    'confirmPaymentCancel': 'भुगतान रद्द करें?',
    'paymentCancelWarning': 'क्या आप वाकई भुगतान रद्द करना चाहते हैं?',
    'continuePayment': 'भुगतान जारी रखें',
    'cancelPayment': 'भुगतान रद्द करें',
    'noOrderDetailsFound': 'ऑर्डर विवरण नहीं मिला',
    'retry': 'पुनः प्रयास करें',
    'orderPlacedSuccessfully': 'ऑर्डर सफलतापूर्वक किया गया! विवरण के लिए अपने ऑर्डर देखें।',

    'payment_successful': 'भुगतान सफल हुआ',
    'payment_failed': 'भुगतान असफल रहा',
    'payment_cancelled': 'भुगतान रद्द कर दिया गया',
    'payment_link_error': 'भुगतान लिंक बनाने में विफल',
    'vendorAccountUnderReview': 'आपका विक्रेता खाता समीक्षा में है और स्वीकृति की प्रतीक्षा कर रहा है।',
    'content': 'सामग्री',
    AppStrings.brands: 'ब्रांड',
    AppStrings.celebrities: 'सेलिब्रिटी',
    AppStrings.categories: 'श्रेणियाँ',
    AppStrings.account: 'खाता',
    'pleaseSelectRequiredOptions': 'कृपया सभी आवश्यक विकल्प चुनें',
    'dismiss': 'खारिज करें',
    'Bazaar': 'बाज़ार',
    'state': 'राज्य',
    'stateIsRequired': 'राज्य आवश्यक है',
    'cityIsRequired': 'शहर आवश्यक है',
    'selectState': 'राज्य चुनें',
    'selectCity': 'शहर चुनें',
    'unknownState': 'अज्ञात राज्य',
// Core App Strings (Hindi translations)
    AppStrings.darkMode: 'डार्क मोड',
    AppStrings.giftsByOccasion: 'अवसर के अनुसार उपहार',
    AppStrings.changeLanguage: 'भाषा बदलें',
    AppStrings.welcomeMessage: 'हमारे ऐप में आपका स्वागत है!',
    AppStrings.loginSignUp: 'लॉगिन/साइनअप',
    AppStrings.cart: 'कार्ट',
    AppStrings.changePassword: 'पासवर्ड बदलें',
    AppStrings.redeemCard: 'गिफ्ट कार्ड रिडीम करें',
    AppStrings.joinAsSeller: 'विक्रेता के रूप में शामिल हों',
    AppStrings.joinUsSeller: 'हमारे साथ विक्रेता के रूप में शामिल हों',
    AppStrings.privacyPolicy: 'गोपनीयता नीति',
    AppStrings.aboutUs: 'हमारे बारे में',
    AppStrings.location: 'स्थान',
    AppStrings.helpAndSupport: 'सहायता और समर्थन',
    AppStrings.signUp: 'साइनअप',
    AppStrings.signIn: 'साइन इन',
    AppStrings.description: 'विवरण',
    AppStrings.termsAndConditions: 'नियम और शर्तें',
    AppStrings.buyAndRedeem: 'खरीदें और रिडीम करें',
    AppStrings.vendor: 'विक्रेता डैशबोर्ड',
    AppStrings.vendorAgreement: 'विक्रेता समझौता',

// Descriptions (Hindi)
    AppStrings.descriptionGiftCard:
        'सही उपहार की तलाश में? Events ई-गिफ्ट कार्ड यहाँ हैं जो उपहार देना आसान बनाते हैं। हमारा ई-उपहार आपके प्रियजनों को वही देने का सबसे आसान और सुविधाजनक तरीका है जो वे चाहते हैं। इसे एक ईमानदार संदेश के साथ व्यक्तिगत बनाएं और बाकी हम पर छोड़ दें।',
    AppStrings.termsAndConditionsText:
        'ई-गिफ्ट कार्ड को हमारी वेबसाइट या मोबाइल ऐप पर क्रेडिट के लिए रिडीम किया जा सकता है। ई-गिफ्ट कार्ड खरीद की तारीख से एक साल तक वैध है। हमारे ई-गिफ्ट कार्ड खरीदने के लिए कोई अतिरिक्त शुल्क या लागत नहीं है। हालांकि, एक बार खरीदने के बाद वे रद्द या वापस नहीं किए जा सकते। कृपया सभी प्राप्तकर्ता जानकारी की सटीकता सुनिश्चित करें, क्योंकि हम गलत तरीके से भेजे गए ई-गिफ्ट कार्ड कोड के रिडीम या प्रतिस्थापन के लिए जिम्मेदार नहीं होंगे।',
    AppStrings.redeemFirstLine: 'पूर्व-लोड की गई राशि चुनें या कस्टम राशि दर्ज करें',
    AppStrings.redeemSecondLine: 'प्राप्तकर्ता का नाम और ईमेल पता प्रदान करें',
    AppStrings.redeemThirdLine: 'लेन-देन के बाद, प्राप्तकर्ता को ईमेल के माध्यम से ई-गिफ्ट कार्ड कोड प्राप्त होगा',
    AppStrings.redeemForthLine: 'प्राप्तकर्ता लिंक पर क्लिक करके और कोड दर्ज करके उपहार की राशि रिडीम कर सकता है',
    AppStrings.redeemFifthLine: 'एक बार रिडीम होने के बाद, राशि प्राप्तकर्ता के Events बैलेंस में जोड़ दी जाएगी',

// Cart & Shopping (Hindi)
    AppStrings.myCart: 'मेरी कार्ट',
    AppStrings.back: 'वापस',
    AppStrings.totalColon: 'कुल: ',
    AppStrings.profile: 'प्रोफाइल',
    AppStrings.shippingFees: '(शिपिंग शुल्क शामिल नहीं)',
    AppStrings.proceedToCheckOut: 'चेकआउट के लिए आगे बढ़ें',
    AppStrings.addToCart: 'कार्ट में जोड़ें',
    AppStrings.subTotalColon: 'उप-कुल: ',
    AppStrings.taxColon: 'कर: ',
    AppStrings.couponCodeText: 'कूपन कोड',
    AppStrings.couponCodeAmount: 'कूपन कोड छूट राशि: ',
    AppStrings.shippingFee: 'शिपिंग शुल्क',
    AppStrings.switchLanguage: 'भाषा बदलें',
    AppStrings.wishList: 'इच्छा सूची',
    AppStrings.emptyWishList: 'आपकी इच्छा सूची खाली है!',
    AppStrings.viewAll: 'सभी देखें',
    AppStrings.quantity: 'मात्रा:',
    AppStrings.percentOff: '% छूट',
    AppStrings.off: 'छूट',
    AppStrings.gotoWishlist: 'इच्छा सूची पर जाएं',
    AppStrings.continueShopping: 'खरीदारी जारी रखें',
    AppStrings.cartIsEmpty: 'कार्ट खाली है\nअपनी कार्ट में जोड़ना शुरू करें',
    AppStrings.aed: 'दिरहम',

// About Us (Hindi)
    AppStrings.aboutUsEvents:
        'द इवेंट्स में, हम मानते हैं कि हर अवसर को स्टाइल में मनाया जाना चाहिए। संयुक्त अरब अमीरात में स्थापित, हमारा प्लेटफ़ॉर्म क्षेत्र के प्रमुख ऑनलाइन मार्केटप्लेस में से एक बन गया है, जहाँ कार्यक्रमों, उपहारों और जीवनशैली से जुड़ी सेवाओं की पेशकश की जाती है। हम ग्राहकों को भरोसेमंद विक्रेताओं, ब्रांडों और सेवा प्रदाताओं की विस्तृत श्रृंखला से जोड़ते हैं — फूलों और गोरमेट गिफ्ट्स से लेकर लक्ज़री उत्पादों, अनुभवों और इवेंट आवश्यकताओं तक — सब कुछ एक सहज डिजिटल स्पेस में। हमारा मिशन सरल है: खोजने, बुक करने और उपहार देने की प्रक्रिया को आसान बनाना। अत्याधुनिक तकनीक को स्थानीय संस्कृति और अंतरराष्ट्रीय रुझानों की गहरी समझ के साथ जोड़कर, हम सुनिश्चित करते हैं कि हर ऑर्डर देखभाल, गुणवत्ता और विश्वसनीयता के साथ पूरा किया जाए। हमारे विकास के विज़न के हिस्से के रूप में, हम यूएई से आगे पूरे जीसीसी क्षेत्र को कवर करने की दिशा में बढ़ रहे हैं, ताकि पूरे अरब खाड़ी में ग्राहकों को हमारा अभिनव मार्केटप्लेस और प्रीमियम सेवाएँ प्रदान की जा सकें। द इवेंट्स में, हम सिर्फ एक मार्केटप्लेस नहीं हैं — हम आपके साझेदार हैं, यादगार पलों को बनाने में जो जीवनभर कायम रहें।',
    AppStrings.ourMissionText:
        'द इवेंट्स में, हमारा मिशन है लोगों के जश्न मनाने और जुड़ने के तरीके को सरल बनाना। हम एक सहज डिजिटल मार्केटप्लेस प्रदान करने का प्रयास करते हैं जो भरोसेमंद विक्रेताओं, प्रीमियम उत्पादों और उत्कृष्ट सेवाओं को एक साथ लाता है — जिससे हर अवसर की योजना बनाना आसान हो, अनुभव करना आनंददायक हो और याद रखना अविस्मरणीय हो।',
    AppStrings.ourVisionText:
        'हमारा विज़न है कि हम पूरे जीसीसी क्षेत्र में कार्यक्रमों, उपहारों और जीवनशैली अनुभवों के लिए अग्रणी ऑनलाइन डेस्टिनेशन बनें। नवाचार, विश्वसनीयता और सांस्कृतिक प्रामाणिकता को मिलाकर, हम लाखों ग्राहकों और साझेदारों को जीवन के पलों को स्टाइल में मनाने के लिए प्रेरित करना चाहते हैं।',
    AppStrings.ourMission: 'हमारा मिशन',
    AppStrings.ourVision: 'हमारा विजन',
    AppStrings.ourValues: 'हमारे मूल्य',
    AppStrings.ourLocation: 'हम कवर कर रहे हैं',
    AppStrings.vendorHeading:
        'अपने ग्राहकों और योगदानकर्ताओं को ٹरیک کرنے کے لیے ایک اکاؤنٹ بنائیں۔ اکاؤنٹ بنانے کے بعد، ہم آپ کو ای میل کے ذریعے تصدیق بھیجیں گے۔',
    AppStrings.vendorContactHeading:
        'معاہدے کا جائزہ لیں اور تمام معلومات کی درستگی کو یقینی بنائیں۔ پھر ادائیگی کے لیے آگے بڑھیں۔',
    AppStrings.who: 'ہم',
    AppStrings.weAre: 'کون ہیں',
    AppStrings.our: 'ہمارا',
    AppStrings.mission: 'مشن',
    AppStrings.vision: 'ویژن',
    AppStrings.values: 'اقدار',
    AppStrings.simplicity: 'سادگی',
    AppStrings.innovation: 'جدت',
    AppStrings.thoughtfulness: 'غور و فکر',
    AppStrings.reliability: 'قابل اعتمادی',
    AppStrings.countryIsRequired: 'देश आवश्यक है',

// Vendor (Hindi)
    AppStrings.agreementAccept: 'मैं नियम और शर्तों से सहमत हूं',
    AppStrings.registrationDone: 'पंजीकरण सफलतापूर्वक पूरा हुआ!\nअब आप भुगतान के लिए आगे बढ़ सकते हैं।',
    AppStrings.paymentDone: 'भुगतान सफलतापूर्वक हुआ!',
    AppStrings.paymentThanks: 'भुगतान पूरा करने के लिए धन्यवाद।',
// Countries (Hindi)
    AppStrings.unitedArabEmirates: 'संयुक्त अरब अमीरात',
    AppStrings.saudiArabia: 'सऊदी अरब',
    AppStrings.bahrain: 'बहरीन',
    AppStrings.kuwait: 'कुवैत',
    AppStrings.oman: 'ओमान',
    AppStrings.qatar: 'कतर',

// Authentication (Hindi)
    AppStrings.forgetPassword: 'पासवर्ड भूल गए?',
    AppStrings.doNotHaveAccountYet: 'अभी तक खाता नहीं है?',
    AppStrings.createOneNow: 'अभी बनाएं',
    AppStrings.send: 'भेजें',
    AppStrings.emailAddress: 'ईमेल पता',
    AppStrings.emailRequired: 'ईमेल आवश्यक है',
    AppStrings.login: 'लॉगिन',
    AppStrings.enterYourEmail: 'अपना ईमेल दर्ज करें',
    AppStrings.passRequired: 'पासवर्ड आवश्यक है',
    AppStrings.enterYourPassword: 'अपना पासवर्ड दर्ज करें',
    AppStrings.continueo: 'जारी रखें',
    AppStrings.getHelp: 'सहायता प्राप्त करें',
    AppStrings.haveTroubleLogging: 'लॉगिन में समस्या आ रही है?',
    AppStrings.fullName: 'पूरा नाम',
    AppStrings.confirmPassword: 'पासवर्ड की पुष्टि करें',
    AppStrings.passwordValidation: 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए।',
    AppStrings.agreement: 'समझौता',
    AppStrings.terms: 'नियम',
    AppStrings.searchEvents: 'इवेंट्स खोजें',
    AppStrings.notification: 'सूचनाएं',
    AppStrings.confirmLogout: 'लॉगआउट की पुष्टि करें',
    AppStrings.confirmLogoutMessage: 'क्या आप वाकई लॉगआउट करना चाहते हैं?',
    AppStrings.logout: 'लॉगआउट',

// Profile & Account (Hindi)
    AppStrings.address: 'पता',
    AppStrings.giftCards: 'गिफ्ट कार्ड',
    AppStrings.reviews: 'समीक्षाएं',
    AppStrings.orders: 'ऑर्डर',
    AppStrings.myAccount: 'मेरा खाता',
    AppStrings.enterCurrentPassword: 'वर्तमान पासवर्ड दर्ज करें',
    AppStrings.currentPasswordCannotBeEmpty: 'वर्तमान पासवर्ड खाली नहीं हो सकता',
    AppStrings.currentPassword: 'वर्तमान पासवर्ड',
    AppStrings.enterChangePassword: 'नया पासवर्ड दर्ज करें',
    AppStrings.enterReEnterPassword: 'नया पासवर्ड फिर से दर्ज करें',
    AppStrings.reEnterPassword: 'पासवर्ड फिर से दर्ज करें',
    AppStrings.update: 'अपडेट',
    AppStrings.pleaseEnterFields: 'कृपया सभी फील्ड दर्ज करें',
    AppStrings.noRecord: 'कोई रिकॉर्ड नहीं',
    AppStrings.edit: 'संपादित करें',
    AppStrings.phone: 'फोन',
    AppStrings.email: 'ईमेल',
    AppStrings.name: 'नाम',
    AppStrings.defaultAddress: 'डिफ़ॉल्ट पता',
    AppStrings.create: 'बनाएं',
    AppStrings.unknownCountry: 'अज्ञात देश',
    AppStrings.pleaseCheckFields: 'कृपया फील्ड जांचें',
    AppStrings.addressSaved: 'पता सहेजा गया',
    AppStrings.save: 'सहेजें',
    AppStrings.useDefaultAddress: 'इस पते को डिफ़ॉल्ट के रूप में उपयोग करें',
    AppStrings.cityCannotBeEmpty: 'शहर खाली नहीं हो सकता',
    AppStrings.city: 'शहर',
    AppStrings.enterCity: 'शहर दर्ज करें',
    AppStrings.stateCannotBeEmpty: 'राज्य खाली नहीं हो सकता',
    AppStrings.enterState: 'राज्य दर्ज करें',
    AppStrings.pleaseSelectCountry: 'कृपया देश चुनें',
    AppStrings.country: 'देश',
    AppStrings.enterCountry: 'देश दर्ज करें',
    AppStrings.enterAddress: 'पता दर्ज करें',
    AppStrings.enterEmailAddress: 'ईमेल पता दर्ज करें',
    AppStrings.enterPhoneNumber: 'फोन नंबर दर्ज करें',
    AppStrings.enterName: 'नाम दर्ज करें',
    AppStrings.enterYourName: 'अपना नाम दर्ज करें',
    AppStrings.reviewed: 'समीक्षित',
    AppStrings.waitingForReview: 'समीक्षा की प्रतीक्षा में',
    AppStrings.nameCannotBeEmpty: 'नाम खाली नहीं हो सकता',
    AppStrings.phoneCannotBeEmpty: 'फोन नंबर खाली नहीं हो सकता',
    AppStrings.pleaseFillAllFields: 'कृपया सभी फील्ड भरें',
    AppStrings.emailCannotBeEmpty: 'ईमेल खाली नहीं हो सकता',
    AppStrings.deleteMyAccount: 'मेरा खाता हटाएं',
    AppStrings.deleteAccount: 'खाता हटाएं',
    AppStrings.delete: 'हटाएं',
    AppStrings.deleteAccountWarning:
        'क्या आप वाकई अपना खाता हटाना चाहते हैं? आप अपना डेटा पुनर्प्राप्त नहीं कर पाएंगे।',
    AppStrings.addressCannotBeEmpty: 'पता खाली नहीं हो सकता',

// Reviews (Hindi)
    AppStrings.noProductsAvailable: 'समीक्षा के लिए कोई उत्पाद उपलब्ध नहीं',
    AppStrings.uploadPhotos: 'फोटो अपलोड करें',
    AppStrings.uploadPhotosMessage: 'अधिकतम 5 फोटो',
    AppStrings.submitReview: 'समीक्षा सबमिट करें',
    AppStrings.errorSubmittingReview: 'समीक्षा सबमिट करने में त्रुटि',
    AppStrings.review: 'समीक्षा',
    AppStrings.failedToAddPhotos: 'फोटो जोड़ने में विफल',
    AppStrings.maxFilesError: 'चुनने के लिए अधिकतम फाइलों की संख्या 5 है।',
    AppStrings.noReviews: 'अभी तक कोई समीक्षा नहीं',
    AppStrings.customerReviews: 'ग्राहक समीक्षाएं',
    AppStrings.reviewSeller: 'विक्रेता की समीक्षा',
    AppStrings.reviewProduct: 'उत्पाद की समीक्षा',
    AppStrings.ratings: 'रेटिंग',
    AppStrings.star: 'स्टार',
    AppStrings.stars: 'स्टार्स',

// Coupons (Hindi)
    AppStrings.couponAppliedSuccess: 'कूपन सफलतापूर्वक लागू किया गया!',
    AppStrings.couponRemovedSuccess: 'कूपन सफलतापूर्वक हटाया गया!',
    AppStrings.couponInvalidOrExpired: 'कूपन अमान्य या समाप्त हो गया है।',
    AppStrings.couponLabel: 'कूपन कोड दर्ज करें',
    AppStrings.couponHint: 'कूपन कोड',

// Checkout & Payment (Hindi)
    AppStrings.continueToPayment: 'भुगतान के लिए जारी रखें',
    AppStrings.currencyAED: 'यूएई दिरहम',
    AppStrings.acceptTermsAndConditions: 'मैं नियम और शर्तों को स्वीकार करता हूं',
    AppStrings.readOurTermsAndConditions: 'हमारे नियम और शर्तें पढ़ें',
    AppStrings.mustAcceptTerms: 'जारी रखने के लिए आपको नियम और शर्तों को स्वीकार करना होगा',
    AppStrings.confirmAndSubmitOrder: 'ऑर्डर की पुष्टि और सबमिट करें',
    AppStrings.byClickingSubmit: '"पुष्टि और सबमिट ऑर्डर" पर क्लिक करके, आप सहमत होते हैं',
    AppStrings.and: 'और',

// Hindi VendorAppStrings translations
    VendorAppStrings.titleGender: 'लिंग',
    VendorAppStrings.hintEnterEmail: 'ईमेल दर्ज करें',
    VendorAppStrings.hintEnterFullName: 'पूरा नाम दर्ज करें',
    VendorAppStrings.hintSelectGender: 'अपना लिंग चुनें',
    VendorAppStrings.errorEmailRequired: 'ईमेल आवश्यक है',
    VendorAppStrings.errorValidEmail: 'एक वैध ईमेल दर्ज करें',
    VendorAppStrings.asterick: ' *',
    VendorAppStrings.home: 'होम',
    VendorAppStrings.shop: 'दुकान',
    VendorAppStrings.dashboard: 'डैशबोर्ड',
    VendorAppStrings.orderReturns: 'ऑर्डर रिटर्न',
    VendorAppStrings.withdrawals: 'निकासी',
    VendorAppStrings.revenues: 'राजस्व',
    VendorAppStrings.settings: 'सेटिंग्स',
    VendorAppStrings.logoutFromVendor: 'विक्रेता से लॉगआउट',
    VendorAppStrings.saveAndContinue: 'सहेजें और जारी रखें',
    VendorAppStrings.previewAgreement: 'समझौते का पूर्वावलोकन',
    VendorAppStrings.downloadAgreement: 'समझौता डाउनलोड करें',
// Common Actions (Hindi)
    AppStrings.cancel: 'रद्द करें',
    AppStrings.yes: 'हाँ',
    AppStrings.no: 'नहीं',
    AppStrings.loading: 'लोड हो रहा है...',
    AppStrings.error: 'त्रुटि: ',
    AppStrings.confirmation: 'पुष्टि',
    AppStrings.cancelOrderConfirmationMessage: 'क्या आप वाकई जारी रखना चाहते हैं?',
    AppStrings.allow: 'अनुमति दें',
    AppStrings.pending: 'लंबित',
    AppStrings.completed: 'पूर्ण',
    AppStrings.purchased: 'खरीदा गया',
    AppStrings.noDataAvailable: 'कोई डेटा उपलब्ध नहीं',

// Screen Titles
    VendorAppStrings.bankDetails: 'बैंक विवरण',
    VendorAppStrings.loginInformation: 'लॉगिन जानकारी',
    VendorAppStrings.businessOwnerInformation: 'व्यवसाय मालिक की जानकारी',
    VendorAppStrings.emailVerificationPending: 'ईमेल सत्यापन लंबित!',
    VendorAppStrings.pleaseVerifyEmail: 'कृपया अपना ईमेल पता सत्यापित करें! और सत्यापित करने पर टैप करें।',
    VendorAppStrings.checkInboxSpam: 'ईमेल पते के सत्यापन के लिए कृपया अपना इनबॉक्स और स्पैम फोल्डर जांचें!',
    VendorAppStrings.accountVerified: 'खाता सत्यापित किया गया है।',
    VendorAppStrings.emailVerificationPendingStatus: 'ईमेल सत्यापन लंबित है।',
    VendorAppStrings.verify: 'सत्यापित करें',
    VendorAppStrings.resend: 'पुनः भेजें',

// Additional Screen Titles
    VendorAppStrings.authorizedSignatoryInformation: 'अधिकृत हस्ताक्षरकर्ता की जानकारी',
    VendorAppStrings.companyInformation: 'कंपनी की जानकारी',
    VendorAppStrings.contractAgreement: 'अनुबंध समझौता',
    VendorAppStrings.pleaseSignHere: 'कृपया यहाँ हस्ताक्षर करें *',
    VendorAppStrings.clear: 'साफ़ करें',
    VendorAppStrings.pleaseSignAgreement: 'कृपया इस समझौते पर हस्ताक्षर करें',
    VendorAppStrings.youMustAgreeToProceed: 'आपको आगे बढ़ने के लिए सहमत होना होगा',

// Additional Form Labels
    VendorAppStrings.poaMoaPdf: 'पीओए / एमओए (pdf)',
    VendorAppStrings.uploadCompanyLogo: 'कंपनी का लोगो अपलोड करें',
    VendorAppStrings.companyCategoryType: 'कंपनी श्रेणी प्रकार',
    VendorAppStrings.phoneNumberLandline: 'फोन नंबर (लैंडलाइन)',
    VendorAppStrings.tradeLicenseNumber: 'व्यापार लाइसेंस नंबर',
    VendorAppStrings.uploadTradeLicensePdf: 'व्यापार लाइसेंस अपलोड करें (pdf)',
    VendorAppStrings.tradeLicenseNumberExpiryDate: 'व्यापार लाइसेंस की समाप्ति तिथि',
    VendorAppStrings.nocPoaIfApplicablePdf: 'एनओसी/पीओए (यदि लागू हो - pdf)',
    VendorAppStrings.vatCertificateIfApplicablePdf: 'वैट प्रमाणपत्र (यदि लागू हो - pdf)',
    VendorAppStrings.companyStamp: 'कंपनी का मुहर (500*500)',

// Additional Form Hints
    VendorAppStrings.enterCompanyName: 'कंपनी का नाम दर्ज करें',
    VendorAppStrings.enterMobileNumber: 'मोबाइल नंबर दर्ज करें',
    VendorAppStrings.enterTradeLicenseNumber: 'व्यापार लाइसेंस नंबर दर्ज करें',
    VendorAppStrings.enterCompanyAddress: 'कंपनी का पता दर्ज करें',
    VendorAppStrings.enterTradeLicenseExpiryDate: 'yyyy-MM-dd',

// Additional Dropdown Options
    VendorAppStrings.selectCcType: 'कृपया क्रेडिट कार्ड प्रकार चुनें',
    VendorAppStrings.selectCountry: 'कृपया देश चुनें',
    VendorAppStrings.selectRegion: 'कृपया क्षेत्र चुनें',
// Additional Error Messages

// Payment and Subscription
    VendorAppStrings.payment: 'भुगतान',
    VendorAppStrings.nowAed: 'अब AED',
    VendorAppStrings.youWillBeRedirectedToTelrTabby: 'आपको भुगतान पूरा करने के लिए Telr पर पुनर्निर्देशित किया जाएगा',
    VendorAppStrings.paymentFailure: 'भुगतान विफल',
    VendorAppStrings.congratulations: 'बधाई हो!',

// Company Information
    VendorAppStrings.companyName: 'कंपनी का नाम',
    VendorAppStrings.companyEmail: 'कंपनी का ईमेल',
    VendorAppStrings.mobileNumber: 'मोबाइल नंबर',
    VendorAppStrings.companyAddress: 'कंपनी का पता',
    VendorAppStrings.region: 'क्षेत्र',

// Form Hints
    VendorAppStrings.noFileChosen: 'कोई फाइल नहीं चुनी गई',
    VendorAppStrings.enterCompanyEmail: 'कंपनी का ईमेल दर्ज करें',

// Business and Authorization
    VendorAppStrings.areYouBusinessOwner: 'क्या आप व्यवसाय के मालिक हैं?',
    VendorAppStrings.areYouAuthorizedSignatory: 'क्या आप अधिकृत हस्ताक्षरकर्ता हैं?',

// Ensure presence of order and file/gift card keys (fallback to English constants)
    AppStrings.cancellationInfo: AppStrings.cancellationInfo,
    AppStrings.cancelWithinOneHour: AppStrings.cancelWithinOneHour,
    AppStrings.returnOrder: AppStrings.returnOrder,
    AppStrings.viewOrderUppercase: AppStrings.viewOrderUppercase,
    AppStrings.ordersCancelled: AppStrings.ordersCancelled,
    AppStrings.oneItemCancelled: AppStrings.oneItemCancelled,
    AppStrings.perfume: AppStrings.perfume,
    AppStrings.refundDetails: AppStrings.refundDetails,
    AppStrings.refundNotApplicable: AppStrings.refundNotApplicable,
    AppStrings.refund: AppStrings.refund,
    AppStrings.noOrders: AppStrings.noOrders,
    AppStrings.orderViewed: AppStrings.orderViewed,
    AppStrings.viewProduct: AppStrings.viewProduct,
    AppStrings.viewOrder: AppStrings.viewOrder,
    AppStrings.orderDetails: AppStrings.orderDetails,
    AppStrings.orderInfo: AppStrings.orderInfo,
    AppStrings.orderNumber: AppStrings.orderNumber,
    AppStrings.time: AppStrings.time,
    AppStrings.orderStatus: AppStrings.orderStatus,
    AppStrings.charges: AppStrings.charges,
    AppStrings.totalAmount: AppStrings.totalAmount,
    AppStrings.shippingInfo: AppStrings.shippingInfo,
    AppStrings.shippingStatus: AppStrings.shippingStatus,
    AppStrings.dateShipped: AppStrings.dateShipped,
    AppStrings.uploadPaymentProof: AppStrings.uploadPaymentProof,

    AppStrings.viewReceipt: AppStrings.viewReceipt,
    AppStrings.uploadedProofNote: AppStrings.uploadedProofNote,
    AppStrings.reUploadNote: AppStrings.reUploadNote,
    AppStrings.noProofUploaded: AppStrings.noProofUploaded,
    AppStrings.invoice: AppStrings.invoice,

// File Operations
    AppStrings.permissionDenied: AppStrings.permissionDenied,
    AppStrings.userCancelled: AppStrings.userCancelled,
    AppStrings.fileSavedSuccess: AppStrings.fileSavedSuccess,
    AppStrings.fileSaveError: AppStrings.fileSaveError,
    AppStrings.storagePermissionTitle: AppStrings.storagePermissionTitle,
    AppStrings.storagePermissionMessage: AppStrings.storagePermissionMessage,

// Gift Cards
    AppStrings.selectGiftCardAmount: AppStrings.selectGiftCardAmount,
    AppStrings.selectOrAddAmount: AppStrings.selectOrAddAmount,
    AppStrings.amountMustBeLessThan: AppStrings.amountMustBeLessThan,
    AppStrings.invalidAmountEntered: AppStrings.invalidAmountEntered,
    AppStrings.enterReceiptName: AppStrings.enterReceiptName,
    AppStrings.enterReceiptEmail: AppStrings.enterReceiptEmail,
    AppStrings.additionalNotes: AppStrings.additionalNotes,
    AppStrings.discount50: AppStrings.discount50,
    AppStrings.searchDiscounts: AppStrings.searchDiscounts,

// Placeholder values
    AppStrings.actualPrice: AppStrings.actualPrice,
    AppStrings.standardPrice: AppStrings.standardPrice,
    AppStrings.fiftyPercentOffPrice: AppStrings.fiftyPercentOffPrice,
  },
  // Urdu
  'ur': {
    'walletApplicable': 'والیٹ قابل اطلاق ہے',
    AppStrings.vendorSubscriptionOneYear: 'وینڈر سبسکرپشن (1 سال)',
    AppStrings.vendorSubscriptionDescription: 'یہ وینڈر رجسٹریشن کے لیے ایک بار کی فیس ہے۔',
    'loginSuccessfully': 'لاگ ان کامیابی کے ساتھ ہو گیا',
    'paidAmount': 'ادا کی گئی رقم',
    'saveLower': 'محفوظ کریں',
    'shippingUp': 'شپنگ',
    'statusUp': 'حالت',
    'shippingMethodUp': 'شپنگ کا طریقہ',
    'downloadInvoice': 'انوائس ڈاؤن لوڈ کریں',
    'ordersLower': 'آرڈرز',
    'updateShippingStatusFull': 'شپنگ کی حالت اپ ڈیٹ کریں',
    'weightUp': 'وزن (گرام)',
    'editOrder': 'آرڈر میں ترمیم کریں',
    'orderInformation': 'آرڈر کی معلومات',
    'vendorSubscriptionExpired': 'آپ کی رکنیت ختم ہو گئی ہے',
    'youMustAddAddressFirstToContinue': 'جاری رکھنے کے لیے پہلے پتہ شامل کرنا ضروری ہے',
    'noShippingMethodAvailable': 'کوئی شپنگ طریقہ دستیاب نہیں ہے',
    'addingNewAttributesHelps': 'نئی خصوصیات شامل کرنے سے پروڈکٹ کو کئی اختیارات ملتے ہیں جیسے سائز یا رنگ۔',
    'digitalLinks': 'ڈیجیٹل لنکس',
    'fileName': 'فائل کا نام',
    'externalLink': 'بیرونی لنک',
    'size': 'سائز',
    'saved': 'محفوظ کیا گیا',
    'unsaved': 'غیر محفوظ',
    'authenticationFailed': 'تصدیق ناکام ہوگئی۔ براہ کرم دوبارہ لاگ ان کریں۔',
    'authenticationRequired': 'تصدیق درکار ہے',
    'requestCancelled': 'درخواست منسوخ کردی گئی',
    'failedToAddItemToCart': 'کارٹ میں آئٹم شامل کرنے میں ناکامی',
    'somethingWentWrong': 'کچھ غلط ہوگیا۔',
    'anErrorOccurred': 'ایک خرابی پیش آگئی۔ براہ کرم دوبارہ کوشش کریں۔',
    'failedToLoadCartData': 'کارٹ ڈیٹا لوڈ کرنے میں ناکامی۔',
    'failedToLoadCheckoutData': 'چیک آؤٹ ڈیٹا لوڈ کرنے میں ناکامی۔',
    'anErrorOccurredDuringCheckout': 'چیک آؤٹ کے دوران خرابی پیش آئی۔',
    'anErrorOccurredWhileUpdatingCart': 'کارٹ کو اپ ڈیٹ کرتے وقت خرابی پیش آئی۔',
    'noOrdersFound': 'کوئی آرڈر نہیں ملا۔',
    'failedToLoadAddresses': 'پتے لوڈ کرنے میں ناکامی۔',
    'addressDeleteSuccess': 'پتہ کامیابی کے ساتھ حذف کردیا گیا!',
    'failedToDeleteAddress': 'پتہ حذف کرنے میں ناکامی۔',
    'errorDeletingAddress': 'پتہ حذف کرتے وقت خرابی پیش آئی۔',
    'addressUpdateSuccess': 'پتہ کامیابی کے ساتھ اپ ڈیٹ ہوگیا!',
    'invalidAddressData': 'براہ کرم درست ڈیٹا درج کریں۔',
    'failedToLoadData': 'ڈیٹا لوڈ کرنے میں ناکامی۔',
    'pleaseLoginWishlist': 'براہ کرم اپنی خواہشات کی فہرست کو منظم کرنے کے لیے لاگ ان کریں۔',
    'wishlistUpdateFailed': 'خواہشات کی فہرست کو اپ ڈیٹ کرنے میں ناکامی۔',
    'unknownError': 'ایک نامعلوم خرابی پیش آگئی۔',
    'pleaseSelectShipmentStatus': 'براہ کرم ترسیل کی حالت منتخب کریں',
    'failedToUpdateShipmentStatus': 'ترسیل کی حالت اپ ڈیٹ کرنے میں ناکام',
    'resendEmail': 'ای میل دوبارہ بھیجیں',
    'paymentMethod': 'ادائیگی کا طریقہ',
    'paymentStatus': 'ادائیگی کی حیثیت',
    'shippingInformation': 'شپنگ کی معلومات',
    'updateShippingStatus': 'شپمنٹ کی حالت اپ ڈیٹ کریں',
    'errorFetchingProducts': 'پراڈکٹس حاصل کرنے میں خرابی',
    'camera': 'کیمرہ',
    'gallery': 'گیلری',
    // Validator messages (Urdu placeholders - to be translated)
    'valEmailEmpty': 'Email cannot be empty',
    'valEmailInvalid': 'Enter a valid email address.',
    'valRequiredField': 'This field is required',
    'valUrlInvalid': 'Please enter a valid link',
    'valPhoneEmpty': 'Phone number cannot be empty',
    'valPhone9Digits': 'Phone number should be 9 digits long',
    'valPhoneDigitsOnly': 'Phone number should contain only numbers.',
    'valCompanyMobileRequired': 'Company mobile number is required',
    'valCompanyMobile9Digits': 'Company mobile number should be 9 digits long',
    'valCompanyMobileDigitsOnly': 'Company mobile number should contain only numbers.',
    'valLandlineRequired': 'Phone number (Landline) is required',
    'valLandline8Digits': 'Phone number (Landline) should be 8 digits long',
    'valLandlineDigitsOnly': 'Phone number (Landline) should contain only numbers.',
    'valPhoneRequired': 'Phone is required',
    'valGenderRequired': 'Please select gender',
    'valNameEmpty': 'Name cannot be empty',
    'valNameRequired': 'Name is required',
    'valNameMax25': 'Name cannot be more than 25 characters',
    'valBankNameRequired': 'Bank name is required',
    'valAccountNameRequired': 'Account name is required',
    'valAccountNumberRequired': 'Account number is required',
    'valRegionRequired': 'Please select region',
    'valCountryRequired': 'Please select country',
    'valEidRequired': 'Emirates ID number is required',
    'valEid15Digits': 'Emirates ID number must be 15 digits long.',
    'valCompanyCategoryRequired': 'Company category type is required',
    'valEidExpiryRequired': "EID number's expiry date is required",
    'valTradingNumberRequired': 'Trading number is required',
    'valTradingNumberLength': 'Trading License number must be between 10 and 15 characters long.',
    'valTradeLicenseExpiryRequired': "Trade License number's expiry date is required",
    'valFieldRequiredAlt': 'This Field cannot be empty.',
    'valCompanyAddressRequired': 'Company address is required',
    'valCompanyNameRequired': 'Company name is required',
    'valCompanyNameMax50': 'Company name cannot be more than 50 characters',
    'valCompanySlugRequired': 'Company slug is required',
    'valCompanySlugMax20': 'Company slug cannot be more than 20 characters',
    'valZipEmpty': 'Zip code cannot be empty',
    'valZip5Digits': 'Zip Code must be 5 digits long.',
    'valZipDigitsOnly': 'Zip Code should contain only numbers.',
    'valPasswordEmpty': 'Password cannot be empty.',
    'valPasswordMin9': 'Password should be at least 9 characters long.',
    'valPasswordPolicyFull':
        'Password must include at least one uppercase letter, one lowercase letter, one digit, and one special character.',
    'valVendorPasswordMin9': 'Password should be at least 9 characters long',
    'valVendorPasswordCaseReq': 'Password must contain at least one uppercase and one lowercase letter.',
    'valPaypalIdMax120': 'PayPal ID must not be greater than 120 characters.',
    'valPaypalEmailInvalid': 'Enter a valid PayPal email ID.',
    'valIFSCMax120': 'Bank code/IFSC must not be greater than 120 characters.',
    'valAccountNumberMax120': 'Account number must not be greater than 120 characters.',
    'valCouponsNumMin1': 'Number of coupons must be greater than or equal to 1',
    'valDiscountMin1': 'Discount must be greater than or equal to 1',
    'valPermalinkRequired': 'Product permanent link is required.',
    'valPermalinkUnique': 'Please generate unique permanent link.',
    'valStartDateAfterEnd': 'Start date cannot be after end date.',
    'valInvalidDateFormat': 'Invalid date format.',
    'valAddressRequired': 'Address field is required.',
    'valAddressMin5': 'Address must be at least 5 characters long.',
    'valAddressMax100': 'Address must not exceed 100 characters.',
    'valCityRequired': 'City field is required.',
    'valCityMin2': 'City name must be at least 2 characters long.',
    'valCityMax50': 'City name must not exceed 50 characters.',
    'valCityChars': 'City name can only contain letters, spaces, and hyphens.',
    'valIbanRequired': 'IBAN number is required',
    'valIbanLength': 'Invalid IBAN length',
    'valIbanFormat': 'Invalid IBAN format',
    'chooseDiscountPeriod': 'رعایت کی مدت منتخب کریں',
    'customerWontSeeThisPrice': 'گاہک اس قیمت کو نہیں دیکھیں گے',
    'In stock': 'اسٹاک میں دستیاب',
    'Out of stock': 'اسٹاک سے باہر',
    'On backorder': 'بیک آرڈر پر',
    'percentFromOriginalPrice': 'اصل قیمت سے فیصد',
    'allowCustomerCheckoutWhenOut of stock': 'اسٹاک ختم ہونے پر گاہک کو چیک آؤٹ کرنے کی اجازت دیں',
    'stockStatus': 'اسٹاک کی حالت',
    'priceField': 'قیمت کا خانہ',
    'priceFieldDescription':
        'اصل قیمت سے کم کرنے کی رقم درج کریں۔ مثال کے طور پر: اگر اصل قیمت \$100 ہے، تو قیمت \$80 کرنے کے لیے 20 درج کریں۔',
    'typeField': 'قسم کا خانہ',
    'typeFieldDescription': 'رعایت کی قسم منتخب کریں: فکسڈ (ایک مخصوص رقم کم کریں) یا فیصد (فیصد کے لحاظ سے کم کریں)۔',
    'searchProducts': 'مصنوعات تلاش کریں',
    'selectedProductAlreadyAdded': 'منتخب شدہ مصنوعات پہلے ہی فہرست میں شامل ہے',
    'pleaseSearchAndAddProducts': 'براہ کرم تلاش کریں اور مصنوعات شامل کریں',
    'productOptionsDes': 'براہ کرم نیچے دائیں کونے میں + بٹن پر ٹیپ کر کے پراڈکٹ کے اختیارات شامل کریں۔',
    'pleaseSelectType': 'براہ کرم قسم منتخب کریں',
    'selectSectionType': 'سیکشن کی قسم منتخب کریں',
    'addGlobalOptions': 'عالمی اختیارات شامل کریں',
    'addNewRow': 'نئی قطار شامل کریں',
    'selectFromExistingFAQs': 'موجودہ عمومی سوالات میں سے منتخب کریں',
    'or': 'یا',
    'add': 'شامل کریں',
    'addKeyword': 'کلیدی لفظ شامل کریں',
    'addMoreAttribute': 'مزید خصوصیت شامل کریں',
    'productOverviewShipping': 'مصنوعات کا جائزہ (شپنگ)',
    'pendingProducts': 'زیر التواء مصنوعات',
    'pendingPackages': 'زیر التواء پیکجز',
    'request': 'درخواست',
    'publish': 'شائع کریں',
    'afterCancelAmountAndFeeWillBeRefundedBackInYourBalance':
        'منسوخی کے بعد رقم اور فیس آپ کے بیلنس میں واپس کر دی جائے گی۔',
    'doYouWantToCancelThisWithdrawal': 'کیا آپ یہ رقم نکالنے کی درخواست منسوخ کرنا چاہتے ہیں؟',
    'youWillReceiveMoneyThroughTheInformation': 'آپ کو درج ذیل معلومات کے ذریعے رقم موصول ہوگی:',
    'payoutInfo': 'ادائیگی کی معلومات',
    'noRecordFound': 'کوئی ریکارڈ نہیں ملا',
    'sku': 'ایس کے یو',
    'code': 'کوڈ',
    'amount': 'رقم',
    'totalUsed': 'کل استعمال',
    'noGiftCardsFound': 'کوئی گفٹ کارڈ نہیں ملا',
    'createFirstGiftCard': 'اپنا پہلا گفٹ کارڈ بنائیں',
    'createGiftCard': 'گفٹ کارڈ بنائیں',
    'becomeSeller': 'بیچنے والا بنیں',
    'yesBecomeSeller': 'جی ہاں، بیچنے والا بنیں',
    'becomeSellerConfirmation': 'کیا آپ واقعی بیچنے والا بننا چاہتے ہیں؟',
    'menu': 'مینو',
    'pleaseLogInToContinue': 'براہ کرم جاری رکھنے کے لیے لاگ ان کریں',
    'pleaseAddNewAddress': 'براہ کرم ایک نیا پتہ شامل کریں',
    'pleaseSelectAnAddress': 'براہ کرم ایک پتہ منتخب کریں',
    'other': 'دیگر',
    'Transaction Confirmations': 'لین دین کی توثیقات',
    'Deposits, purchases, confirmations': 'جمع، خریداری، توثیقات',

    'Achievement Alerts': 'کامیابی کی اطلاعات',
    'Milestones, rewards, goals': 'سنگ میل، انعامات، مقاصد',

    'Expiry Reminders': 'میعاد ختم ہونے کی یاد دہانیاں',
    'Product expiry, renewal alerts': 'پروڈکٹ کی میعاد ختم، تجدید کی اطلاعات',

    'Promotional Messages': 'تشہیری پیغامات',
    'Marketing updates, special offers': 'مارکیٹنگ کی تازہ کاریاں، خصوصی آفرز',

    'Security Alerts': 'سیکیورٹی کی اطلاعات',
    'Login alerts, security updates': 'لاگ ان الرٹس، سیکیورٹی اپ ڈیٹس',
    'System Updates': 'سسٹم اپ ڈیٹس',
    'App updates, maintenance notices': 'ایپ کی اپ ڈیٹس، دیکھ بھال کی اطلاعات',
    'database': 'ڈیٹا بیس',
    'sms': 'ایس ایم ایس',
    'broadcast': 'نشریات',
    'mail': 'میل',
    'Transaction': 'لین دین',
    'Expiry Reminder': 'میعاد ختم ہونے کی یاد دہانی',
    'Promotional': 'تشہیری',
    'Security': 'سیکیورٹی',
    'System': 'سسٹم',
    'Achievements': 'کارنامے',
    'copyrightText': '© 2025 دی ایونٹس۔ جملہ حقوق محفوظ ہیں۔',
    'enterYourCouponCode': 'اپنا کوپن کوڈ درج کریں',
    'redeemYourGiftCard': 'اپنا گفٹ کارڈ ریڈیم کریں',
    'noFees': 'کوئی فیس نہیں',
    AppStrings.markAsUnread: 'ناخواندہ نشان زد کریں',
    AppStrings.markAsRead: 'پڑھا ہوا نشان زد کریں',
    AppStrings.noExpiringFundsFound: 'کوئی ختم ہوتے فنڈز نہیں ملے',
    AppStrings.notificationSettings: 'نوٹیفکیشن سیٹنگز',
    AppStrings.notificationTypes: 'نوٹیفکیشن کی اقسام',
    'fundExpiryAlert': 'فنڈ ختم ہونے کی وارننگ',
    'criticalActionRequired': 'اہم - کارروائی درکار',
    'transactionsCount': 'کل لین دین',
    '7Days': '7 دن',
    '30Days': '30 دن',
    '90Days': '90 دن',
    'currentMonth': 'موجودہ مہینہ',
    'lastMonth': 'گزشتہ مہینہ',
    'currentYear': 'موجودہ سال',
    'lastYear': 'گزشتہ سال',
    // History Screen translations
    'transactionHistory': 'لین دین کی تاریخ',
    'export': 'برآمد',
    'searchTransactions': 'لین دین تلاش کریں...',
    'allTypes': 'تمام اقسام',
    'deposit': 'جمع',
    'payment': 'ادائیگی',
    'reward': 'انعام',
    'refund': 'واپسی',
    'allMethods': 'تمام طریقے',
    'creditCard': 'کریڈٹ کارڈ',
    'giftCard': 'تحفہ کارڈ',
    'bankTransfer': 'بینک ٹرانسفر',
    'thirtyDays': '30 دن',
    'sevenDays': '7 دن',
    'ninetyDays': '90 دن',
    'allTime': 'تمام وقت',
    'reset': 'دوبارہ سیٹ کریں',

    // Notifications Screen translations
    'notifications': 'اطلاعات',
    'markAllRead': 'سب کو پڑھا ہوا نشان زد کریں',
    'noNotificationsYet': 'ابھی تک کوئی اطلاع نہیں',
    'notificationsEmptyMessage': 'آپ کو یہاں اپنے بٹوے کے بارے میں\nاہم اپڈیٹس اور الرٹس نظر آئیں گے۔',

    AppStrings.wallet: 'بٹوہ',
    AppStrings.digitalWallet: 'ڈیجیٹل بٹوہ',
    AppStrings.expirySoon: 'جلد ختم ہو رہا ہے',
    AppStrings.currentBalanceTitle: 'موجودہ بیلنس',
    AppStrings.rewardsEarnedTitle: 'حاصل کردہ انعامات',
    AppStrings.walletBalanceTitle: 'بٹوے کا بیلنس',
    AppStrings.lastUpdatedPrefix: 'آخری تازہ کاری',
    AppStrings.addFunds: 'رقم شامل کریں',
    AppStrings.history: 'تاریخ',
    AppStrings.notifications: 'نوٹیفیکیشنز',
    AppStrings.deposits: 'جمع',
    AppStrings.overview: 'جائزہ',
    AppStrings.addFundsToWallet: 'بٹوے میں رقم شامل کریں',
    AppStrings.selectDepositMethod: 'جمع کرنے کا طریقہ منتخب کریں',
    AppStrings.couponCodeGiftCard: 'کوپن کوڈ (گفٹ کارڈ)',
    AppStrings.amountAed: 'رقم (AED)',
    AppStrings.instant: 'فوری',
    AppStrings.giftCard: 'گفٹ کارڈ',
    AppStrings.creditDebitCard: 'کریڈٹ/ڈیبٹ کارڈ',
    AppStrings.visaMasterAccepted: 'ویزا، ماسٹرکارڈ قبول',
    AppStrings.processingFeeSuffix: 'پروسیسنگ فیس',
    AppStrings.balanceLabel: ' بیلنس:',
    AppStrings.was: 'تھا: ',
    AppStrings.applePay: 'ایپل پے',
    AppStrings.applePaySubtitle: 'اپنے ایپل والیٹ سے ادائیگی کریں',
    AppStrings.paymentCard: 'کارڈ',
    AppStrings.paymentTabby: 'Tabby',
    AppStrings.paymentTamara: 'Tamara',
    AppStrings.termsNote: 'آرڈر کرنے سے آپ تصدیق کرتے ہیں کہ آپ نے شرائط و ضوابط پڑھ لیے ہیں اور منظور کرتے ہیں۔',
    AppStrings.selectFromExistingAddresses: 'موجودہ پتوں میں سے منتخب کریں',
    AppStrings.orderSummary: 'آرڈر خلاصہ',
    AppStrings.subtotalUpper: 'ضمنی کل',
    AppStrings.taxVat: 'ٹیکس (VAT)',
    AppStrings.shipping: 'شپنگ',
    AppStrings.couponDiscount: 'کوپن رعایت',
    AppStrings.promotionDiscount: 'پروموشن رعایت',
    AppStrings.totalUpper: 'کل',
    AppStrings.deliverTo: 'ترسیل برائے',
    AppStrings.noAddressSelected: 'کوئی پتہ منتخب نہیں کیا گیا',
    AppStrings.addressDetailsNotFound: 'پتہ کی تفصیلات نہیں ملیں',
    AppStrings.areaState: 'علاقہ/ریاست',
    AppStrings.phoneNumber: 'فون نمبر',
    AppStrings.grandTotal: 'کل رقم',
    AppStrings.payNowTitle: 'ابھی ادائیگی کریں',
    AppStrings.paymentCompletedSuccessfully: 'ادائیگی کامیابی سے مکمل ہوگئی',
    AppStrings.applePayFailed: 'Apple Pay ادائیگی ناکام ہوگئی۔ دوبارہ کوشش کریں۔',
    AppStrings.applePayErrorPrefix: 'Apple Pay ادائیگی کی خرابی: ',
    AppStrings.shippingAddressDescription: 'اگلے صفحے پر اس آرڈر کا جائزہ لینے تک آپ سے چارج نہیں کیا جائے گا۔',
    AppStrings.shippingAddress: 'ترسیلی پتہ',
    AppStrings.selectShippingAddress: 'ترسیلی پتہ منتخب کریں',
    'confirmPaymentCancel': 'ادائیگی منسوخ کریں؟',
    'paymentCancelWarning': 'کیا آپ واقعی ادائیگی منسوخ کرنا چاہتے ہیں؟',
    'continuePayment': 'ادائیگی جاری رکھیں',
    'cancelPayment': 'ادائیگی منسوخ کریں',
    'noOrderDetailsFound': 'آرڈر کی تفصیلات نہیں ملیں',
    'retry': 'دوبارہ کوشش کریں',
    'orderPlacedSuccessfully': 'آرڈر کامیابی سے دیا گیا! تفصیلات کے لیے اپنے آرڈرز چیک کریں۔',
    'payment_successful': 'ادائیگی کامیاب ہوگئی',
    'payment_failed': 'ادائیگی ناکام ہوگئی',
    'payment_cancelled': 'ادائیگی منسوخ کر دی گئی',
    'payment_link_error': 'ادائیگی کا لنک بنانے میں ناکام',
    'vendorAccountUnderReview': 'آپ کا وینڈر اکاؤنٹ جائزے میں ہے اور منظوری کا منتظر ہے۔',
    'content': 'مواد',
    AppStrings.brands: 'برانڈز',
    AppStrings.celebrities: 'مشہور شخصیات',
    AppStrings.categories: 'زمرے',
    AppStrings.account: 'اکاؤنٹ',
    'pleaseSelectRequiredOptions': 'براہ کرم تمام ضروری اختیارات منتخب کریں',
    'dismiss': 'ختم کریں',
    'Bazzar': 'بازار',
    'state': 'صوبہ',
    'stateIsRequired': 'صوبہ ضروری ہے',
    'cityIsRequired': 'شہر ضروری ہے',
    'selectState': 'صوبہ منتخب کریں',
    'selectCity': 'شہر منتخب کریں',
    'unknownState': 'نامعلوم صوبہ',
// Core App Strings (Urdu translations)
    AppStrings.darkMode: 'ڈارک موڈ',
    AppStrings.giftsByOccasion: 'موقع کے مطابق تحائف',
    AppStrings.changeLanguage: 'زبان تبدیل کریں',
    AppStrings.welcomeMessage: 'ہماری ایپ میں خوش آمدید!',
    AppStrings.loginSignUp: 'لاگ ان/سائن اپ',
    AppStrings.cart: 'کارٹ',
    AppStrings.changePassword: 'پاس ورڈ تبدیل کریں',
    AppStrings.redeemCard: 'گفٹ کارڈ ریڈیم کریں',
    AppStrings.joinAsSeller: 'فروش کے طور پر شامل ہوں',
    AppStrings.joinUsSeller: 'ہمارے ساتھ فروش کے طور پر شامل ہوں',
    AppStrings.privacyPolicy: 'رازداری کی پالیسی',
    AppStrings.aboutUs: 'ہمارے بارے میں',
    AppStrings.location: 'مقام',
    AppStrings.helpAndSupport: 'مدد اور سپورٹ',
    AppStrings.signUp: 'سائن اپ',
    AppStrings.signIn: 'سائن ان',
    AppStrings.description: 'تفصیل',
    AppStrings.termsAndConditions: 'شرائط و ضوابط',
    AppStrings.buyAndRedeem: 'خریدیں اور ریڈیم کریں',
    AppStrings.vendor: 'فروش ڈیش بورڈ',
    AppStrings.vendorAgreement: 'فروش معاہدہ',

// Descriptions (Urdu)
    AppStrings.descriptionGiftCard:
        'مکمل تحفہ تلاش کر رہے ہیں؟ Events ای-گفٹ کارڈز یہاں ہیں جو تحفہ دینا آسان بناتے ہیں۔ ہمارا ای-تحفہ آپ کے پیاروں کو وہی دینے کا سب سے آسان اور آسان طریقہ ہے جو وہ چاہتے ہیں۔ اسے ایک مخلص پیغام کے ساتھ ذاتی بنائیں اور باقی ہم پر چھوڑ دیں۔',
    AppStrings.termsAndConditionsText:
        'ای-گفٹ کارڈز کو ہماری ویب سائٹ یا موبائل ایپ پر کریڈٹ کے لیے ریڈیم کیا جا سکتا ہے۔ ای-گفٹ کارڈ خریداری کی تاریخ سے ایک سال تک درست ہے۔ ہمارے ای-گفٹ کارڈز خریدنے کے لیے کوئی اضافی فیس یا لاگت نہیں ہے۔ تاہم، ایک بار خریدنے کے بعد وہ منسوخ یا واپس نہیں کیے جا سکتے۔ براہ کرم تمام وصول کنندہ کی معلومات کی درستگی کو یقینی بنائیں، کیونکہ ہم غلط طریقے سے بھیجے گئے ای-گفٹ کارڈ کوڈ کے ریڈیم یا تبدیلی کے لیے ذمہ دار نہیں ہوں گے۔',
    AppStrings.redeemFirstLine: 'پہلے سے لوڈ شدہ رقم منتخب کریں یا کسٹم رقم درج کریں',
    AppStrings.redeemSecondLine: 'وصول کنندہ کا نام اور ای میل پتہ فراہم کریں',
    AppStrings.redeemThirdLine: 'لین دین کے بعد، وصول کنندہ کو ای میل کے ذریعے ای-گفٹ کارڈ کوڈ ملے گا',
    AppStrings.redeemForthLine: 'وصول کنندہ لنک پر کلک کر کے اور کوڈ درج کر کے تحفہ کی رقم ریڈیم کر سکتا ہے',
    AppStrings.redeemFifthLine: 'ایک بار ریڈیم ہونے کے بعد، رقم وصول کنندہ کے Events بیلنس میں شامل کر دی جائے گی',

// Cart & Shopping (Urdu)
    AppStrings.myCart: 'میری کارٹ',
    AppStrings.back: 'واپس',
    AppStrings.totalColon: 'کل: ',
    AppStrings.profile: 'پروفائل',
    AppStrings.shippingFees: '(شپنگ فیس شامل نہیں)',
    AppStrings.proceedToCheckOut: 'چیک آؤٹ کے لیے آگے بڑھیں',
    AppStrings.addToCart: 'کارٹ میں شامل کریں',
    AppStrings.subTotalColon: 'ذیلی کل: ',
    AppStrings.taxColon: 'ٹیکس: ',
    AppStrings.couponCodeText: 'کوپن کوڈ',
    AppStrings.couponCodeAmount: 'کوپن کوڈ ڈسکاؤنٹ رقم: ',
    AppStrings.shippingFee: 'شپنگ فیس',
    AppStrings.switchLanguage: 'زبان تبدیل کریں',
    AppStrings.wishList: 'خواہشات کی فہرست',
    AppStrings.emptyWishList: 'آپ کی خواہشات کی فہرست خالی ہے!',
    AppStrings.viewAll: 'سب دیکھیں',
    AppStrings.quantity: 'مقدار:',
    AppStrings.percentOff: '% ڈسکاؤنٹ',
    AppStrings.off: 'ڈسکاؤنٹ',
    AppStrings.gotoWishlist: 'خواہشات کی فہرست پر جائیں',
    AppStrings.continueShopping: 'خریداری جاری رکھیں',
    AppStrings.cartIsEmpty: 'کارٹ خالی ہے\nاپنی کارٹ میں شامل کرنا شروع کریں',
    AppStrings.aed: 'درہم',
// About Us (Urdu)
    AppStrings.aboutUsEvents:
        'دی ایونٹس میں، ہم یقین رکھتے ہیں کہ ہر موقع کو خوبصورت انداز میں منایا جانا چاہیے۔ متحدہ عرب امارات میں قائم ہونے کے بعد، ہمارا پلیٹ فارم خطے کے سرکردہ آن لائن مارکیٹ پلیسز میں سے ایک بن گیا ہے جو تقریبات، تحائف اور لائف اسٹائل تجربات کے لیے جانا جاتا ہے۔ ہم اپنے صارفین کو قابل اعتماد بیچنے والوں، برانڈز اور سروس فراہم کرنے والوں کی ایک وسیع رینج سے جوڑتے ہیں — پھولوں اور اعلیٰ معیار کے تحائف سے لے کر لگژری مصنوعات، تجربات اور ایونٹ کی ضروریات تک — سب کچھ ایک ہی ڈیجیٹل اسپیس میں۔ ہمارا مشن سادہ ہے: دریافت، بکنگ اور تحفہ دینا آسان بنانا۔ جدید ترین ٹیکنالوجی کو مقامی ثقافت اور عالمی رجحانات کی گہری سمجھ کے ساتھ ملا کر، ہم اس بات کو یقینی بناتے ہیں کہ ہر آرڈر کو دیکھ بھال، معیار اور بھروسے کے ساتھ پہنچایا جائے۔ اپنی ترقی کے وژن کے تحت، ہم متحدہ عرب امارات سے آگے بڑھ کر پورے جی سی سی خطے کو شامل کرنے کے لیے توسیع کر رہے ہیں، تاکہ پورے عرب خلیج کے صارفین تک اپنی جدید مارکیٹ پلیس اور اعلیٰ خدمات پہنچا سکیں۔ دی ایونٹس میں، ہم صرف ایک مارکیٹ پلیس نہیں ہیں — ہم آپ کے ساتھی ہیں، یادگار لمحات بنانے میں جو عمر بھر قائم رہیں۔',
    AppStrings.ourMissionText:
        'دی ایونٹس میں، ہمارا مشن یہ ہے کہ ہم لوگوں کے جشن منانے اور ایک دوسرے سے جڑنے کے طریقے کو آسان بنائیں۔ ہم ایک ایسا جدید ڈیجیٹل مارکیٹ پلیس فراہم کرنے کی کوشش کرتے ہیں جو قابل اعتماد بیچنے والوں، معیاری مصنوعات اور شاندار خدمات کو یکجا کرے — تاکہ ہر موقع کو منصوبہ بندی کرنا آسان، تجربہ خوشگوار اور یادگار بنایا جا سکے۔',
    AppStrings.ourVisionText:
        'ہمارا وژن یہ ہے کہ ہم پورے جی سی سی میں تقریبات، تحائف اور لائف اسٹائل تجربات کے لیے ایک سرکردہ آن لائن منزل بنیں۔ جدت، قابل اعتماد ہونے اور ثقافتی اصلیت کو یکجا کر کے، ہم لاکھوں صارفین اور شراکت داروں کو زندگی کے لمحات کو خوبصورتی اور انداز کے ساتھ منانے کے لیے متاثر کرنا چاہتے ہیں۔',
    AppStrings.ourMission: 'ہمارا مشن',
    AppStrings.ourVision: 'ہمارا ویژن',
    AppStrings.ourValues: 'ہماری اقدار',
    AppStrings.ourLocation: 'ہم کور کر رہے ہیں',
    AppStrings.vendorHeading:
        'اپنے گاہکوں اور شراکت داروں کو ٹریک کرنے کے لیے ایک اکاؤنٹ بنائیں۔ اکاؤنٹ بنانے کے بعد، ہم آپ کو ای میل کے ذریعے تصدیق بھیجیں گے۔',
    AppStrings.vendorContactHeading:
        'معاہدے کا جائزہ لیں اور تمام معلومات کی درستگی کو یقینی بنائیں۔ پھر ادائیگی کے لیے آگے بڑھیں۔',
    AppStrings.who: 'ہم',
    AppStrings.weAre: 'کون ہیں',
    AppStrings.our: 'ہمارا',
    AppStrings.mission: 'مشن',
    AppStrings.vision: 'ویژن',
    AppStrings.values: 'اقدار',
    AppStrings.simplicity: 'سادگی',
    AppStrings.innovation: 'جدت',
    AppStrings.thoughtfulness: 'غور و فکر',
    AppStrings.reliability: 'قابل اعتمادی',

// Vendor (Urdu)
    AppStrings.agreementAccept: 'میں شرائط و ضوابط سے متفق ہوں',
    AppStrings.registrationDone: 'رجسٹریشن کامیابی سے مکمل ہوئی!\nاب آپ ادائیگی کے لیے آگے بڑھ سکتے ہیں۔',
    AppStrings.paymentDone: 'ادائیگی کامیابی سے ہوئی!',
    AppStrings.paymentThanks: 'ادائیگی مکمل کرنے کے لیے شکریہ۔',

// Countries (Urdu)
    AppStrings.unitedArabEmirates: 'متحدہ عرب امارات',
    AppStrings.saudiArabia: 'سعودی عرب',
    AppStrings.bahrain: 'بحرین',
    AppStrings.kuwait: 'کویت',
    AppStrings.oman: 'عمان',
    AppStrings.qatar: 'قطر',
    AppStrings.countryIsRequired: 'ملک درج کرنا ضروری ہے',

// Authentication (Urdu)
    AppStrings.forgetPassword: 'پاس ورڈ بھول گئے؟',
    AppStrings.doNotHaveAccountYet: 'ابھی تک اکاؤنٹ نہیں ہے؟',
    AppStrings.createOneNow: 'ابھی بنائیں',
    AppStrings.send: 'بھیجیں',
    AppStrings.emailAddress: 'ای میل پتہ',
    AppStrings.emailRequired: 'ای میل درکار ہے',
    AppStrings.login: 'لاگ ان',
    AppStrings.enterYourEmail: 'اپنا ای میل درج کریں',
    AppStrings.passRequired: 'پاس ورڈ درکار ہے',
    AppStrings.enterYourPassword: 'اپنا پاس ورڈ درج کریں',
    AppStrings.continueo: 'جاری رکھیں',
    AppStrings.getHelp: 'مدد حاصل کریں',
    AppStrings.haveTroubleLogging: 'لاگ ان میں مسئلہ آ رہا ہے؟',
    AppStrings.fullName: 'پورا نام',
    AppStrings.confirmPassword: 'پاس ورڈ کی تصدیق کریں',
    AppStrings.passwordValidation: 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے۔',
    AppStrings.agreement: 'معاہدہ',
    AppStrings.terms: 'شرائط',
    AppStrings.searchEvents: 'ایونٹس تلاش کریں',
    AppStrings.notification: 'نوٹیفیکیشنز',
    AppStrings.confirmLogout: 'لاگ آؤٹ کی تصدیق کریں',
    AppStrings.confirmLogoutMessage: 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟',
    AppStrings.logout: 'لاگ آؤٹ',

// Profile & Account (Urdu)
    AppStrings.address: 'پتہ',
    AppStrings.giftCards: 'گفٹ کارڈز',
    AppStrings.reviews: 'جائزے',
    AppStrings.orders: 'آرڈرز',
    AppStrings.myAccount: 'میرا اکاؤنٹ',
    AppStrings.enterCurrentPassword: 'موجودہ پاس ورڈ درج کریں',
    AppStrings.currentPasswordCannotBeEmpty: 'موجودہ پاس ورڈ خالی نہیں ہو سکتا',
    AppStrings.currentPassword: 'موجودہ پاس ورڈ',
    AppStrings.enterChangePassword: 'نیا پاس ورڈ درج کریں',
    AppStrings.enterReEnterPassword: 'نیا پاس ورڈ دوبارہ درج کریں',
    AppStrings.reEnterPassword: 'پاس ورڈ دوبارہ درج کریں',
    AppStrings.update: 'اپڈیٹ',
    AppStrings.pleaseEnterFields: 'براہ کرم تمام فیلڈز درج کریں',
    AppStrings.noRecord: 'کوئی ریکارڈ نہیں',
    AppStrings.edit: 'ترمیم کریں',
    AppStrings.phone: 'فون',
    AppStrings.email: 'ای میل',
    AppStrings.name: 'نام',
    AppStrings.defaultAddress: 'ڈیفالٹ پتہ',
    AppStrings.create: 'بنائیں',
    AppStrings.unknownCountry: 'نامعلوم ملک',
    AppStrings.pleaseCheckFields: 'براہ کرم فیلڈز چیک کریں',
    AppStrings.addressSaved: 'پتہ محفوظ ہو گیا',
    AppStrings.save: 'محفوظ کریں',
    AppStrings.useDefaultAddress: 'اس پتے کو ڈیفالٹ کے طور پر استعمال کریں',
    AppStrings.cityCannotBeEmpty: 'شہر خالی نہیں ہو سکتا',
    AppStrings.city: 'شہر',
    AppStrings.enterCity: 'شہر درج کریں',
    AppStrings.stateCannotBeEmpty: 'ریاست خالی نہیں ہو سکتی',
    AppStrings.enterState: 'ریاست درج کریں',
    AppStrings.pleaseSelectCountry: 'براہ کرم ملک منتخب کریں',
    AppStrings.country: 'ملک',
    AppStrings.enterCountry: 'ملک درج کریں',
    AppStrings.enterAddress: 'پتہ درج کریں',
    AppStrings.enterEmailAddress: 'ای میل پتہ درج کریں',
    AppStrings.enterPhoneNumber: 'فون نمبر درج کریں',
    AppStrings.enterName: 'نام درج کریں',
    AppStrings.enterYourName: 'اپنا نام درج کریں',
    AppStrings.reviewed: 'جائزہ لیا گیا',
    AppStrings.waitingForReview: 'جائزے کا انتظار',
    AppStrings.nameCannotBeEmpty: 'نام خالی نہیں ہو سکتا',
    AppStrings.phoneCannotBeEmpty: 'فون نمبر خالی نہیں ہو سکتا',
    AppStrings.pleaseFillAllFields: 'براہ کرم تمام فیلڈز بھریں',
    AppStrings.emailCannotBeEmpty: 'ای میل خالی نہیں ہو سکتا',
    AppStrings.deleteMyAccount: 'میرا اکاؤنٹ حذف کریں',
    AppStrings.deleteAccount: 'اکاؤنٹ حذف کریں',
    AppStrings.delete: 'حذف کریں',
    AppStrings.deleteAccountWarning:
        'کیا آپ واقعی اپنا اکاؤنٹ حذف کرنا چاہتے ہیں؟ آپ اپنا ڈیٹا دوبارہ حاصل نہیں کر سکیں گے۔',
    AppStrings.addressCannotBeEmpty: 'پتہ خالی نہیں ہو سکتا',

// Reviews (Urdu)
    AppStrings.noProductsAvailable: 'جائزے کے لیے کوئی مصنوعات دستیاب نہیں',
    AppStrings.uploadPhotos: 'تصاویر اپ لوڈ کریں',
    AppStrings.uploadPhotosMessage: 'زیادہ سے زیادہ 5 تصاویر',
    AppStrings.submitReview: 'جائزہ جمع کریں',
    AppStrings.errorSubmittingReview: 'جائزہ جمع کرنے میں خرابی',
    AppStrings.review: 'جائزہ',
    AppStrings.failedToAddPhotos: 'تصاویر شامل کرنے میں ناکام',
    AppStrings.maxFilesError: 'منتخب کرنے کے لیے زیادہ سے زیادہ فائلوں کی تعداد 5 ہے۔',
    AppStrings.noReviews: 'ابھی تک کوئی جائزہ نہیں',
    AppStrings.customerReviews: 'گاہک کے جائزے',
    AppStrings.reviewSeller: 'فروش کا جائزہ',
    AppStrings.reviewProduct: 'مصنوعات کا جائزہ',
    AppStrings.ratings: 'ریٹنگز',
    AppStrings.star: 'ستارہ',
    AppStrings.stars: 'ستارے',

// Coupons (Urdu)
    AppStrings.couponAppliedSuccess: 'کوپن کامیابی سے لاگو کیا گیا!',
    AppStrings.couponRemovedSuccess: 'کوپن کامیابی سے ہٹایا گیا!',
    AppStrings.couponInvalidOrExpired: 'کوپن غلط یا ختم ہو گیا ہے۔',
    AppStrings.couponLabel: 'کوپن کوڈ درج کریں',
    AppStrings.couponHint: 'کوپن کوڈ',

// Checkout & Payment (Urdu)
    AppStrings.continueToPayment: 'ادائیگی کے لیے جاری رکھیں',
    AppStrings.currencyAED: 'متحدہ عرب امارات درہم',
    AppStrings.acceptTermsAndConditions: 'میں شرائط و ضوابط کو قبول کرتا ہوں',
    AppStrings.readOurTermsAndConditions: 'ہماری شرائط و ضوابط پڑھیں',
    AppStrings.mustAcceptTerms: 'جاری رکھنے کے لیے آپ کو شرائط و ضوابط کو قبول کرنا ہوگا',
    AppStrings.confirmAndSubmitOrder: 'آرڈر کی تصدیق اور جمع کریں',
    AppStrings.byClickingSubmit: '"تصدیق اور جمع آرڈر" پر کلک کر کے، آپ متفق ہوتے ہیں',
    AppStrings.and: 'اور',

// Urdu VendorAppStrings translations
    VendorAppStrings.titleGender: 'جنس',
    VendorAppStrings.hintEnterEmail: 'ای میل درج کریں',
    VendorAppStrings.hintEnterFullName: 'پورا نام درج کریں',
    VendorAppStrings.hintSelectGender: 'اپنی جنس منتخب کریں',
    VendorAppStrings.errorEmailRequired: 'ای میل درکار ہے',
    VendorAppStrings.errorValidEmail: 'ایک درست ای میل درج کریں',
    VendorAppStrings.asterick: ' *',
    VendorAppStrings.home: 'ہوم',
    VendorAppStrings.shop: 'دکان',
    VendorAppStrings.dashboard: 'ڈیش بورڈ',
    VendorAppStrings.orderReturns: 'آرڈر ریٹرنز',
    VendorAppStrings.withdrawals: 'نکاسی',
    VendorAppStrings.revenues: 'آمدنی',
    VendorAppStrings.settings: 'ترتیبات',
    VendorAppStrings.logoutFromVendor: 'فروش سے لاگ آؤٹ',
    VendorAppStrings.saveAndContinue: 'محفوظ کریں اور جاری رکھیں',
    VendorAppStrings.previewAgreement: 'معاہدے کا پیش نظارہ',
    VendorAppStrings.downloadAgreement: 'معاہدہ ڈاؤن لوڈ کریں',
// Common Actions (Urdu)
    AppStrings.cancel: 'رئیسی',
    AppStrings.yes: 'ہاں',
    AppStrings.no: 'نہیں',
    AppStrings.loading: 'لوڈ ہو رہا ہے...',
    AppStrings.error: 'خرابی: ',
    AppStrings.confirmation: 'تصدیق',
    AppStrings.cancelOrderConfirmationMessage: 'کیا آپ واقعی جاری رکھنا چاہتے ہیں؟',
    AppStrings.allow: 'اجازت دیں',
    AppStrings.pending: 'زیر التوا',
    AppStrings.completed: 'مکمل',
    AppStrings.purchased: 'خریدا گیا',
    AppStrings.noDataAvailable: 'کوئی ڈیٹا دستیاب نہیں',

// Screen Titles
    VendorAppStrings.bankDetails: 'بینک کی تفصیلات',
    VendorAppStrings.loginInformation: 'لاگ ان کی معلومات',
    VendorAppStrings.businessOwnerInformation: 'کاروبار کے مالک کی معلومات',
    VendorAppStrings.emailVerificationPending: 'ای میل کی تصدیق زیر التوا!',
    VendorAppStrings.pleaseVerifyEmail: 'براہ کرم اپنا ای میل پتہ تصدیق کریں! اور تصدیق پر ٹیپ کریں۔',
    VendorAppStrings.checkInboxSpam: 'ای میل پتے کی تصدیق کے لیے براہ کرم اپنا ان باکس اور اسپام فولڈر چیک کریں!',
    VendorAppStrings.accountVerified: 'اکاؤنٹ تصدیق شدہ ہے۔',
    VendorAppStrings.emailVerificationPendingStatus: 'ای میل کی تصدیق زیر التوا ہے۔',
    VendorAppStrings.verify: 'تصدیق کریں',
    VendorAppStrings.resend: 'دوبارہ بھیجیں',
// Additional Screen Titles
    VendorAppStrings.authorizedSignatoryInformation: 'مجاز دستخط کنندہ کی معلومات',
    VendorAppStrings.companyInformation: 'کمپنی کی معلومات',
    VendorAppStrings.contractAgreement: 'معاہدہ معاہدہ',
    VendorAppStrings.pleaseSignHere: 'براہ کرم یہاں دستخط کریں *',
    VendorAppStrings.clear: 'صاف کریں',
    VendorAppStrings.pleaseSignAgreement: 'براہ کرم اس معاہدے پر دستخط کریں',
    VendorAppStrings.youMustAgreeToProceed: 'آپ کو آگے بڑھنے کے لیے رضامند ہونا ہوگا',

// Additional Form Labels
    VendorAppStrings.poaMoaPdf: 'پاور آف اٹارنی / میمورنڈم آف ایگریمنٹ (pdf)',
    VendorAppStrings.uploadCompanyLogo: 'کمپنی کا لوگو اپ لوڈ کریں',
    VendorAppStrings.companyCategoryType: 'کمپنی کیٹیگری کی قسم',
    VendorAppStrings.phoneNumberLandline: 'فون نمبر (لینڈ لائن)',
    VendorAppStrings.tradeLicenseNumber: 'تجارتی لائسنس نمبر',
    VendorAppStrings.uploadTradeLicensePdf: 'تجارتی لائسنس اپ لوڈ کریں (pdf)',
    VendorAppStrings.tradeLicenseNumberExpiryDate: 'تجارتی لائسنس کی میعاد ختم ہونے کی تاریخ',
    VendorAppStrings.nocPoaIfApplicablePdf: 'NOC/POA سرٹیفکیٹ (اگر لاگو ہو - pdf)',
    VendorAppStrings.vatCertificateIfApplicablePdf: 'ویلیو ایڈڈ ٹیکس سرٹیفکیٹ (اگر لاگو ہو - pdf)',
    VendorAppStrings.companyStamp: 'کمپنی کی مہر (500*500)',

// Additional Form Hints
    VendorAppStrings.enterCompanyName: 'کمپنی کا نام درج کریں',
    VendorAppStrings.enterMobileNumber: 'موبائل نمبر درج کریں',
    VendorAppStrings.enterTradeLicenseNumber: 'تجارتی لائسنس نمبر درج کریں',
    VendorAppStrings.enterCompanyAddress: 'کمپنی کا پتہ درج کریں',
    VendorAppStrings.enterTradeLicenseExpiryDate: 'yyyy-MM-dd',

// Additional Dropdown Options
    VendorAppStrings.selectCcType: 'براہ کرم کریڈٹ کارڈ کی قسم منتخب کریں',
    VendorAppStrings.selectCountry: 'براہ کرم ملک منتخب کریں',
    VendorAppStrings.selectRegion: 'براہ کرم علاقہ منتخب کریں',

// Payment and Subscription
    VendorAppStrings.payment: 'ادائیگی',
    VendorAppStrings.nowAed: 'اب AED',
    VendorAppStrings.youWillBeRedirectedToTelrTabby: 'آپ کو ادائیگی مکمل کرنے کے لیے Telr پر منتقل کیا جائے گا',
    VendorAppStrings.paymentFailure: 'ادائیگی ناکام',
    VendorAppStrings.congratulations: 'مبارک ہو!',

// Company Information
    VendorAppStrings.companyName: 'کمپنی کا نام',
    VendorAppStrings.companyEmail: 'کمپنی کا ای میل',
    VendorAppStrings.mobileNumber: 'موبائل نمبر',
    VendorAppStrings.companyAddress: 'کمپنی کا پتہ',
    VendorAppStrings.region: 'علاقہ',

// Form Hints
    VendorAppStrings.noFileChosen: 'کوئی فائل منتخب نہیں',
    VendorAppStrings.enterCompanyEmail: 'کمپنی کا ای میل درج کریں',
  },
};
