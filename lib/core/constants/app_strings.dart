import '../helper/enums/enums.dart';

class AppStrings {
  static const String welcomeMessage = 'Welcome to our app!';
  static const String loginSignUp = 'Login/SignUp';
  static const String cart = 'Cart';
  static const String changePassword = 'Change Password';
  static const String redeemCard = 'Redeem Gift Card';
  static const String joinAsSeller = 'Join As Seller';
  static const String joinUsSeller = 'Join Us As Seller';
  static const String privacyPolicy = 'Privacy Policy';
  static const String aboutUs = 'About Us';
  static const String location = 'Location';
  static const String helpAndSupport = 'Help And Support';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String description = 'Description';
  static const String buyAndRedeem = 'Buy & Redeem ';
  static const String vendor = 'Vendor Dashboard';
  static const String vendorAgreement = 'Vendor Agreement';
  static const String descriptionGiftCard =
      'Looking for the perfect gift? The Events eGift Cards are here to make gifting a breeze. Our eGift is the easiest and most convenient way to give your loved ones exactly what they want. Customize it with a heartfelt message and leave the rest to us.';
  static const String termsAndConditionsText =
      'eGift Cards can be redeemed for credit on our website or mobile app. The eGift card is valid for 1 year from the date of purchase. There are no additional charges or fees for purchasing our eGift Cards. However, they are noncancellable and non-refundable once bought. Please ensure that all recipient information is accurate, as we will not be responsible for refunding or replacing a misdirected eGift Card code.';
  static const String redeemFirstLine = 'Pick a preset load amount or enter a custom one';
  static const String redeemSecondLine = "Provide the recipient's name and email";
  static const String redeemThirdLine =
      'After the transaction, the recipient will receive their eGift Card Code via EMAIL';
  static const String redeemForthLine =
      'The recipient can redeem the gift amount by clicking on the link and entering the code';
  static const String redeemFifthLine = "Once redeemed, the amount will be added to the recipient's The Events Credit";
  static const String myCart = 'My Cart';
  static const String back = 'Back';
  static const String totalColon = 'Total:  ';
  static const String profile = 'Profile';
  static const String shippingFees = '(Shipping fees not included)';
  static const String proceedToCheckOut = 'Proceed to checkout';
  static const String addToCart = 'Add to cart';
  static const String subTotalColon = 'Subtotal:  ';
  static const String taxColon = 'Tax:  ';
  static const String couponCodeText = 'Coupon code: ';
  static const String couponCodeAmount = 'Coupon code discount amount: ';
  static const String shippingFee = 'Shipping fee';
  static const String switchLanguage = 'Switch Language';
  static const String wishList = 'WishList';
  static const String emptyWishList = 'Your WishList is Empty!';
  static const String viewAll = 'View All';

  static const String aboutUsEvents =
      'At The Events, we believe every occasion deserves to be celebrated in style. Founded in the United Arab Emirates, our platform has grown into one of the region’s leading online marketplaces for events, gifts, and lifestyle experiences. We connect customers with a wide range of trusted sellers, brands, and service providers—from flowers and gourmet gifts to luxury products, experiences, and event essentials—all in one seamless digital space. Our mission is simple: to make discovering, booking, and gifting effortless. By combining cutting-edge technology with a deep understanding of local culture and international trends, we ensure that every order is delivered with care, quality, and reliability. As part of our growth vision, we are expanding beyond the UAE with a clear ambition to cover the entire GCC region, bringing our innovative marketplace and premium services to customers across the Arabian Gulf. At The Events, we are not just a marketplace—we are your partner in creating memorable moments that last a lifetime.';
  static const String ourMissionText =
      'At The Events, our mission is to simplify the way people celebrate and connect. We strive to provide a seamless digital marketplace that brings together trusted sellers, premium products, and exceptional services—making every occasion easier to plan, more enjoyable to experience, and unforgettable to remember.';
  static const String ourVisionText =
      'Our vision is to become the leading online destination for events, gifts, and lifestyle experiences across the GCC. By combining innovation, reliability, and cultural authenticity, we aim to inspire millions of customers and partners to celebrate life’s moments in style.';
  static const String vendorHeading =
      'Create an account to keep track of your customers, and contributors. Once your account has been created we\'ll send you a confirmation through mail.';
  static const String vendorContactHeading =
      'Preview the agreement and make sure all the information is accurate. then continue to the payment.';
  static const String agreementAccept = 'I hereby agree to the terms and conditions of this agreement.';
  static const String registrationDone = 'Your vendor registration has been successfully completed';
  static const String paymentDone =
      'Our team is reviewing your documents. You\'ll get a notification about your vendor approval status soon. Once approved, we\'ll email you the contract for your signature';
  static const String paymentThanks =
      'Thank you for choosing to partner with us. We look forward to a successful collaboration';

