import 'package:dio/dio.dart';
import 'package:event_app/models/vendor_models/products/create_product/upload_images_data_response.dart';
import 'package:event_app/models/vendor_models/products/holder_models/upload_images_model.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../data/vendor/data/response/ApiResponse.dart';

class VendorUploadImagesViewModel with ChangeNotifier {
  String? _token;

  Future<void> setToken() async {
    _token = await SecurePreferencesUtil.getToken();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  final _myRepo = VendorRepository();
  ApiResponse<UploadImagesDataResponse> _apiResponse = ApiResponse.none();

  ApiResponse<UploadImagesDataResponse> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<UploadImagesDataResponse> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<List<UploadImagesModel?>> uploadAllImages(
      BuildContext context, List<UploadImagesModel> images,) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      final Map<String, String> headers = {
        'Authorization': _token!,
        'Content-Type': 'multipart/form-data',
      };

      // Create a list of upload tasks for each image
      final List<Future<UploadImagesModel?>> uploadTasks =
          images.map((image) async {
        final formData = FormData();
        formData.files.add(
          MapEntry(
            'file[0]',
            await MultipartFile.fromFile(
              image.file.path,
              filename: image.fileName,
            ),
          ),
        );

        return _myRepo
            .vendorUploadImages(headers: headers, formData: formData)
            .then((response) {
          print('upload data ==> ${response.data}');

          image.serverFullUrl = response.data?.fullUrl ?? '';
          image.serverUrl = response.data?.url ?? '';
          image.serverID = response.data?.id ?? 0;
          image.serverName = response.data?.name ?? '';
          image.serverBaseName = response.data?.basename ?? '';
          image.uploaded = true;
          image.hasFile = false;

          return image;
        }).catchError((error) {
          print(error.toString());
          return UploadImagesModel();
        });
      }).toList();

      // Execute all uploads concurrently
      final List<UploadImagesModel?> results = await Future.wait(uploadTasks);

      // Handle overall result
      if (results.any((e) => e?.file == null)) {
        AlertServices.showErrorSnackBar(
            message: 'Some images failed to upload', context: context,);
      } else {
        AlertServices.showSuccessSnackBar(
          message: 'All images uploaded successfully',
          context: context,
        );
      }
      return results;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(
          message: error.toString(), context: context,);
      return [];
    } finally {
      setLoading(false);
    }
  }
}
