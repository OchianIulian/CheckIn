import 'package:check_in_frontend/mobile/authorization/ApiRoutes.dart';
import 'package:check_in_frontend/mobile/authorization/AuthTokens.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  Future<void> clientRequestOtp({required String phone}) async {
    await _dio.post(
        ApiRoutes.authClient,
        data: {'phone': phone}
    );
  }

  Future<AuthTokens> clientVerifyOtp({required String phone, required String otp}) async {
    final response = await _dio.post(
        ApiRoutes.authVerifyOtp,
        data: {
          'phone': phone,
          'otp': otp
        }
    );
    return AuthTokens.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthTokens> refresh({
    required String refreshToken,
  }) async {
    final res = await _dio.post(
      ApiRoutes.clientRefresh,
      data: {'refreshToken': refreshToken},
    );
    return AuthTokens.fromJson(res.data as Map<String, dynamic>);
  }
}