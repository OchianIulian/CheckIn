import 'package:check_in_frontend/mobile/auth/AuthApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/AuthRepository.dart';
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

void exampleWiring() {
  final tokenStore = TokenStore();
  final secure = SecureTokenStorage(const FlutterSecureStorage());

  final dio = createDioClient(
    baseUrl: 'https://api.example.com',
    tokenStore: tokenStore,
    secureStorage: secure,
  );

  final authRepo = AuthRepository(AuthApi(dio), secure, tokenStore);

  // authRepo.login(email, password);
}
