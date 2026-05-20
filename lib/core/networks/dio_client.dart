import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lms/core/data/storage/token_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late Dio dio;
  DioClient() {
    dio = Dio(BaseOptions(baseUrl: "http://localhost:8000/api/"));

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
        filter: (options, args) {
          // don't print requests with uris containing '/posts'
          if (options.path.contains('/posts')) {
            return false;
          }
          // don't print responses with unit8 list data
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor());
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await TokenService.instance.getAccessToken();

    options.headers['Authorization'] = "Bearer $accessToken";

    super.onRequest(options, handler);
  }
}
