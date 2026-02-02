import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/network/api_constants.dart';

class DioFactory {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          "Authorization":
              "Basic ${base64Encode(utf8.encode("testapp:5S0Q YjyH 4s3G elpe 5F8v u8as"))}",
          "Content-Type": "application/json",
        },
      ),
    );

    return dio;
  }
}