  static bool isLoggedIn = false;

  ///   APP TOP BAR ICONS
  static const String firstRightIconPath = 'assets/notify.svg';
  static const String secondRightIconPath = 'assets/bottomLike.svg';
  static const String thirdRightIconPath = 'assets/bottomCart.svg';
  static const String appLogo = 'assets/applogo.svg';
  static const String itemAddToCart = 'assets/addToCart.svg';
  static const String outOfStock = 'assets/out_of_stock.svg';
  static const String privacyPolicyIcon = 'assets/policy.svg';
  static const String userFill = 'assets/account_profile.svg';
  static const String emailIcon = 'assets/login/emailIcon.svg';
  static const String passwordIcon = 'assets/login/passwordLock.svg';
  static const String profileName = 'assets/login/profileName.svg';
  static const String showEye = 'assets/login/showEye.svg';
  static const String hideEye = 'assets/login/hideEye.svg';

  // Add more strings as needed
  static const String removeWishlistTitle = 'Remove Wishlist';
  static const String removeWishlistMessage = 'Are you sure you want to remove from wishlist?';
  static const String cancel = 'Cancel';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String soldBy = 'Sold By';
  static const String loading = 'Loading';
  static const String tags = 'Tags';
  static const String prices = 'Prices';
  static const String colors = 'Colors';

  static final productSearchFiltersStrings = {
    ProductFilter.categories: categories,
    ProductFilter.brands: brands,
    ProductFilter.tags: tags,
    ProductFilter.prices: prices,
    ProductFilter.colors: colors,
  };

  // Section Titles
  static const String who = 'WHO';
  static const String weAre = ' WE ARE';
  static const String our = 'OUR';
  static const String mission = ' MISSION';
  static const String vision = ' VISION';

  static const String ourMission = 'OUR MISSION';
  static const String ourVision = 'OUR VISION';
  static const String ourValues = 'OUR VALUES';
  static const String ourLocation = 'WE ARE COVERING';

  // Our Values
  static const String values = 'VALUES';
  static const String simplicity = 'Simplicity';
  static const String innovation = 'Innovation';
  static const String thoughtfulness = 'Thoughtfulness';
  static const String reliability = 'Reliability';

  // Countries
  static const String unitedArabEmirates = 'United Arab Emirates';
  static const String saudiArabia = 'Saudi Arabia';
  static const String bahrain = 'Bahrain';
  static const String kuwait = 'Kuwait';
  static const String oman = 'Oman';
  static const String qatar = 'Qatar';

