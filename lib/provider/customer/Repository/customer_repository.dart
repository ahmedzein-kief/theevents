import 'package:event_app/models/account_models/customer_upload_profile_pic_model.dart';
import 'package:event_app/models/account_models/reviews/customer_get_product_reviews_model.dart';
import 'package:event_app/models/vendor_models/common_models/common_post_request_model.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';

import '../../../data/vendor/data/network/dio/DioBaseApiServices.dart';
import '../../../data/vendor/data/network/dio/DioNetworkApiServices.dart';

class CustomerRepository {
  final DioBaseApiServices _dioBaseApiServices = DioNetworkApiServices();

  /// customer upload profile picture
  Future<CustomerUploadProfilePicModel> customerUploadProfilePicture({
    required Map<String, String> headers,
    required dynamic formData,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
      url: ApiEndpoints.customerUploadProfilePic,
      headers: headers,
      data: formData,
      method: 'POST',
    );
    return CustomerUploadProfilePicModel.fromJson(response);
  }


  /// Vendor reviews list
  Future<CustomerGetProductReviewsModel> customerGetProductReviews({
    required Map<String, String> headers,
    required Map<String, String> queryParams,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: ApiEndpoints.customerGetProductReviews,
      headers: headers,
      queryParams: queryParams,
    );
    // Map the response to the model
    return CustomerGetProductReviewsModel.fromJson(response);
  }


  /// customer submit review
  Future<CommonPostRequestModel> customerSubmitReview({
    required Map<String, String> headers,
    required dynamic form,
  }) async {
    final response = await _dioBaseApiServices.dioMultipartApiService(
      url: ApiEndpoints.customerSubmitReview,
      headers: headers,
      data: form,
      method: 'POST',
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }


  /// customer delete review
  Future<CommonPostRequestModel> customerDeleteReview({
    required Map<String, String> headers,
    required dynamic reviewID,
  }) async {
    // API call
    final response = await _dioBaseApiServices.dioGetApiService(
      url: ApiEndpoints.customerDeleteReview + reviewID,
      headers: headers,
    );
    // Map the response to the model
    return CommonPostRequestModel.fromJson(response);
  }


}
