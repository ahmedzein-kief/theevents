import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/network/api_endpoints/vendor_api_end_point.dart';
import 'package:event_app/data/vendor/data/network/dio/DioBaseApiServices.dart';
import 'package:event_app/data/vendor/data/network/dio/DioNetworkApiServices.dart';
import 'package:event_app/models/vendor_models/common_models/common_post_request_model.dart';
import 'package:event_app/models/vendor_models/dashboard/dashboard_data_response.dart';
import 'package:event_app/models/vendor_models/packages/vendor_get_package_general_settings_model.dart';
import 'package:event_app/models/vendor_models/products/VendorGetProductsModel.dart';
import 'package:event_app/models/vendor_models/products/create_product/attribute_sets_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/common_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/create_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/global_options_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/upload_images_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_get_product_tags_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_get_seo_keywords_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/edit_product/edit_variations_data_response.dart';
import 'package:event_app/models/vendor_models/products/edit_product/new_product_view_data_response.dart';
import 'package:event_app/models/vendor_models/products/edit_product/vendor_get_product_variations_model.dart';
import 'package:event_app/models/vendor_models/products/vendor_get_product_general_settings_model.dart';
import 'package:event_app/models/vendor_models/revenues/revenue_data_response.dart';
import 'package:event_app/models/vendor_models/reviews/reviews_data_response.dart';
import 'package:event_app/models/vendor_models/vendor_coupons_models/vendor_create_coupon_model.dart';
import 'package:event_app/models/vendor_models/vendor_coupons_models/vendor_delete_coupon_model.dart';
import 'package:event_app/models/vendor_models/vendor_coupons_models/vendor_generate_coupon_code_model.dart';
import 'package:event_app/models/vendor_models/vendor_coupons_models/vendor_get_coupons_model.dart';
import 'package:event_app/models/vendor_models/vendor_order_models/vendor_get_order_details_model.dart';
import 'package:event_app/models/vendor_models/vendor_order_models/vendor_get_orders_model.dart';
import 'package:event_app/models/vendor_models/vendor_order_models/vendor_update_shipment_status_model.dart';
import 'package:event_app/models/vendor_models/vendor_settings_models/vendor_get_settings_model.dart';
import 'package:event_app/models/vendor_models/vendor_settings_models/vendor_settings_model.dart';
import 'package:event_app/models/vendor_models/vendor_withdrawals_model/vendor_get_withdrawals_model.dart';
import 'package:event_app/models/vendor_models/vendor_withdrawals_model/vendor_show_withdrawal_model.dart';

class VendorRepository {
  final DioBaseApiServices _dioBaseApiServices = DioNetworkApiServices();
  final Dio dio = Dio();

  Future<CommonDataResponse> vendorDeleteProductVariation({
    required String productVariationId,
    required Map<String, String> headers,
  }) async {
    try {
      // API call
      final response = await _dioBaseApiServices.dioDeleteApiService(
        url:
            '${VendorApiEndpoints.vendorDeleteProductVariation}$productVariationId',
        headers: headers,
      );

      // Map the response to the model
      return CommonDataResponse.fromJson(response);
    } catch (e, stacktrace) {
      // Log the error with stacktrace
      log('Error in fetching vendor products: $e', stackTrace: stacktrace);
      // Throw a custom exception
      throw Exception('Failed to fetch vendor products: $e');
    }
  }

