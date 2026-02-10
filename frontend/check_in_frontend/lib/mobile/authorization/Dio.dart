import 'package:check_in_frontend/mobile/auth/AuthApi.dart';
import 'package:dio/dio.dart';
import 'AuthInterceptor.dart';
import 'MemoryTokenStorage.dart';
import 'SecureTokenStorage.dart';

Dio createDioClient({
  required String baseUrl,
  required TokenStore tokenStore,
  required SecureTokenStorage secureStorage}) {
  final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15)));

  final authApi = AuthApi(dio);
  
  dio.interceptors.add(AuthInterceptor(tokenStore, secureStorage, authApi),);

  // Important: ca interceptorul sa poata re-incerca requestul
  // ii dam acces la acelasi client prin "extra"
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['client'] = dio;
        handler.next(options);
      },
    ),
  );
//todo: sa inteleg cum se face reincarcarea requestului de la linia 23
  return dio;

}