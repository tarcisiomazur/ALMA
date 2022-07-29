class APIResponse<T>{
  T? data;
  bool error;
  int? errorCode;
  String? errorMessage;

  APIResponse({this.data, this.error=false, this.errorCode, this.errorMessage});

}