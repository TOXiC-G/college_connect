import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();

  factory DioClient() {
    return _singleton;
  }

  Dio _dio;

  Dio get dio => _dio;

  DioClient._internal() : _dio = Dio() {
    BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.0.105:8000/",
      // baseUrl: "http://147.185.221.17:22244/",
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
    );
    _dio = Dio(options);
  }

  Future<void> setAuthorizationHeader() async {
    final secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'accessToken');
    if (token != null) {
      String tokenString = token.toString();
      _dio.options.headers['Authorization'] = 'Bearer $tokenString';
    }
  }
}