  /// Get Vendor Products List
  Future<VendorGetProductsModel> vendorGetProducts({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    try {
      // API call
      final response = await _dioBaseApiServices.dioGetApiService(
        url: VendorApiEndpoints.vendorProducts,
        headers: headers,
        queryParams: queryParams,
      );

      // Map the response to the model
      return VendorGetProductsModel.fromJson(response);
    } catch (e, stacktrace) {
      // Log the error with stacktrace
      log('Error in fetching vendor products: $e', stackTrace: stacktrace);
      // Throw a custom exception
      throw Exception('Failed to fetch vendor products: $e');
    }
  }

  /// Get Vendor packages List
  Future<VendorGetProductsModel> vendorGetPackages({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    // try {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorPackages,
      headers: headers,
      queryParams: queryParams,
    );

    // Map the response to the model
    return VendorGetProductsModel.fromJson(response);
    // } catch (e, stacktrace) {
    //   // Log the error with stacktrace
    //   log("Error in fetching vendor packages: $e", stackTrace: stacktrace);
    //   // Throw a custom exception
    //   throw Exception("Failed to fetch vendor packages: $e");
    // }
  }

  /// Vendor Generate Coupon Code
  Future<VendorGenerateCouponCodeModel> vendorGenerateCouponCode({
    required Map<String, String> headers,
  }) async {
    // try {
    // API call
    final response = await _dioBaseApiServices.dioPostApiService(
        url: VendorApiEndpoints.vendorGenerateCouponCode,
        headers: headers,
        body: null);

    // Map the response to the model
    return VendorGenerateCouponCodeModel.fromJson(response);
    // } catch (e, stacktrace) {
    //   // Log the error with stacktrace
    //   log("Error in creating vendor coupon code: $e", stackTrace: stacktrace);
    //   // Throw a custom exception
    //   throw Exception("Failed to fetch vendor coupon code: $e");
    // }
  }

  /// vendor create coupon
  Future<VendorCreateCouponModel> vendorCreateCoupon({
    required Map<String, String> headers,
    required body,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioPostApiService(
        url: VendorApiEndpoints.vendorCreateCoupon,
        headers: headers,
        body: body);

    // Map the response to the model
    return VendorCreateCouponModel.fromJson(response);
  }

  /// vendor get coupons
  Future<VendorGetCouponsModel> vendorGetCoupons({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetCoupons,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return VendorGetCouponsModel.fromJson(response);
  }

  /// vendor get settings
  Future<VendorGetSettingsModel> vendorGetSettings({
    required Map<String, String> headers,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetSettings,
      headers: headers,
    );
    // Map the response to the model
    return VendorGetSettingsModel.fromJson(response);
  }

  /// vendor settings - store, tax info, bank info
  Future<VendorSettingsModel> vendorSettings({
    required url,
    required body,
    required Map<String, String> headers,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioMultipartApiService(
        method: 'POST', url: url, headers: headers, data: body);
    // Map the response to the model
    return VendorSettingsModel.fromJson(response);
  }

  /// vendor delete coupons
  Future<VendorDeleteCouponModel> vendorDeleteCoupon({
    required Map<String, String> headers,
    required couponId,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioDeleteApiService(
      url: VendorApiEndpoints.vendorDeleteCoupon + couponId,
      headers: headers,
    );
    // Map the response to the model
    return VendorDeleteCouponModel.fromJson(response);
  }

  /// Vendor Get All orders
  Future<VendorGetOrdersModel> vendorGetOrders({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetOrders,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return VendorGetOrdersModel.fromJson(response);
  }

  /// Vendor get order details
  Future<VendorGetOrderDetailsModel> vendorGetOrderDetails({
    required Map<String, String> headers,
    required String orderId,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetOrderDetails + orderId,
      headers: headers,
    );
    // Map the response to the model
    return VendorGetOrderDetailsModel.fromJson(response);
  }

  /// Vendor generate order invoice
  Future<dynamic> vendorGenerateOrderInvoice({
    required Map<String, String> headers,
    required String orderId,
  }) async {
    try {
      final response = await dio.get(
        VendorApiEndpoints.vendorGenerateOrderInvoice + orderId,
        options: Options(
          headers: headers,
          responseType:
              ResponseType.bytes, // Receive the response as bytes (binary data)
          extra: {
            'cache': true, // Enable cache for this request
          },
        ),
      );

      // Check if the response contains the expected PDF data as bytes
      if (response.data is List<int>) {
        // If the response is a List<int> (PDF byte array), you can process it further
        final List<int> pdfBytes = response.data as List<int>;

        // You can save the PDF bytes to a file or process them as needed
        return pdfBytes;
      } else {
        // Handle case where the response is not in the expected format (not a List<int>)
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get Vendor dashboard data
  Future<DashboardDataResponse> getDashboardData({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorDashboard,
      headers: headers,
      queryParams: queryParams,
    );

    // Map the response to the model
    return DashboardDataResponse.fromJson(response);
  }

  /// Vendor order returns list
  Future<VendorGetOrdersModel> vendorOrderReturns({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorOrderReturns,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return VendorGetOrdersModel.fromJson(response);
  }

  /// Vendor order returns list
  Future<VendorGetWithdrawalsModel> vendorWithdrawals({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorWithdrawals,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return VendorGetWithdrawalsModel.fromJson(response);
  }

  /// Vendor reviews list
  Future<ReviewsDataResponse> vendorReviews({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorReviews,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return ReviewsDataResponse.fromJson(response);
  }

  /// Vendor reviews list
  Future<RevenueDataResponse> vendorRevenues({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorRevenues,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return RevenueDataResponse.fromJson(response);
  }

  /// Vendor Update shipment Status
  Future<VendorUpdateShipmentStatusModel> vendorUpdateShipmentStatus({
    required Map<String, String> headers,
    required String shipmentID,
    required body,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
        url: VendorApiEndpoints.vendorUpdateShippingStatus + shipmentID,
        headers: headers,
        body: body);

    // Map the response to the model
    return VendorUpdateShipmentStatusModel.fromJson(response);
  }

  /// Vendor update order
  Future<CommonPostRequestModel> vendorUpdateOrder({
    required Map<String, String> headers,
    required String orderID,
    required body,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
        url: VendorApiEndpoints.vendorUpdateOrder + orderID,
        headers: headers,
        body: body);
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// Vendor confirm order
  Future<CommonPostRequestModel> vendorConfirmOrder({
    required Map<String, String> headers,
    required String orderID,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorConfirmOrder + orderID,
      headers: headers,
      body: null,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// Vendor send confirmation Email
  Future<CommonPostRequestModel> vendorSendConfirmationEmail({
    required Map<String, String> headers,
    required String orderID,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorSendConfirmationEmail + orderID,
      headers: headers,
      body: null,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// Vendor cancel order
  Future<CommonPostRequestModel> vendorCancelOrder({
    required Map<String, String> headers,
    required String orderID,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorCancelOrder + orderID,
      headers: headers,
      body: null,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor delete order
  Future<CommonPostRequestModel> vendorDeleteOrder({
    required Map<String, String> headers,
    required String orderID,
  }) async {
    final response = await _dioBaseApiServices.dioDeleteApiService(
      url: VendorApiEndpoints.vendorDeleteOrder + orderID,
      headers: headers,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// Vendor update shipping address of order
  Future<CommonPostRequestModel> vendorUpdateShippingAddress({
    required Map<String, String> headers,
    required String shippingID,
    required String body,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorUpdateShippingAddress + shippingID,
      headers: headers,
      body: body,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// Vendor product general settings
  Future<VendorGetProductGeneralSettingsModel> vendorGetProductGeneralSettings({
    required Map<String, String> headers,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetProductGeneralSettings,
      headers: headers,
    );
    // Map the response to the model
    return VendorGetProductGeneralSettingsModel.fromJson(response);
  }

  /// Vendor product attribute sets
  Future<AttributeSetsDataResponse> vendorProductAttributeSets({
    required Map<String, String> headers,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorAttributeSets,
      headers: headers,
    );
    // Map the response to the model
    return AttributeSetsDataResponse.fromJson(response);
  }

  /// Vendor get product tags while creating
  Future<VendorGetProductTagsModel> vendorGetProductTags({
    required Map<String, String> headers,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetProductTags,
      headers: headers,
    );
    // Map the response to the model
    return VendorGetProductTagsModel.fromJson(response);
  }

  /// vendor create product slug
  Future<CommonPostRequestModel> vendorCreateProductSlug({
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorCreateProductSlug,
      headers: headers,
      body: body,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// Global Options
  Future<GlobalOptionsDataResponse> getGlobalOptions({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.globalOptions,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return GlobalOptionsDataResponse.fromJson(response);
  }

  /// Search Product for Related or Cross-Selling
  Future<VendorSearchProductDataResponse> searchProducts({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.searchProduct,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return VendorSearchProductDataResponse.fromJson(response);
  }

  /// vendor get seo keywords
  Future<VendorGetSeoKeywordsModel> vendorGetProductSeoKeywords({
    required Map<String, String> headers,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetProductSeoKeywords,
      headers: headers,
    );
    // Map the response to the model
    return VendorGetSeoKeywordsModel.fromJson(response);
  }

  /// vendor get product variations listing
  Future<VendorGetProductVariationsModel> vendorGetProductVariations({
    required Map<String, String> headers,
    required body,
    required String productID,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorGetProductVariations + productID,
      headers: headers,
      body: body,
    );
    // Map the response to the model
    return VendorGetProductVariationsModel.fromJson(response);
  }

  /// vendor set default product variation
  Future<CommonPostRequestModel> vendorSetDefaultProductVariation({
    required Map<String, String> headers,
    required String productVariationID,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorSetDefaultProductVariation +
          productVariationID,
      headers: headers,
      body: null,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor set default product variation
  Future<CommonPostRequestModel> vendorGenerateAllProductVariations({
    required Map<String, String> headers,
    required String productID,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorGenerateAllProductVariations + productID,
      headers: headers,
      body: null,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// Vendor get product selected attribute sets
  Future<AttributeSetsDataResponse> vendorGetSelectedProductAttributes({
    required Map<String, String> headers,
    required String productID,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetSelectedProductAttributes + productID,
      headers: headers,
    );
    // Map the response to the model
    return AttributeSetsDataResponse.fromJson(response);
  }

  /// vendor edit product attributes
  Future<CommonPostRequestModel> vendorEditProductAttributes({
    required Map<String, String> headers,
    required String productID,
    required body,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorEditProductAttributes + productID,
      headers: headers,
      body: body,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor upload images
  Future<UploadImagesDataResponse> vendorUploadImages({
    required Map<String, String> headers,
    required FormData formData,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
      method: 'POST',
      url: VendorApiEndpoints.vendorUploadImages,
      headers: headers,
      data: formData,
    );
    // Map the response to the model
    return UploadImagesDataResponse.fromJson(response);
  }

  /// create product attributes
  Future<CreateProductDataResponse> createProduct({
    required Map<String, String> headers,
    required body,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
      url: VendorApiEndpoints.vendorCreateProduct,
      headers: headers,
      data: body,
      method: 'POST',
    );
    // Map the response to the model
    return CreateProductDataResponse.fromJson(response);
  }

  Future<NewProductViewDataResponse> productView({
    required String productId,
    required Map<String, String> headers,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: '${VendorApiEndpoints.vendorProducts}/$productId',
      headers: headers,
    );
    // Map the response to the model
    return NewProductViewDataResponse.fromJson(response);
  }

  Future<EditVariationsDataResponse> editVariations({
    required String productVariationId,
    required Map<String, String> headers,
  }) async {
    final url = '${VendorApiEndpoints.vendorGetVersion}$productVariationId';
    final response = await _dioBaseApiServices.dioGetApiService(
      url: url,
      headers: headers,
    );
    // Map the response to the model
    return EditVariationsDataResponse.fromJson(response);
  }

  // Future<EditVariationsDataResponse> updateVariations({
  //   required String productVariationId,
  //   required Map<String, String> headers,
  //   required dynamic body,
  // }) async {
  //   final url = VendorApiEndpoints.vendorUpdateVersion + '$productVariationId';
  //   print('URL ==> $url');
  //   final response = await _dioBaseApiServices.dioMultipartApiService(
  //     url: url,
  //     headers: headers,
  //     data: body,
  //     method: 'POST',
  //   );
  //   // Map the response to the model
  //   return EditVariationsDataResponse.fromJson(response);
  // }

  /// vendor delete product
  Future<CommonPostRequestModel> vendorDeleteProduct({
    required Map<String, String> headers,
    required productID,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioDeleteApiService(
      url: VendorApiEndpoints.vendorDeleteProduct + productID,
      headers: headers,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// Vendor package general settings
  Future<VendorGetPackageGeneralSettingsModel> vendorGetPackageGeneralSettings({
    required Map<String, String> headers,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorGetPackageGeneralSettings,
      headers: headers,
    );
    // Map the response to the model
    return VendorGetPackageGeneralSettingsModel.fromJson(response);
  }

  /// create package
  Future<CreateProductDataResponse> vendorCreatePackage({
    required Map<String, String> headers,
    required body,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
        url: VendorApiEndpoints.vendorCreatePackage,
        headers: headers,
        data: body,
        method: 'POST');
    // Map the response to the model
    return CreateProductDataResponse.fromJson(response);
  }

  /// vendor delete package
  Future<CommonPostRequestModel> vendorDeletePackage({
    required Map<String, String> headers,
    required packageID,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioDeleteApiService(
      url: VendorApiEndpoints.vendorDeletePackage + packageID,
      headers: headers,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor view package details
  Future<NewProductViewDataResponse> vendorViewPackage({
    required String packageID,
    required Map<String, String> headers,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorViewPackage + packageID,
      headers: headers,
    );
    // Map the response to the model
    return NewProductViewDataResponse.fromJson(response);
  }

  /// vendor update package
  Future<CommonPostRequestModel> vendorUpdatePackage({
    required Map<String, String> headers,
    required body,
    required String packageID,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
        url: VendorApiEndpoints.vendorUpdatePackage + packageID,
        headers: headers,
        data: body,
        method: 'POST');
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor create update withdrawal
  Future<CommonPostRequestModel> vendorCreateUpdateWithdrawal({
    required Map<String, String> headers,
    required body,
    required String url,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: url,
      headers: headers,
      body: body,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor cancel withdrawal
  Future<CommonPostRequestModel> vendorCancelWithdrawal({
    required Map<String, String> headers,
    required String withdrawalID,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.vendorCancelWithdrawal + withdrawalID,
      headers: headers,
      body: null,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor show withdrawal
  Future<VendorShowWithdrawalModel> vendorShowWithdrawal({
    required Map<String, String> headers,
    required String withdrawalID,
  }) async {
    final response = await _dioBaseApiServices.dioGetApiService(
      url: VendorApiEndpoints.vendorShowWithdrawal + withdrawalID,
      headers: headers,
    );
    // Map the response to the model
    return VendorShowWithdrawalModel.fromJson(response);
  }

  /// vendor update product
  Future<CommonPostRequestModel> vendorUpdateProduct({
    required Map<String, String> headers,
    required body,
    required String productID,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
      url: VendorApiEndpoints.vendorUpdateProduct + productID,
      headers: headers,
      data: body,
      method: 'POST',
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor update product
  Future<CommonPostRequestModel> addAttributeToExistingProduct({
    required String productId,
    required Map<String, String> headers,
    required FormData body,
  }) async {
    final response = await _dioBaseApiServices.dioPostApiService(
      url: VendorApiEndpoints.addAttributeToProduct + productId,
      headers: headers,
      body: body,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor create variation
  Future<CommonPostRequestModel> vendorCreateProductVariation({
    required Map<String, String> headers,
    required body,
    required String productID,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
        url: VendorApiEndpoints.vendorCreateProductVariation + productID,
        headers: headers,
        data: body,
        method: 'POST');
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  /// vendor update variation
  Future<CommonPostRequestModel> vendorUpdateProductVariation({
    required Map<String, String> headers,
    required body,
    required String productVariationID,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
        url: VendorApiEndpoints.vendorUpdateProductVariation +
            productVariationID,
        headers: headers,
        data: body,
        method: 'POST');
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }

  String _errorMessage(response) {
    var errors;
    var error;
    var message;

    if (response is Response) {
      if (response.data != null) {
        final errorData = response.data;
        errors = errorData['errors'] ?? errorData['data'];
        error = errorData['error'];
        message = errorData['message'];
      }
    } else {
      final jsonData = json.decode(response.body);
      if (response != null) {
        errors = jsonData['errors'];
        error = jsonData['error'];
        message = jsonData['message'];
      }
    }

    try {
      // Initialize a variable to store error messages
      String allErrors = '';

      // Check if `errors` is present and process it
      if (errors != null && errors is Map) {
        errors.forEach((key, value) {
          if (value is List) {
            for (final msg in value) {
              allErrors += '$key: $msg\n'; // Append each error message
            }
          }
        });
      }

      // Check if `error` is present and append it
      if (error != null && error is String) {
        allErrors += 'Error: $error\n';
      }

      // Check if `message` is present and append it
      // if (message != null && message is String) {
      //   allErrors += 'Message: $message\n';
      // }

      // Return the collected error messages
      if (allErrors.isNotEmpty) {
        return allErrors.trim(); // Remove trailing newline
      }

      return 'An unknown error occurred.'; // Fallback message if no errors are found

      return 'Unknown error occurred';
    } catch (e) {
      return 'Unknown error occurred with status code: ${response.statusCode}';
    }
  }
}
