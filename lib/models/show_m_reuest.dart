class ShowMaintenanceRequestDetails {
  ShowMaintenanceRequestDetails(
    this.EntryDate,
    this.EntryTime,
    this.EqupID,
    this.EntryName,
    this.Status,
    this.SRDesc,
    this.AttID,
  );
  final String EntryDate;
  final String EntryTime;
  final String EqupID;
  final String EntryName;
  final String Status;
  final String SRDesc;
  final String AttID;

  factory ShowMaintenanceRequestDetails.fromJson(Map<String, dynamic> json) {
    return ShowMaintenanceRequestDetails(
      json['EntryDate'],
      json['EntryTime'],
      json['EqupID'],
      json['EntryName'],
      json['Status'],
      json['SRDesc'],
      json['AttID'],
    );
  }
}
//  {
//          "SRResponses": " ",
//          "ServiceID": "",
//          "AttID": "AttID",
//          "SectionAdminID": "90013234",
//          "DepAdminID": "90013234",
//          "GroupAdminID": "90013234",
//          "SRDesc": "SRDesc",
//          "EqupID": "12173",
//          "EntryShift": "",
//          "EntryID": "90013234",
//          "EntryName": "جواد محمد صالح جمال",
//          "EntryDate": "07/01/2025",
//          "EntryDateToResponse": "20250107",
//          "EntryTime": "14:02:33",
//          "Status": "OP",
//          "SectionAdminName": "جواد محمد صالح جمال",
//          "DepAdminName": "جواد محمد صالح جمال",
//          "GroupAdminName": "جواد محمد صالح جمال",
//          "deviceName": ""
//       },