import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/auth_user.dart';

/// AuthRepository — Handles all authentication operations
class AuthRepository {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepository({
    DioClient? dioClient,
    FlutterSecureStorage? secureStorage,
  })  : _dioClient = dioClient ?? DioClient.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Send OTP to phone number
  Future<void> sendOtp(String phoneNumber) async {
    await _dioClient.post(
      ApiConstants.sendOtp,
      data: {'phone': phoneNumber},
    );
  }

  /// Verify OTP and get tokens
  Future<AuthUser> verifyOtp(String phoneNumber, String otp) async {
    final response = await _dioClient.post(
      ApiConstants.verifyOtp,
      data: {
        'phone': phoneNumber,
        'otp': otp,
      },
    );

    await _saveTokens(
      response.data['access_token'] as String,
      response.data['refresh_token'] as String,
    );

    return AuthUser.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  /// Google OAuth sign in
  Future<AuthUser> googleSignIn(String googleToken) async {
    final response = await _dioClient.post(
      ApiConstants.googleAuth,
      data: {'token': googleToken},
    );

    await _saveTokens(
      response.data['access_token'] as String,
      response.data['refresh_token'] as String,
    );

    return AuthUser.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  /// Apple Sign In
  Future<AuthUser> appleSignIn(String appleToken) async {
    final response = await _dioClient.post(
      ApiConstants.appleAuth,
      data: {'token': appleToken},
    );

    await _saveTokens(
      response.data['access_token'] as String,
      response.data['refresh_token'] as String,
    );

    return AuthUser.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  /// Get current user
  Future<AuthUser> getCurrentUser() async {
    final response = await _dioClient.get(ApiConstants.userMe);
    return AuthUser.fromJson(response.data as Map<String, dynamic>);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: ApiConstants.accessTokenKey);
    return token != null;
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _dioClient.post(ApiConstants.logout);
    } catch (e) {
      // Continue with local logout even if API call fails
    }
    await _clearTokens();
  }

  /// Save tokens to secure storage
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(
      key: ApiConstants.accessTokenKey,
      value: accessToken,
    );
    await _secureStorage.write(
      key: ApiConstants.refreshTokenKey,
      value: refreshToken,
    );
  }

  /// Clear all tokens
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: ApiConstants.accessTokenKey);
    await _secureStorage.delete(key: ApiConstants.refreshTokenKey);
    await _secureStorage.delete(key: ApiConstants.userIdKey);
  }
}
