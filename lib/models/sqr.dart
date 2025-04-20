// class RegisterResponseModel {
//   final String? status;
//   final String? message;
//   final Map<String, dynamic>? data;

//   RegisterResponseModel({this.status, this.message, this.data});

//   // Factory method لتحويل JSON إلى كائن من نوع RegisterResponseModel
//   factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
//     return RegisterResponseModel(
//       status: json['Status'],
//       message: json['Message'],
//       data:
//           json['Data'] != null ? Map<String, dynamic>.from(json['Data']) : null,
//     );
//   }
// }
//  'Status': 'OP',
//       'deviceName': 'FF90013234',
//       'SRDesc': 'SRDesc',
//       'AttID': 'AttID',
//       'SectionAdminID': '90013234',
//       'DepAdminID': '90013234',
//       'GroupAdminID': '90013234',
//       'EqupID': '46825',
//       'EntryShift': 'A',
//       'EntryID': '90013234',
//       'ServiceID': 'ELE',
//       'EntryName': 'جواد جمال',
class RegisterResponseModel {
  RegisterResponseModel(
    this.Success,
  );
  final String Success;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      json['Success'],
    );
  }
}
