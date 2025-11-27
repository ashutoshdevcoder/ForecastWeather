
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> getData(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Handle Dio specific errors
      throw Exception('Failed to get data: $e');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