  // Auth
  static const String forgetPassword = 'Forgot Password?';
  static const String doNotHaveAccountYet = 'Do not have account yet?  ';
  static const String createOneNow = 'Create one now';
  static const String send = 'Send';
  static const String emailAddress = 'Email Address';
  static const String emailRequired = 'Please enter your email';
  static const String login = 'login';
  static const String enterYourEmail = 'Enter your Email';
  static const String passRequired = 'Password is required.';
  static const String enterYourPassword = 'Enter your Password';
  static const String continueo = 'Continue';
  static const String getHelp = 'getHelp';
  static const String haveTroubleLogging = 'Have trouble logging in? ';
  static const String fullName = 'Full Name';
  static const String confirmPassword = 'Confirm Password';
  static const String passwordValidation =
      'Password must Contain minimum 9 characters , at least one upper case and one is lower case ';
  static const String agreement = 'By continuing,I agree the ';
  static const String terms = 'Terms of Use';
  static const String searchEvents = 'Search Events';
  static const String termsAndConditions = 'Terms & Conditions';
  static const String notification = 'Notification';
  static const String confirmLogout = 'Confirm Logout';
  static const String confirmLogoutMessage = 'Are you sure you want to log out?';
  static const String logout = 'Logout';
  static const String address = 'Address';
  static const String giftCards = 'Gift Cards';
  static const String reviews = 'Reviews';
  static const String orders = 'Orders';
  static const String myAccount = 'My Account';
  static const String enterCurrentPassword = 'Enter Current Password';
  static const String currentPasswordCannotBeEmpty = 'Current Password cannot be empty.';
  static const String currentPassword = 'Current Password';
  static const String enterChangePassword = 'Enter Change Password';
  static const String enterReEnterPassword = 'Enter Re-Enter Password';
  static const String reEnterPassword = 'Re-Enter Password';
  static const String update = 'Update';
  static const String pleaseEnterFields = 'Please enter Fields';
  static const String noRecord = 'No record found!';
  static const String edit = 'Edit';
  static const String phone = 'Phone';
  static const String email = 'Email';
  static const String name = 'Name';
  static const String defaultAddress = 'Default Address';
  static const String create = 'Create';
  static const String unknownCountry = 'Unknown Country';
  static const String pleaseCheckFields = 'Please Check Fields';
  static const String addressSaved = 'Address saved successfully!';
  static const String save = 'Save';
  static const String useDefaultAddress = 'Use this default address';
  static const String cityCannotBeEmpty = 'City cannot be empty.';
  static const String city = 'City';
  static const String enterCity = 'Enter City';
  static const String stateCannotBeEmpty = 'State cannot be empty.';
  static const String state = 'state';
  static const String stateIsRequired = 'stateIsRequired';
  static const String cityIsRequired = 'cityIsRequired';
  static const String selectState = 'selectState';
  static const String selectCity = 'selectCity';
  static const String unknownState = 'unknownState';
  static const String enterState = 'Enter State';
  static const String pleaseSelectCountry = 'Please select country.';
  static const String country = 'Country';
  static const String enterCountry = 'Enter Country';
  static const String enterAddress = 'Enter address';
  static const String enterEmailAddress = 'Enter Email address';
  static const String enterPhoneNumber = 'Enter phone Number';
  static const String enterName = 'Enter Name';
  static const String enterYourName = 'Enter your name';
  static const String reviewed = 'Reviewed';
  static const String waitingForReview = 'Waiting For Review';
  static const String nameCannotBeEmpty = 'Name cannot be empty.';
  static const String phoneCannotBeEmpty = 'Phone cannot be empty.';
  static const String pleaseFillAllFields = 'Please fill all fields';
  static const String emailCannotBeEmpty = 'Email cannot be empty.';
  static const String deleteMyAccount = 'Delete My Account';
  static const String deleteAccount = 'Delete Account';
  static const String delete = 'Delete';
  static const String deleteAccountWarning =
      'Are you sure you want to delete your account? This action cannot be undone.';
  static const String noProductsAvailable = 'You do not have any products to review yet. Just shopping!';
  static const String uploadPhotos = 'Upload Photos';
  static const String uploadPhotosMessage = 'You can upload up to 6 photos, each photo max size is 2MB.';
  static const String submitReview = 'Submit Review';
  static const String errorSubmittingReview = 'Error while submitting review:';
  static const String review = 'Review';
  static const String failedToAddPhotos = 'Failed to Add Photos';

