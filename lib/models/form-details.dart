class FormsDetailsData {
  FormsDetailsData(
    this.FormID,
    this.FormItemText,
    this.FormItemValue, //الفاحص
    this.FormEntryIDName,
  );
  final String FormID;
  final String FormItemText;
  final String FormItemValue;
  final String FormEntryIDName;

  factory FormsDetailsData.fromJson(Map<String, dynamic> json) {
    return FormsDetailsData(
      json['FormID'],
      json['FormItemText'],
      json['FormItemValue'],
      json['FormEntryIDName'],
    );
  }
}
