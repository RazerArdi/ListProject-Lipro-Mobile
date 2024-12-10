import 'package:encrypt/encrypt.dart' as encrypt;

/// Encrypt a plain text string using AES256 encryption
String encryptString(String plainText, String secretKey) {
  final key = encrypt.Key.fromUtf8(secretKey.padRight(32)); // AES256 requires a 32-byte key
  final iv = encrypt.IV.fromLength(16); // 16-byte IV
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

/// Decrypt an encrypted base64 string using AES256 decryption
String decryptString(String encryptedText, String secretKey) {
  final key = encrypt.Key.fromUtf8(secretKey.padRight(32)); // AES256 requires a 32-byte key
  final iv = encrypt.IV.fromLength(16); // 16-byte IV
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
  return decrypted;
}
