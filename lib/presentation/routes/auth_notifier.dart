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
  final Completer<void> _initializationCompleter = Completer<void>();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  Future<void> get initializationComplete => _initializationCompleter.future;

  AuthNotifier(this._authRepository, this._localDataSource) {
    _subscription = _authRepository.userStream.listen((user) {
      final wasAuthenticated = _isAuthenticated;
      _isAuthenticated = user != null;
      if (wasAuthenticated != _isAuthenticated) {
        notifyListeners();
      }
    });
    _init();
  }

  Future<void> _init() async {
    try {
      final token = await _localDataSource.getAccessToken();
      if (token != null) {
        final result = await _authRepository.getMe();
        result.fold((_) {
          _isAuthenticated = false;
          _authRepository.forceLogout();
        }, (_) => _isAuthenticated = true);
      }
    } finally {
      _isInitialized = true;
      if (!_initializationCompleter.isCompleted) {
        _initializationCompleter.complete();
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
