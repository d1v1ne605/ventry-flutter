import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/data/datasources/local/auth/auth_local_datasource.dart';
import 'package:ventry_flutter/domain/repositories/auth/auth_repository.dart';

@singleton
class AuthNotifier extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AuthLocalDataSource _localDataSource;
  late final StreamSubscription _subscription;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  AuthNotifier(this._authRepository, this._localDataSource) {
    _init();
    _subscription = _authRepository.userStream.listen((user) {
      final wasAuthenticated = _isAuthenticated;
      _isAuthenticated = user != null;
      if (wasAuthenticated != _isAuthenticated) {
        notifyListeners();
      }
    });
  }

  Future<void> _init() async {
    final token = await _localDataSource.getAccessToken();
    if (token != null) {
      _isAuthenticated = true;
      // Optimistically fetch user data to ensure the token is still valid.
      // If it fails with 401, the interceptor will attempt a refresh.
      // If refresh fails, interceptor calls forceLogout() -> stream emits null -> state changes to unauthenticated.
      _authRepository.getMe();
    }
    _isInitialized = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
