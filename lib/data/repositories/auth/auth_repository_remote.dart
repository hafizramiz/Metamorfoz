// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:logging/logging.dart';

import '../../../utils/result.dart';
import '../../services/api/api_client.dart';
import '../../services/api/auth_api_client.dart';
import '../../services/api/model/login_request/login_request.dart';
import '../../services/api/model/login_response/login_response.dart';
import '../../services/shared_preferences_service.dart';
import 'auth_repository.dart';

/// Kullanici login oldugunda [_isAuthenticated] true olacagi icin
/// router icindeki _redirect metotu burasini dinleyerek redirection'i
/// gerceklestiriyor.

/// Aslinda butun redirection burda yapilmasi gerekiyor


class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required ApiClient apiClient,
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiClient = apiClient,
        _authApiClient = authApiClient,
        _sharedPreferencesService = sharedPreferencesService {
    _apiClient.authHeaderProvider = _authHeaderProvider;
  }

  final AuthApiClient _authApiClient;
  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;
  String? _authToken;
  final _log = Logger('AuthRepositoryRemote');

  /// Fetch token from shared preferences
  ///  Fetch metotu ile local database'den token elde edilir.
  ///  Daha sonra bu token bilgisine gore kullanici login olmus mu olmamis mi
  ///  ona gore yonlendirme yapilir.
  Future<void> _fetch() async {
  // await Future.delayed(Duration(seconds: 10));
    /// Burda local service gidip token'i elde ederiz.
    print("fetch token from shared preferences");
    final result = await _sharedPreferencesService.fetchToken();

    /// Burda token'i elde ettikten sonra bu token bilgisine gore authenticate olup olmadigi
    /// bilinir.
    /// Highsmart orneginde burasi soyle olacak
    /// Local database'den secured token elde edilir. Elde edilen token ile
    /// Yeni refreshToken istegi atilir. Donen sonuca gore refresh token singleton icinde
    /// access token ise local database'e kaydedilir.
    /// Daha sonra isAuthenticate true yapilir.
    switch (result) {
      case Ok<String?>():
        _authToken = result.value;
        _isAuthenticated = result.value != null;
        print(_isAuthenticated);
      case Error<String?>():
        _log.severe(
          'Failed to fech Token from SharedPreferences',
          result.error,
        );
    }
  }

  /// [isAuthenticated] baslangicta null'dir.

  @override
  Future<bool> get isAuthenticated async {
   // await Future.delayed(Duration(seconds: 3));
    print("isAuthenticated: $_isAuthenticated ");
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    await _fetch();
    return _isAuthenticated ?? false;
  }

  /// Burda login metotundan cikan sonucu da yine SecondResponseModel ile
  /// donduruyoruz.
  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      print("login reguest");
      final result = await _authApiClient.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );
      switch (result) {
        case Ok<LoginResponse>():
          _log.info('User logged int');
          // Set auth status
          _isAuthenticated = true;
          _authToken = result.value.token;
          // Store in Shared preferences
          return await _sharedPreferencesService.saveToken(result.value.token);
        case Error<LoginResponse>():
          // _log.warning('Error logging in: ${result.error}');
          // return Result.error(result.error);
          /// Diyelim ki hata olmadi basarili oldu login islemi
          /// Akis nasil olacak?
          _log.info('User logged int');
          // Set auth status
          _isAuthenticated = true;
          _authToken = "result.value.token";
          // Store in Shared preferences
          return await _sharedPreferencesService
              .saveToken("result.value.token");
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    _log.info('User logged out');
    try {
      /// Burda Cikis yapilinca local database'den token silinir.
      // Clear stored auth token
      final result = await _sharedPreferencesService.saveToken(null);
      if (result is Error<void>) {
        _log.severe('Failed to clear stored auth token');
      }

      // Clear token in ApiClient
      _authToken = null;

      // Clear authenticated status
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }

  String? _authHeaderProvider() =>
      _authToken != null ? 'Bearer $_authToken' : null;
}
