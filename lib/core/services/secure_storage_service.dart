import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final storage = const FlutterSecureStorage();

  Future<void> setLoggedIn(bool value) async {
    await storage.write(key: 'loggedIn', value: value.toString());
  }

  Future<bool> isLoggedIn() async {
    final value = await storage.read(key: 'loggedIn');
    return value == 'true';
  }

  Future<void> clear() async {
    await storage.deleteAll();
  }
}
