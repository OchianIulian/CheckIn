import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  static const _refreshKey = 'refresh_token';
  final FlutterSecureStorage _storage;

  SecureTokenStorage(this._storage);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshKey, value: token);

  Future<String?> readRefreshToken() =>
      _storage.read(key: _refreshKey);

  Future<void> deleteRefreshToken() =>
      _storage.delete(key: _refreshKey);

}