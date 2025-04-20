class UploadImage {
  String Success;

  UploadImage({
    required this.Success,
  });

  factory UploadImage.fromJson(Map<String, dynamic> json) {
    return UploadImage(
      Success: json['Success'] ?? 'Unknown', // Correctly map 'Success'
    );
  }
}
