class Failure implements Exception {
  int code;
  String message;

  Failure(this.code, this.message);
}