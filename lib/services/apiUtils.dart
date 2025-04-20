import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:equapp/shared/settings.dart' as settings;

void setHeader(body) {
  body = convertToMd5(body);
  String xDate = dateToUtc();
  String xToken = convertToHMac(// 0-10 +.+ 0-10
      "${convertToHMac( //hmac result ==> xDate 0-10
              convertToBase64( //base 64 result
                  convertToMd5(xDate))) //md5 result
          .toString().substring(0, 10)}.${convertToHMac( //hmac ==> body 0-10
          convertToBase64( //base 64
              convertToMd5( // md5
                  body.toString()))).toString().substring(0, 10)}");

  settings.headers = {
    'Content-Type': 'application/json',
    'X-Token': xToken,
    'X-Body': body.toString(),
    'X-Timestamp': xDate,
  };
}

String dateToUtc() {
  final dateUtc = DateTime.now().toUtc();

  String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateUtc);

  return replaceNumbers(formattedTimestamp);
}

String replaceNumbers(value) {
  value = value.replaceAll(RegExp(r'٠'), '0');
  value = value.replaceAll(RegExp(r'١'), '1');
  value = value.replaceAll(RegExp(r'٢'), '2');
  value = value.replaceAll(RegExp(r'٣'), '3');
  value = value.replaceAll(RegExp(r'٤'), '4');
  value = value.replaceAll(RegExp(r'٥'), '5');
  value = value.replaceAll(RegExp(r'٦'), '6');
  value = value.replaceAll(RegExp(r'٧'), '7');
  value = value.replaceAll(RegExp(r'٨'), '8');
  value = value.replaceAll(RegExp(r'٩'), '9');

  return value;
}

String convertToMd5(value) {
  String originalString = value;

  // Convert the string to bytes
  List<int> bytes = utf8.encode(originalString);

  // Generate the MD5 hash
  Digest digest = md5.convert(bytes);

  // Convert the hash to a hexadecimal string
  String md5Hash = digest.toString();
  return md5Hash;
}

String convertToBase64(String value) {
  // Convert the string to bytes
  List<int> bytes = utf8.encode(value);

  // Encode the bytes to Base64
  String base64String = base64Encode(bytes);

  return base64String;
}

String convertToHMac(value) {
  String originalString = value;
  String secretKey = value; // Replace with your actual secret key

  // Convert the string and key to bytes
  List<int> bytes = utf8.encode(originalString);
  List<int> key = utf8.encode(secretKey);

  // Generate the HMAC using SHA256
  Hmac hmacSha256 = Hmac(sha256, key); // You can use other hash algorithms too
  Digest digest = hmacSha256.convert(bytes);

  // Convert the HMAC to a hexadecimal string
  String hmac = digest.toString();

  return hmac;
}
