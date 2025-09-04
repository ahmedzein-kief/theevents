import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/network/api_endpoints/vendor_api_end_point.dart';
import 'package:event_app/models/auth_models/get_user_models.dart';
import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/models/vendor_models/post_models/authorized_signatory_info_post_data.dart';
import 'package:event_app/models/vendor_models/post_models/bank_details_post_data.dart';
import 'package:event_app/models/vendor_models/post_models/business_owner_info_post_data.dart';
import 'package:event_app/models/vendor_models/post_models/company_info_post_data.dart';
import 'package:event_app/models/vendor_models/post_models/contract_agreement_post_data.dart';
import 'package:event_app/models/vendor_models/response_models/bank_details_response.dart';
import 'package:event_app/models/vendor_models/response_models/business_signatory_response.dart';
import 'package:event_app/models/vendor_models/response_models/company_info_response.dart';
import 'package:event_app/models/vendor_models/response_models/contract_agreement_response.dart';
import 'package:event_app/models/vendor_models/response_models/email_resend_response.dart';
import 'package:event_app/models/vendor_models/response_models/meta_data_response.dart';
import 'package:event_app/models/vendor_models/response_models/payment_methods_response.dart';
import 'package:event_app/models/vendor_models/response_models/signup_response.dart';
import 'package:flutter/cupertino.dart';

import '../../core/helper/di/locator.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/utils/custom_toast.dart';
import '../../models/dashboard/vendor_permissions.dart';
import '../../models/vendor_models/post_models/payment_post_data.dart';
import '../../models/vendor_models/post_models/signup_post_data.dart';
import '../../models/vendor_models/response_models/subscription_package_response.dart';
import '../api_response_handler.dart';

class VendorSignUpProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<SignUpResponse?> signUp(
    BuildContext context,
    VendorSignUpPostData vendorSignUpPostData,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.signup;
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> postSignUpData = vendorSignUpPostData.toMap();

    try {
      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        bodyString: jsonEncode(postSignUpData),
      );
      if (response.statusCode == 200) {
        final jsonData = response.data;
        final dataModel = SignUpResponse.fromJson(jsonData);
        CustomSnackbar.showSuccess(context, dataModel.message);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        final message = _errorMessage(response);
        CustomSnackbar.showError(context, message);
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<BusinessSignatoryResponse?> updateBusinessSignatoryData(
    BuildContext context,
    BusinessOwnerInfoPostData boiData,
    AuthorizedSignatoryInfoPostData? asiData,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.meta;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token,
      'Content-Type': 'multipart/form-data',
    };

    final formData = FormData();

    formData.fields.addAll(boiData.toMapEntries(asiData == null));
    // Add files (if any)
    if (boiData.eidFile != null) {
      formData.files.add(
        MapEntry(
          'eid_file',
          await MultipartFile.fromFile(
            boiData.eidFile!.path,
            filename: boiData.eidFileName,
          ),
        ),
      );
    } else {
      if (boiData.eidServerFilePath?.isNotEmpty == true) {
        formData.fields
            .add(MapEntry('eid_file_name', boiData.eidFileName ?? ''));
      }
    }
    if (boiData.passportFile != null) {
      formData.files.add(
        MapEntry(
          'passport',
          await MultipartFile.fromFile(
            boiData.passportFile!.path,
            filename: boiData.passportFileName,
          ),
        ),
      );
    } else {
      if (boiData.passportServerFilePath?.isNotEmpty == true) {
        formData.fields.add(
            MapEntry('passport_file_name', boiData.passportFileName ?? ''),);
      }
    }

    if (asiData != null) {
      formData.fields.addAll(asiData.toMapEntries());
      // Add files (if any)
      if (asiData.ownerEIDFile != null) {
        formData.files.add(
          MapEntry(
            'owner_eid_file',
            await MultipartFile.fromFile(
              asiData.ownerEIDFile!.path,
              filename: asiData.ownerEIDFileName,
            ),
          ),
        );
      } else {
        if (asiData.ownerEIDServerFilePath?.isNotEmpty == true) {
          formData.fields.add(
              MapEntry('owner_eid_file_name', asiData.ownerEIDFileName ?? ''),);
        }
      }
      if (asiData.passportFile != null) {
        formData.files.add(
          MapEntry(
            'owner_passport',
            await MultipartFile.fromFile(
              asiData.passportFile!.path,
              filename: asiData.passportFileName,
            ),
          ),
        );
      } else {
        if (asiData.passportServerFilePath?.isNotEmpty == true) {
          formData.fields.add(MapEntry(
              'owner_passport_file_name', asiData.passportFileName ?? '',),);
        }
      }
      if (asiData.poamoaFile != null) {
        formData.files.add(
          MapEntry(
            'signatory_poamoa_file',
            await MultipartFile.fromFile(
              asiData.poamoaFile!.path,
              filename: asiData.poamoaFileName,
            ),
          ),
        );
      } else {
        if (asiData.poamoaServerPath?.isNotEmpty == true) {
          formData.fields.add(MapEntry(
              'signatory_poamoa_file_name', asiData.poamoaFileName ?? '',),);
        }
      }
    }

    try {
      // Make Dio request
      final dio = locator.get<Dio>();

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          method: 'POST',
          headers: headers,
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        final dataModel = BusinessSignatoryResponse.fromJson(response.data);
        CustomSnackbar.showSuccess(context, dataModel.message);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        final errorDetails = e.response?.data;
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CompanyInfoResponse?> updateCompanyInfoData(
    BuildContext context,
    CompanyInfoPostData ciData,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.meta;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token ?? '',
      'Content-Type': 'multipart/form-data',
    };

    final formData = FormData();

    formData.fields.addAll(ciData.toMapEntries());
    // Add files (if any)
    if (ciData.companyLogoFile != null) {
      formData.files.add(
        MapEntry(
          'company_logo',
          await MultipartFile.fromFile(
            ciData.companyLogoFile!.path,
            filename: ciData.companyLogoFileName,
          ),
        ),
      );
    } else {
      if (ciData.companyLogoFileServerPath?.isNotEmpty == true) {
        formData.fields.add(
            MapEntry('company_logo_name', ciData.companyLogoFileName ?? ''),);
      }
    }

    if (ciData.utlFile != null) {
      formData.files.add(
        MapEntry(
          'tdl_file',
          await MultipartFile.fromFile(
            ciData.utlFile!.path,
            filename: ciData.utlFileName,
          ),
        ),
      );
    } else {
      if (ciData.utlFileServerPath?.isNotEmpty == true) {
        formData.fields
            .add(MapEntry('tdl_file_name', ciData.utlFileName ?? ''));
      }
    }

    if (ciData.nocPoaFile != null) {
      formData.files.add(
        MapEntry(
          'noc_file',
          await MultipartFile.fromFile(
            ciData.nocPoaFile!.path,
            filename: ciData.nocPoaFileName,
          ),
        ),
      );
    } else {
      if (ciData.nocPoaFileServerPath?.isNotEmpty == true) {
        formData.fields
            .add(MapEntry('noc_file_name', ciData.nocPoaFileName ?? ''));
      }
    }

    if (ciData.vatFile != null) {
      formData.files.add(
        MapEntry(
          'vat_file',
          await MultipartFile.fromFile(
            ciData.vatFile!.path,
            filename: ciData.vatFileName,
          ),
        ),
      );
    } else {
      if (ciData.vatFileServerPath?.isNotEmpty == true) {
        formData.fields
            .add(MapEntry('vat_file_name', ciData.vatFileName ?? ''));
      }
    }

    try {
      final response = await _apiResponseHandler.postDioMultipartRequest(
          url, headers, formData,);

      if (response.statusCode == 200) {
        final dataModel = CompanyInfoResponse.fromJson(response.data);
        CustomSnackbar.showSuccess(context, dataModel.message);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<BankDetailsResponse?> updateBankDetails(
    BuildContext context,
    BankDetailsPostData bdData,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.meta;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token ?? '',
      'Content-Type': 'multipart/form-data',
    };

    final formData = FormData();

    formData.fields.addAll(bdData.toMapEntries());
    // Add files (if any)
    if (bdData.bankLetterFile != null) {
      formData.files.add(
        MapEntry(
          'bank_letter_file',
          await MultipartFile.fromFile(
            bdData.bankLetterFile!.path,
            filename: bdData.bankLetterFileName,
          ),
        ),
      );
    } else {
      if (bdData.bankLetterFileServerPath?.isNotEmpty == true) {
        formData.fields.add(
            MapEntry('bank_letter_file_name', bdData.bankLetterFileName ?? ''),);
      }
    }

    try {
      final response = await _apiResponseHandler.postDioMultipartRequest(
          url, headers, formData,);

      if (response.statusCode == 200) {
        final dataModel = BankDetailsResponse.fromJson(response.data);
        CustomSnackbar.showSuccess(context, dataModel.message);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ContractAgreementResponse?> updateContractAgreementData(
    BuildContext context,
    ContractAgreementPostData caData,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.meta;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token ?? '',
      'Content-Type': 'multipart/form-data',
    };

    final formData = FormData();

    formData.fields.addAll(caData.toMapEntries());
    // Add files (if any)
    if (caData.companyStampFile != null) {
      formData.files.add(
        MapEntry(
          'company_stamp_file',
          await MultipartFile.fromFile(
            caData.companyStampFile!.path,
            filename: caData.companyStampFileName,
          ),
        ),
      );
    } else {
      if (caData.companyStampFileServerPath?.isNotEmpty == true) {
        formData.fields.add(MapEntry(
            'company_stamp_file_name', caData.companyStampFileName ?? '',),);
      }
    }

    try {
      final response = await _apiResponseHandler.postDioMultipartRequest(
          url, headers, formData,);
      if (response.statusCode == 200) {
        final dataModel = ContractAgreementResponse.fromJson(response.data);
        CustomSnackbar.showSuccess(context, dataModel.message);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        final jsonData = json.decode(response.data);
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CheckoutPaymentModel?> updatePayment(
    BuildContext context,
    PaymentPostData pData,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.meta;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token ?? '',
      'Content-Type': 'multipart/form-data',
    };

    final formData = FormData();

    formData.fields.addAll(pData.toMapEntries());

    try {
      final response = await _apiResponseHandler.postDioMultipartRequest(
          url, headers, formData,);

      if (response.statusCode == 200) {
        final dataModel = CheckoutPaymentModel.fromJson(response.data);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        final jsonData = json.decode(response.data);
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>?> getAllVendorTypes() async {
    const url = VendorApiEndpoints.vendorTypes;
    try {
      final response = await _apiResponseHandler.getDioRequest(url);
      if (response.statusCode == 200) {
        final jsonData =
            List<Map<String, dynamic>>.from(response.data['data']['roles']);
        return jsonData;
      } else {
        throw Exception('Failed to Vendor types');
      }
    } catch (e) {
      debugPrint('EXCEPTION :: ${e.toString()}');
      return null;
    }
  }

  Future<VendorPermissions> getAllVendorPermissions(int vendorId) async {
    const url = VendorApiEndpoints.vendorPermissions;
    try {
      final response =
          await _apiResponseHandler.getDioRequest('$url/$vendorId');

      if (response.statusCode == 200) {
        final permissions = response.data['data']['permissions'];
        return VendorPermissions.fromJson(permissions);
      }
      return const VendorPermissions();
    } catch (e) {
      debugPrint('EXCEPTION :: ${e.toString()}');
      return const VendorPermissions();
    }
  }

  Future<MetaDataResponse?> getAllMetaData(
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.meta;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token ?? '',
    };

    try {
      final response =
          await _apiResponseHandler.getDioRequest(url, headers: headers);

      if (response.statusCode == 200) {
        final dataModel = MetaDataResponse.fromJson(response.data);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        final jsonData = json.decode(response.data);
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      debugPrint('EXCEPTION :: ${e.toString()}');
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> previewAgreement(
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.meta;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token ?? '',
    };

    try {
      final response = await _apiResponseHandler.getDioRequest(
        url,
        headers: headers,
        // responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return response.data;
      } else {
        final jsonData = json.decode(response.data);
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<EmailResendResponse?> resendEmail(
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.emailResend;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token ?? '',
    };

    try {
      final response =
          await _apiResponseHandler.getDioRequest(url, headers: headers);

      if (response.statusCode == 200) {
        final dataModel = EmailResendResponse.fromJson(response.data);
        CustomSnackbar.showSuccess(context, dataModel.message);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        final jsonData = json.decode(response.data);
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SubscriptionPackageResponse?> getSubscriptionPackageDetails(
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.settings_subscription;

    try {
      final response = await _apiResponseHandler.getDioRequest(url);

      if (response.statusCode == 200) {
        final dataModel = SubscriptionPackageResponse.fromJson(response.data);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        final jsonData = json.decode(response.data);
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PaymentMethodsResponse?> getPaymentMethods(
    BuildContext context,
    String amount,
  ) async {
    _isLoading = true;
    notifyListeners();

    final url =
        '${VendorApiEndpoints.pay}?payment_type=subscription&amount=$amount';

    try {
      final response = await _apiResponseHandler.getDioRequest(url);

      if (response.statusCode == 200) {
        final dataModel = PaymentMethodsResponse.fromJson(response.data);
        _isLoading = false;
        notifyListeners();
        return dataModel;
      } else {
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> fetchUserData(BuildContext context) async {
    log('fetchUserData', name: 'VENDOR');
    notifyListeners();
    const url = ApiEndpoints.getCustomer;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('user response => $responseData');
        notifyListeners();
        return UserModel.fromJson(responseData['data']);
      } else {
        notifyListeners();
        return null;
      }
    } catch (error) {
      notifyListeners();
      return null;
    }
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
      final jsonData = response.data;
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
