import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> deleteAccessToken();
  Future<void> clearAll();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  static const String _accessTokenKey = 'access_token';

  AuthLocalDataSourceImpl() : _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