  /// TODO: Keep this string in both English and Arabic translations with the 'maxCount' placeholder unchanged
  static const String maxFilesError = 'You can only select a maximum of maxCount files';
  static const String noReviews = 'You have not reviewed any product.';

  // Cart related messages
  static const String quantity = 'Quantity:';
  static const String percentOff = '%off';
  static const String off = 'off';
  static const String gotoWishlist = 'Go To Wishlist';
  static const String continueShopping = 'Continue Shopping';
  static const String cartIsEmpty = 'Cart Is Empty \n Start adding to your cart ';
  static const String aed = 'AED';
  static const String ordersCancelled = 'Orders Cancelled';
  static const String oneItemCancelled = '1 Item is Cancelled';
  static const String perfume = 'Perfume';
  static const String productDescription = 'Product Description';
  static const String refundDetails = 'Refund Details';
  static const String refundNotApplicable = 'A refund is not applicable on this order as it is a Pay on delivery order';
  static const String refund = 'Refund';

  // Coupon related messages
  static const String couponAppliedSuccess = 'Coupon applied successfully!';
  static const String couponRemovedSuccess = 'Coupon removed successfully!';
  static const String couponInvalidOrExpired = 'This coupon is invalid or expired!';
  static const String couponLabel = 'Coupons';
  static const String couponHint = 'Enter Coupon';

  // Checkout and Payment
  static const String continueToPayment = 'Continue To Payment';
  static const String currencyAED = 'AED '; // For consistent formatting

  // Terms and Conditions
  static const String acceptTermsAndConditions = 'I accept the terms & conditions';
  static const String readOurTermsAndConditions = 'Read our T&Cs';
  static const String mustAcceptTerms = 'You must accept terms & condition to proceed';

  // Payment Confirmation
  static const String confirmAndSubmitOrder = 'Please Confirm and submit your order';
  static const String byClickingSubmit = 'By clicking submit order, you agree to event\'s ';
  static const String and = ' and ';
  static const String termsOfUse = 'Terms of Use';

  static const String addNewAddress = 'Add new address';

  // Button Titles
  static const String continueButton = 'Continue';
  static const String saveAddress = 'Save Address';
  static const String updateAddress = 'Update Address';
  static const String addNewAddressTitle = 'Add New Address';

  // Validation & Snackbar Messages
  static const String nameIsRequired = 'Name is required.';
  static const String countryIsRequired = 'Country field is required.';
  static const String enterCorrectDetails = 'Please enter correct details.';
  static const String enterValidDetails = 'Please enter the valid details!';
  static const String addressSavedSuccess = 'Address saved successfully!';
  static const String noRecordsFound = 'No record found!';

  // Default/Fallback Values
  static const String unknownAddress = 'Unknown Address';
  static const String unknownName = 'Unknown Name';
  static const String unknownEmail = 'Unknown Email';
  static const String unknownPhone = 'Unknown Phone';
  static const String unknownCity = 'Unknown City';
  static const String unknownZipCode = 'Unknown Zip code';
  static const String choosePaymentMethod = 'Choose Payment Method';
  static const String orderSummary = 'Order Summary';
  static const String subtotalUpper = 'Subtotal';
  static const String taxVat = 'Tax (VAT)';
  static const String shipping = 'Shipping';
  static const String couponDiscount = 'Coupon Discount';
  static const String promotionDiscount = 'Promotion Discount';
  static const String totalUpper = 'Total';
  static const String deliverTo = 'Deliver to';
  static const String noAddressSelected = 'No address selected';
  static const String addressDetailsNotFound = 'Address details not found';
  static const String areaState = 'Area/State';
  static const String phoneNumber = 'Phone Number';
  static const String grandTotal = 'Grand Total';
  static const String payNowTitle = 'Pay Now';
  static const String totalLabel = 'Total';
  static const String paymentCompletedSuccessfully = 'Payment completed successfully';
  static const String applePayFailed = 'Apple Pay payment failed. Please try again.';
  static const String applePayErrorPrefix = 'Apple Pay payment error: ';
  static const String termsNote =
      'By placing an order, you confirm that you have read and approve Terms and Conditions';
  static const String shippingAddressDescription =
      'You will not be charged until you review this order on the next page.';
  static const String shippingAddress = 'Shipping address';
  static const String selectShippingAddress = 'Select Shipping Address';
  static const String shippingMethod = 'Shipping Method';
  static const String checkout = 'Checkout';
  static const String selectCountry = 'Select Country';
  static const String selectFromExistingAddresses = 'Select from existing addresses';

