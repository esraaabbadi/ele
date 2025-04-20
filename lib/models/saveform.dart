class SaveForm {
  String Success;
  String subFormID;
  SaveForm({
    required this.subFormID,
    required this.Success,
    required success,
  });

  factory SaveForm.fromJson(Map<String, dynamic> json) {
    return SaveForm(
      Success: json['Success'] ?? 'Unknown',
      subFormID: json['SubFormID'] ?? 'N/A',
      success: null,
    );
  }
}
