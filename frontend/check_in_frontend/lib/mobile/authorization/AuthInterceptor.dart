import 'dart:async';
import 'package:check_in_frontend/mobile/authorization/MemoryTokenStorage.dart';
import 'package:dio/dio.dart';
import '../auth/AuthApi.dart';
import 'SecureTokenStorage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStore _tokenStore;
  final SecureTokenStorage _secureStorage;
  final AuthApi _authApi;

  Completer<void>? _refreshCompleter;

  AuthInterceptor(this._tokenStore, this._secureStorage, this._authApi);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = _tokenStore.accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    final isAuthCall = requestOptions.path.contains('/auth/');

    if (status == 401 || isAuthCall){
      handler.next(err);
      return;
    }

    try {
      // Daca deja se face refresh, asteapta-l
      if (_refreshCompleter != null) {
        await _refreshCompleter!.future;
      } else {
        _refreshCompleter = Completer<void>();
        await _performRefresh();
        _refreshCompleter!.complete();
        _refreshCompleter = null;
      }

      // Reincearca requestul initial cu noul token
      final dio = err.requestOptions
          .extra['dio'] as Dio?; // optional, daca vrei sa-l injectezi
      // Cel mai simplu: folosim un Dio nou din err.requestOptions (nu exista direct),
      // deci recomand sa pastrezi o referinta la Dio in clasa interceptor daca preferi.


      // Rebuild request
      final newAccess = _tokenStore.accessToken;
      final opts = Options(
        method: requestOptions.method,
        headers: Map<String, dynamic>.from(requestOptions.headers),
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        followRedirects: requestOptions.followRedirects,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      );

      if (newAccess != null) {
        opts.headers?['Authorization'] = 'Bearer $newAccess';
      }

      // Folosim un Dio global pasat in extra (vezi setup mai jos)
      final client = requestOptions.extra['client'] as Dio;
      final response = await client.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: opts,
      );
    } catch (e) {
      // Refresh a esuat => user trebuie delogat
      handler.next(err);
    }
  }

  Future<void> _performRefresh() async {
    final refreshToken = await _secureStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError('No refresh token');
    }

    final tokens = await _authApi.refresh(refreshToken: refreshToken);

    // Update: JWT in memorie
    _tokenStore.setAccessToken(tokens.accessToken);

    // Daca backend face rotation, suprascrii refresh tokenul
    await _secureStorage.saveRefreshToken(tokens.refreshToken);
  }

}