  static const String sortOption = 'Sort option';
  static const String filters = 'Filters';
  static const String apply = 'Apply';
  static const String filterOptions = 'Filter Options';
  static const String noNotifications = 'You Don\'t Have Any Notification Yet';
  static const String payment = 'Payment';

  // Payment method labels
  static const String applePay = 'Apple Pay';
  static const String applePaySubtitle = 'Pay with your Apple Wallet';
  static const String paymentCard = 'Card';
  static const String paymentTabby = 'Tabby';
  static const String paymentTamara = 'Tamara';
  static const String enterYourMessage = 'Enter your message here';
  static const String selectLocation = 'Select Location';
  static const String selectDate = 'Select Date';
  static const String selectedDate = 'Selected Date';
  static const String star = 'Star';
  static const String stars = 'Stars';
  static const String messageCanNotBeEmpty = 'Message can not be empty';
  static const String pleaseSelectValidDate = 'Please select valid date';
  static const String pleaseSelectLocation = 'Please select location';
  static const String failedToLoadImage = 'Failed to load image';
  static const String wishlist = 'WISHLIST';
  static const String pleaseLogInToWishList = 'Please Log-In to add items to your Wishlist.';
  static const String pleaseLogInToCart = 'Please Log-In to add items to Your Cart.';
  static const String noAttributesAvailable = 'No attributes available';
  static const String customerReviews = 'Customer Reviews';
  static const String view = 'View';
  static const String sellingBy = 'Selling By';
  static const String productDetails = 'Product Details';
  static const String ratings = 'ratings';

  // Product Status and Details
  static const String outOfStockStr = ' (Out of stock)';
  static const String includingVAT = 'including VAT';
  static const String interestFreeInstallment = 'interest-free installment available.';
  static const String moreColors = 'MORE COLORS';
  static const String relatedProducts = 'Related Products';
  static const String search = 'Search';
  static const String products = 'Products';
  static const String packages = 'Packages';
  static const String errorFetchingData = 'Error fetching data';

  // --- Strings for Sorting Dropdown ---
  static const String sortByDefault = 'Default Sorting';
  static const String sortByOldest = 'Oldest';
  static const String sortByNewest = 'Newest';
  static const String sortByNameAz = 'Name: A-Z';
  static const String sortByNameZa = 'Name: Z-A';
  static const String sortByPriceLowToHigh = 'Price: low to high';
  static const String sortByPriceHighToLow = 'Price: high to low';
  static const String sortByRatingLowToHigh = 'Rating: low to high';
  static const String sortByRatingHighToLow = 'Rating: high to low';

  // Header
  static const String orderPlaced = 'Order Placed!';
  static const String orderNoPrefix = 'Order No:';
  static const String orderDatePrefix = 'Order date:';
  static const String estimatedDeliveryPrefix = 'Estimated delivery date:';
  static const String itemsSuffix = ' Items'; // Used as "2 Items"

