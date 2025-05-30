import 'package:event_app/data/vendor/data/response/apis_status.dart';

class ApiResponse<T> {
  ApiStatus? status;
  T? data;
  String? message;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.none() : status = ApiStatus.NONE;

  ApiResponse.loading() : status = ApiStatus.LOADING;

  ApiResponse.completed(this.data) : status = ApiStatus.COMPLETED;

  ApiResponse.error(this.message) : status = ApiStatus.ERROR;

  @override
  String toString() {
    return 'Status : $status \n Message : $message \n Data : $data';
  }
}
