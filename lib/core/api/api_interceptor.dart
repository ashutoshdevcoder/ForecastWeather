import 'package:dio/dio.dart';
import 'package:weather_forecast/core/utils/log.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.d('Request: ${options.method} ${options.path}');
    Log.d('Headers: ${options.headers}');
    if (options.data != null) {
      Log.d('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.d('Response: ${response.statusCode} ${response.statusMessage}');
    if (response.data != null) {
      Log.d('Body: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e('Error: ${err.message}');
    if (err.response != null) {
      Log.e('Response: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
