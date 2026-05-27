import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lms/core/data/storage/token_service.dart';
import 'package:lms/core/models/token_model.dart';
import 'package:lms/core/networks/network_constant.dart';
import 'package:lms/core/routes/route_name.dart';
import 'package:lms/main.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late Dio dio;
  DioClient() {
    dio = Dio(BaseOptions(baseUrl: kBaseUrl));

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );

    dio.interceptors.add(AuthInterceptor());
  }
}

class AuthInterceptor extends Interceptor {
  Completer<String?>? _completer;
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await TokenService.instance.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = "Bearer $accessToken";
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_completer == null) {
        _completer = Completer();

        final dio = Dio();
        final refreshToken = await TokenService.instance.refreshToken();

        try {
          final response = await dio.post(
            "${kBaseUrl}auth/token/refresh/",
            data: {"refresh": refreshToken},
          );
          final token = response.data;
          final tokenModel = TokenModel.fromMap(token);
          await TokenService.instance.save(tokenModel);
          _completer?.complete(tokenModel.accessToken);
        } catch (e) {
          _completer?.complete(null);
        }
      }

      final accessToken = await _completer?.future;

      if (accessToken != null) {
        try {
          err.requestOptions.headers['Authorization'] = "Bearer $accessToken";
          final response = await DioClient().dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        } finally {
          _completer = null;
        }
      }

      TokenService.instance.clearToken();

      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        RouteName.login,
        (_) => false,
      );

      _completer = null;

      return handler.next(err);
    }
    return handler.next(err);
  }
}
