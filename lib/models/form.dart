class FormData {
  FormData(
    this.EqupID,
    this.FormID,
    this.FormIDISO,
    this.FormEntryIDName,
  );
// FormIDISO
  final String EqupID;
  final String FormID;
  final String FormIDISO;
  final String FormEntryIDName;

  factory FormData.fromJson(Map<String, dynamic> json) {
    return FormData(
      json['EqupID'],
      json['FormID'],
      json['FormIDISO'],
      json['FormEntryIDName'],
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "EqupID": EqupID,
  //       "FormID": FormID,
  //        "FormIDISO": FormIDISO,
  //       "FormEntryIDName": FormEntryIDName,
  //     };
}
