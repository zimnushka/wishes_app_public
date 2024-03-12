import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishes_app/repository/local/privat_key.secure.dart';

part 'extensions/auth_local_ext.dart';
part 'extensions/theme_local_ext.dart';

class LocalRepository {
  const LocalRepository();

  static String ivKey1 = '4ZttzHusKGs';
  static String ivKey2 = 'jzmdXA5+Viw==';

  static String __encrypt(String text) {
    final encrypterAES = Encrypter(AES(Key.fromBase64(privateKey), mode: AESMode.cbc));
    final encryptedAES = encrypterAES.encrypt(text, iv: IV.fromBase64('$ivKey1$ivKey2'));
    return encryptedAES.base64;
  }

  static String __decrypt(String text) {
    if (text.isEmpty) return text;

    final encrypterAES = Encrypter(AES(
      Key.fromBase64(privateKey),
      mode: AESMode.cbc,
      //padding: null,
    ));
    final decryptedAES = encrypterAES.decrypt(Encrypted.fromBase64(text), iv: IV.fromBase64('$ivKey1$ivKey2'));
    return decryptedAES;
  }

  Future<void> _write({required String key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, __encrypt(value));
  }

  Future<String?> _read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(key);
    if (val == null) return null;
    return __decrypt(val);
  }

  Future<void> _remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
