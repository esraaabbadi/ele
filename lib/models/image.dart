// "Base64"
class ImageBase64 {
  final String Base64;

  ImageBase64(this.Base64);

  factory ImageBase64.fromJson(Map<String, dynamic> json) {
    return ImageBase64(
      json['Base64'],
    );
  }
}
