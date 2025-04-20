class SaveMaintainRequist {
  String Success;

  SaveMaintainRequist({
    required this.Success,
  });

  factory SaveMaintainRequist.fromJson(Map<String, dynamic> json) {
    return SaveMaintainRequist(
      Success: json['Success'] ?? 'Unknown',
    );
  }
}