  // Item Details Labels
  static const String itemBrandPrefix = 'Adidas: '; // Example brand
  static const String itemColor = 'White'; // Example color/value
  static const String itemUKSize = 'UK42'; // Example size
  static const String itemQuantityValue = '2'; // Example quantity
  static const String colorLabel = 'Color: ';
  static const String sizeLabel = 'Size: ';
  static const String quantityLabel = 'QTY: ';

  // Amount & Totals
  static const String subTotal = 'SUB-TOTAL:';
  static const String discount = 'Discount';
  static const String tax = 'Tax';
  static const String delivery = 'DELIVERY';
  static const String total = 'TOTAL';

  // Delivery & Payment
  static const String deliveryDetails = 'DELIVERY DETAILS';
  static const String deliveryMethod = 'DELIVERY METHOD';
  static const String standardDelivery = 'Standard Delivery';
  static const String deliveryAddress = 'Delivery Address';
  static const String paymentDetails = 'PAYMENT DETAILS';
  static const String paymentType = 'PAYMENT TYPE';
  static const String mastercard = 'MASTERCARD';

  // Cancellation & Actions
  static const String changedYourMind = 'CHANGED YOUR MIND?'; // Typo from "TOUR" corrected
  static const String cancellingTheOrder = 'CANCELING THE ORDER';
  static const String cancellationInfo = 'We are not able to cancel the order but you need to then no way?';
  static const String cancelWithinOneHour = 'Cancel within one hour';
  static const String returnOrder = 'Return order';
  static const String viewOrderUppercase = 'VIEW ORDER';

  // Note: These are placeholders from your code, consider if they need to be here
  static const String actualPrice = 'actualPrice';
  static const String standardPrice = 'standardPrice';
  static const String fiftyPercentOffPrice = '50%offPrice';

  // General
  static const String permissionDenied = 'Permission Denied';
  static const String userCancelled = 'User canceled file selection';
  static const String fileSavedSuccess = 'File saved at local storage';
  static const String fileSaveError = 'Error saving file:';

  // Permissions Dialog
  static const String storagePermissionTitle = 'Storage Permission Required';
  static const String storagePermissionMessage =
      'This app requires access to your device\'s external storage to store the invoice. Please grant the permission to proceed.';
  static const String allow = 'Allow';
  static const String pending = 'Pending';
  static const String completed = 'Completed';
  static const String noOrders = 'No orders found';

  // Order Status
  static const String orderViewed = 'Order Viewed';
  static const String viewProduct = 'View Product';
  static const String viewOrder = 'View Order';

  // Review Labels
  static const String reviewSeller = 'Review Seller';
  static const String reviewProduct = 'Review Product';
  static const String error = 'Error';
  static const String orderDetails = 'Order Details';
  static const String orderInfo = 'Order Info';
  static const String orderNumber = 'Order number';
  static const String time = 'Time';
  static const String orderStatus = 'Order status';
  static const String charges = 'Charges';
  static const String totalAmount = 'Total Amount';
  static const String confirmation = 'Confirmation';
  static const String confirmationMessage = 'Are you sure you want to cancel this order?';

  static const String shippingInfo = 'Shipping Info';
  static const String shippingStatus = 'Shipping Status:';
  static const String dateShipped = 'Date shipped:';

  static const String uploadPaymentProof = 'Upload Payment Proof';
  static const String uploadButton = 'Upload Payment Proof';
  static const String viewReceipt = 'View Receipt: ';
  static const String uploadedProofNote = 'You have uploaded a copy of your payment proof.\n\n';
  static const String reuploadNote = 'Or you can upload a new one, the old one will be replaced.';
  static const String noProofUploaded =
      'The order is currently being processed. For expedited processing, kindly upload a copy of your payment proof:';

  static const String invoice = 'Invoice';
  static const String noDataAvailable = 'No data available';
  static const String failedToLoadPaymentMethods = 'Failed to load payment methods.';
  static const String noPaymentMethodsAvailable = 'No payment methods available.';

