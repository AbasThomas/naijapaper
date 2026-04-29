import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

/// JwtInterceptor — Auto-refresh JWT on 401 responses
class JwtInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  JwtInterceptor(this._dio, this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for auth endpoints
    if (options.path.contains('/auth/')) {
      return handler.next(options);
    }

    // Add access token to headers
    final accessToken = await _secureStorage.read(key: ApiConstants.accessTokenKey);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip refresh for auth endpoints
    if (err.requestOptions.path.contains('/auth/')) {
      return handler.next(err);
    }

    try {
      // Attempt to refresh the token
      final refreshToken = await _secureStorage.read(key: ApiConstants.refreshTokenKey);
      
      if (refreshToken == null) {
        // No refresh token available — user needs to log in again
        await _clearTokens();
        return handler.next(err);
      }

      // Call refresh endpoint
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
        ),
      );

      // Save new tokens
      final newAccessToken = response.data['access_token'] as String;
      final newRefreshToken = response.data['refresh_token'] as String?;
      
      await _secureStorage.write(
        key: ApiConstants.accessTokenKey,
        value: newAccessToken,
      );
      
      if (newRefreshToken != null) {
        await _secureStorage.write(
          key: ApiConstants.refreshTokenKey,
          value: newRefreshToken,
        );
      }

      // Retry the original request with new token
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      
      final cloneReq = await _dio.fetch(opts);
      return handler.resolve(cloneReq);
      
    } catch (e) {
      // Refresh failed — clear tokens and force re-login
      await _clearTokens();
      return handler.next(err);
    }
  }

  /// Clear all stored tokens
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: ApiConstants.accessTokenKey);
    await _secureStorage.delete(key: ApiConstants.refreshTokenKey);
    await _secureStorage.delete(key: ApiConstants.userIdKey);
  }
}
