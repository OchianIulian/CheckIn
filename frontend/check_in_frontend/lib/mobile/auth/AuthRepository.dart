import 'package:check_in_frontend/mobile/authorization/MemoryTokenStorage.dart';

import '../authorization/SecureTokenStorage.dart';
import 'AuthApi.dart';

class AuthRepository {
  final AuthApi _api;
  final SecureTokenStorage _secure;
  final TokenStore _tokenStore;

  AuthRepository(this._api, this._secure, this._tokenStore);

  Future<void> requestOtp({required String phone}) async {
    await _api.clientRequestOtp(phone: phone);
  }

  Future<void> verifyOtp({required String phone, required String otp}) async {
    final tokens = await _api.clientVerifyOtp(phone: phone, otp: otp);
    // Refresh token in secure storage
    await _secure.saveRefreshToken(tokens.refreshToken);
    // JWT in memory
    _tokenStore.setAccessToken(tokens.accessToken);
  }

  Future<void> logout() async {
    _tokenStore.clear();
    await _secure.deleteRefreshToken();
  }

}