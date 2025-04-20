class NotificationData {
  final String message;

  NotificationData({required this.message});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      message: json['Message'] ?? 'No message available',
    );
  }

  @override
  String toString() {
    return 'NotificationData(message: $message)';
  }
}