  // Gift Card Form Strings
  static const String selectGiftCardAmount = 'Select Gift Card Amount';
  static const String selectOrAddAmount = 'Select or add amount';
  static const String amountMustBeLessThan = 'Amount must be less than 10000 AED';
  static const String invalidAmountEntered = 'Invalid amount entered';
  static const String enterReceiptName = 'Enter Receipt Name *';
  static const String enterReceiptEmail = 'Enter Receipt Email *';
  static const String additionalNotes = 'Additional Notes';
  static const String payNow = 'Pay Now';
  static const String discount50 = '50% Discount';
  static const String searchDiscounts = 'Search Discounts';
  static const String noProductsFound = 'No products found!';
  static const String searchGifts = 'Search Gifts';
  static const String purchased = 'Purchased';
  static const String searchBrands = 'Search Brands';

  static const String addressCannotBeEmpty = 'Address cannot be empty';
  static const String changeLanguage = 'Change Language';

  // Navigation Bar
  static const String celebrities = 'Celebrities';
  static const String brands = 'Brands';
  static const String events = 'EVENTS';
  static const String categories = 'Categories';
  static const String account = 'Account';

  // Categories
  static const String giftsByOccasion = 'Gifts by occasion';
  static const String darkMode = 'Dark Mode';
  static const String vendorAccountUnderReview = 'Your vendor account is under review and waiting for approval.';

  static const String paymentSuccessful = 'payment_successful';
  static const String paymentFailed = 'payment_failed';
  static const String orderPlacedSuccessfully = 'orderPlacedSuccessfully';
  static const String noOrderDetailsFound = 'noOrderDetailsFound';
  static const String retry = 'retry';
  static const String confirmPaymentCancel = 'confirmPaymentCancel';
  static const String paymentCancelWarning = 'paymentCancelWarning';
  static const String continuePayment = 'continuePayment';
  static const String cancelPayment = 'cancelPayment';
  static const String processing = 'Processing';
  static const String was = 'Was: ';
  static const String wallet = 'wallet';

  // Wallet module
  static const String digitalWallet = 'digitalWallet';
  static const String expirySoon = 'expirySoon';
  static const String currentBalanceTitle = 'currentBalanceTitle';
  static const String rewardsEarnedTitle = 'rewardsEarnedTitle';
  static const String walletBalanceTitle = 'Wallet Balance';
  static const String lastUpdatedPrefix = 'Last updated';
  static const String addFunds = 'Add Funds';
  static const String history = 'History';
  static const String notifications = 'Notifications';
  static const String deposits = 'Deposits';
  static const String overview = 'Overview';
  static const String addFundsToWallet = 'Add Funds to Wallet';
  static const String selectDepositMethod = 'Select Deposit Method';
  static const String couponCodeGiftCard = 'Coupon Code (Gift Card)';
  static const String amountAed = 'Amount (AED)';
  static const String instant = 'Instant';
  static const String giftCard = 'Gift Card';
  static const String redeemYourGiftCard = 'redeemYourGiftCard';
  static const String noFees = 'noFees';
  static const String creditDebitCard = 'Credit/Debit Card';
  static const String visaMasterAccepted = 'Visa, Master Card accepted';
  static const String processingFeeSuffix = 'processing fee';
  static const String balanceLabel = 'Balance:';
  static const String searchTransactions = 'searchTransactions';
  static const String export = 'export';
  static const String markAllRead = 'markAllRead';
  static const String markAsUnread = 'markAsUnread';
  static const String markAsRead = 'markAsRead';
  static const String totalTransactions = 'transactionsCount';
  static const String fundExpiryAlert = 'fundExpiryAlert';
  static const String criticalActionRequired = 'criticalActionRequired';
  static const String notificationSettings = 'notificationSettings';
  static const String notificationTypes = 'notificationTypes';
  static const String noExpiringFundsFound = 'noExpiringFundsFound';
  static const String card = 'card';
}
