import 'package:dio/dio.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/models/vendor_models/common_models/common_post_request_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/attribute_sets_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/create_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/global_options_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/product_post_data_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_get_product_tags_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_get_seo_keywords_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/edit_product/edit_variations_data_response.dart';
import 'package:event_app/models/vendor_models/products/vendor_get_product_general_settings_model.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/api_response.dart';
import '../../../models/vendor_models/products/edit_product/new_product_view_data_response.dart';

class VendorCreateProductViewModel with ChangeNotifier {
  String? _token;

  Future<void> loadUserSettings() async {
    _token = await SecurePreferencesUtil.getToken();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  final _myRepo = VendorRepository();

  /// ***------------ Vendor get product general settings start ---------------***ApiResponse<VendorGetProductGeneralSettingsModel> _generalSettingsApiResponse = ApiResponse.none();

  ApiResponse<VendorGetProductGeneralSettingsModel> _generalSettingsApiResponse = ApiResponse.none();

  ApiResponse<VendorGetProductGeneralSettingsModel> get generalSettingsApiResponse => _generalSettingsApiResponse;

  set setGeneralSettingsApiResponse(
    ApiResponse<VendorGetProductGeneralSettingsModel> response,
  ) {
    _generalSettingsApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGetProductGeneralSettings() async {
    try {
      setLoading(true);
      setGeneralSettingsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final VendorGetProductGeneralSettingsModel response =
          await _myRepo.vendorGetProductGeneralSettings(headers: headers);
      setGeneralSettingsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      setGeneralSettingsApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor get product general settings end ---------------***

  /// ***------------ Vendor get all attributes set start ---------------***
  ApiResponse<AttributeSetsDataResponse> _attributeSetsApiResponse = ApiResponse.none();

  ApiResponse<AttributeSetsDataResponse> get attributeSetsApiResponse => _attributeSetsApiResponse;

  set setAttributeSetsApiResponse(
    ApiResponse<AttributeSetsDataResponse> response,
  ) {
    _attributeSetsApiResponse = response;
    notifyListeners();
  }

  Future<bool> getAttributeSetsData() async {
    try {
      setLoading(true);
      setAttributeSetsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final AttributeSetsDataResponse response = await _myRepo.vendorProductAttributeSets(headers: headers);
      setAttributeSetsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      setAttributeSetsApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor get all attributes set end ---------------***

  /// ***------------ Vendor get product tags start ---------------***
  ApiResponse<VendorGetProductTagsModel> _productTagsApiResponse = ApiResponse.none();

  ApiResponse<VendorGetProductTagsModel> get productTagsApiResponse => _productTagsApiResponse;

  set setProductTagsApiResponse(
    ApiResponse<VendorGetProductTagsModel> response,
  ) {
    _productTagsApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGetProductTags() async {
    try {
      setLoading(true);
      setProductTagsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final VendorGetProductTagsModel response = await _myRepo.vendorGetProductTags(headers: headers);
      setProductTagsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      setProductTagsApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor get product tags end ---------------***

  /// ***------------ Vendor create product slug start ---------------***
  ApiResponse<CommonPostRequestModel> _vendorCreateSlugApiResponse = ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get vendorCreateSlugApiResponse => _vendorCreateSlugApiResponse;

  set setVendorCreateSlugApiResponse(
    ApiResponse<CommonPostRequestModel> response,
  ) {
    _vendorCreateSlugApiResponse = response;
    notifyListeners();
  }

  Future<String?> vendorCreateProductSlug({
    required String productName,
    String? slugID,
    String? productID,
    required BuildContext context,
  }) async {
    try {
      setLoading(true);
      setVendorCreateSlugApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };
      final Map<String, dynamic> body = <String, dynamic>{
        'value': productName.toString(),

        ///String (Required)
        'slug_id': slugID?.toString() ?? '0',

        ///Numeric (Required) Default 0, During edit product or package send original slug id
        'ref_from': productID?.toString() ?? '',

        ///Numeric (Required during edit otherwise you get wrong slug value else Optional)
        // 'ref_lang': ///String (en, ar)
      };
      final CommonPostRequestModel response = await _myRepo.vendorCreateProductSlug(headers: headers, body: body);
      setVendorCreateSlugApiResponse = ApiResponse.completed(response);
      setLoading(false);

      final String? slugData = response.data != null ? response.data as String : null;

      return slugData;
    } catch (error) {
      setVendorCreateSlugApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return null;
    }
  }

  /// ***------------ Vendor create product slug end ---------------***

  /// ***------------ Vendor get global options start ---------------***
  ApiResponse<GlobalOptionsDataResponse> _globalOptionsApiResponse = ApiResponse.none();

  ApiResponse<GlobalOptionsDataResponse> get globalOptionsApiResponse => _globalOptionsApiResponse;

  set setGlobalOptionsApiResponse(
    ApiResponse<GlobalOptionsDataResponse> response,
  ) {
    _globalOptionsApiResponse = response;
    notifyListeners();
  }

  Future<GlobalOptionsDataResponse?> getGlobalOptions(String optionId) async {
    try {
      setLoading(true);
      setGlobalOptionsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final Map<String, String> queryParams = {
        'id': optionId,
      };

      final GlobalOptionsDataResponse response = await _myRepo.getGlobalOptions(
        headers: headers,
        queryParams: queryParams,
      );
      setGlobalOptionsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return response;
    } catch (error) {
      setGlobalOptionsApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return null;
    }
  }

  /// ***------------ Vendor get global options end ---------------***

  /// ***------------ Vendor product search start ---------------***
  ApiResponse<VendorSearchProductDataResponse> _productSearchApiResponse = ApiResponse.none();

  ApiResponse<VendorSearchProductDataResponse> get productSearchApiResponse => _productSearchApiResponse;

  set setProductSearchApiResponse(
    ApiResponse<VendorSearchProductDataResponse> response,
  ) {
    _productSearchApiResponse = response;
    notifyListeners();
  }

  Future<VendorSearchProductDataResponse?> productSearch(
    String text,
    String productID,
  ) async {
    try {
      setLoading(true);
      setGlobalOptionsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final Map<String, String> queryParams = {
        'page': '1',
        'per-page': '10',
      };
      if (text.isNotEmpty) {
        queryParams['search'] = text;
      }

      if (productID.isNotEmpty) {
        queryParams['product_id'] = productID;
      }

      final VendorSearchProductDataResponse response =
          await _myRepo.searchProducts(headers: headers, queryParams: queryParams);
      setProductSearchApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return response;
    } catch (error) {
      setProductSearchApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return null;
    }
  }

  /// ***------------ Vendor product search end ---------------***

  /// ***------------ Vendor get product seo keywords start ---------------***
  ApiResponse<VendorGetSeoKeywordsModel> _vendorGetSeoKeywordsApiResponse = ApiResponse.none();

  ApiResponse<VendorGetSeoKeywordsModel> get vendorGetSeoKeywordsApiResponse => _vendorGetSeoKeywordsApiResponse;

  set setVendorGetSeoKeywordsApiResponse(
    ApiResponse<VendorGetSeoKeywordsModel> response,
  ) {
    _vendorGetSeoKeywordsApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGetProductSeoKeywords({
    required BuildContext context,
  }) async {
    try {
      setLoading(true);
      setVendorGetSeoKeywordsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };
      final VendorGetSeoKeywordsModel response = await _myRepo.vendorGetProductSeoKeywords(headers: headers);
      setVendorGetSeoKeywordsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      setVendorGetSeoKeywordsApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor get product seo keywords end ---------------***

  /// ***------------ Vendor create product api start ---------------***
  ApiResponse<CreateProductDataResponse> _vendorCreateProductApiResponse = ApiResponse.none();

  ApiResponse<CreateProductDataResponse> get vendorCreateProductApiResponse => _vendorCreateProductApiResponse;

  set setCreateProductApiResponse(
    ApiResponse<CreateProductDataResponse> response,
  ) {
    _vendorCreateProductApiResponse = response;
    notifyListeners();
  }

  Future<bool> createProduct({
    required BuildContext context,
    required ProductPostDataModel productPostDataModel,
  }) async {
    try {
      setLoading(true);
      _vendorCreateProductApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
        'Content-Type': 'application/json',
      };
      // Convert to Map<String, dynamic>
      final FormData formDataMap = productPostDataModel.toFormData();
      final body = formDataMap;
      final CreateProductDataResponse response = await _myRepo.createProduct(
        headers: headers,
        body: body,
      );
      _vendorCreateProductApiResponse = ApiResponse.completed(response);
      AppUtils.showToast(response.message.toString(), isSuccess: true);
      setLoading(false);
      return true;
    } catch (error) {
      _vendorCreateProductApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor create product api end ---------------***

  /// ***------------ Vendor create product api start ---------------***
  ApiResponse<NewProductViewDataResponse> _vendorProductViewApiResponse = ApiResponse.none();

  ApiResponse<NewProductViewDataResponse> get vendorProductViewApiResponse => _vendorProductViewApiResponse;

  set setProductViewApiResponse(
    ApiResponse<NewProductViewDataResponse> response,
  ) {
    _vendorProductViewApiResponse = response;
    notifyListeners();
  }

  Future<bool> getProductView(BuildContext context, String productId) async {
    try {
      setLoading(true);
      _vendorProductViewApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final NewProductViewDataResponse response = await _myRepo.productView(
        productId: productId,
        headers: headers,
      );
      _vendorProductViewApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      _vendorProductViewApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor create product api start ---------------***
  ApiResponse<EditVariationsDataResponse> _editVariationsApiResponse = ApiResponse.none();

  ApiResponse<EditVariationsDataResponse> get editVariationsApiResponse => _editVariationsApiResponse;

  set setEditVariationsApiResponse(
    ApiResponse<EditVariationsDataResponse> response,
  ) {
    _editVariationsApiResponse = response;
    notifyListeners();
  }

  Future<bool> getEditVariations(
    BuildContext context,
    String productVariationId,
  ) async {
    try {
      setLoading(true);
      _editVariationsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final EditVariationsDataResponse response = await _myRepo.editVariations(
        productVariationId: productVariationId,
        headers: headers,
      );
      _editVariationsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      _vendorProductViewApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }

  Future<bool> updateVariations(
    BuildContext context,
    String productVariationId,
  ) async {
    try {
      setLoading(true);
      _editVariationsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final EditVariationsDataResponse response = await _myRepo.editVariations(
        productVariationId: productVariationId,
        headers: headers,
      );
      _editVariationsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      _vendorProductViewApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor view product api end ---------------***

  /// ***------------ Vendor update product start ---------------***
  ApiResponse<CommonPostRequestModel> _vendorUpdateProductApiResponse = ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get vendorUpdateProductApiResponse => _vendorUpdateProductApiResponse;

  set _setVendorUpdateProductApiResponse(
    ApiResponse<CommonPostRequestModel> response,
  ) {
    _vendorUpdateProductApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorUpdateProduct({
    required BuildContext context,
    required String productID,
    required ProductPostDataModel productPostDataModel,
  }) async {
    try {
      setLoading(true);
      _setVendorUpdateProductApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };
      final FormData formDataMap = productPostDataModel.toFormData();
      final body = formDataMap;

      final CommonPostRequestModel response = await _myRepo.vendorUpdateProduct(
        headers: headers,
        body: body,
        productID: productID,
      );
      _setVendorUpdateProductApiResponse = ApiResponse.completed(response);

      AppUtils.showToast(response.message.toString(), isSuccess: true);
      setLoading(false);
      return true;
    } catch (error) {
      _setVendorUpdateProductApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }

  ApiResponse<CommonPostRequestModel> _attributeToExistingProductApiResponse = ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get attributeToExistingProductApiResponse =>
      _attributeToExistingProductApiResponse;

  set _setAttributeToExistingProductApiResponse(
    ApiResponse<CommonPostRequestModel> response,
  ) {
    _attributeToExistingProductApiResponse = response;
    notifyListeners();
  }

  Future<CommonPostRequestModel?> addAttributeToExistingProduct({
    required BuildContext context,
    required String productID,
    required List<Map<String, dynamic>> attributes,
  }) async {
    try {
      setLoading(true);
      _setAttributeToExistingProductApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      // Extract `id` and `value_id` lists
      final List<int> attributeSets = attributes.map((e) => e['id'] as int).toList();
      final List<int> attributeValues = attributes.map((e) => e['value_id'] as int).toList();

      final data = FormData.fromMap({
        'added_attribute_sets[]': attributeSets,
        'added_attributes[]': attributeValues,
      });

      final CommonPostRequestModel response = await _myRepo.addAttributeToExistingProduct(
        headers: headers,
        productId: productID,
        body: data,
      );
      _setAttributeToExistingProductApiResponse = ApiResponse.completed(response);

      AppUtils.showToast(response.message.toString(), isSuccess: true);
      setLoading(false);
      return response;
    } catch (error) {
      _setAttributeToExistingProductApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return null;
    }
  }

  /// ***------------ Vendor update product end ---------------***
}
