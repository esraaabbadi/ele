class EquipmentCheckesData {
  EquipmentCheckesData(
    this.EqpDesc,
    this.EqpID,
    this.ScheduledCheckDate, //الفاحص
    this.RealtedFormID,
  );
  final String EqpDesc;
  final String EqpID;
  final String ScheduledCheckDate;
  final String RealtedFormID;

  factory EquipmentCheckesData.fromJson(Map<String, dynamic> json) {
    return EquipmentCheckesData(
      json['EqpDesc'] ?? '',
      json['EqpID'] ?? '',
      json['ScheduledCheckDate'] ?? '',
      json['RealtedFormID'] ?? '',
    );
  }
}

//  "ScheduleTypeDesc": "نفس اليوم كل أسبوع", 
//       "CheckerID": "71600002", 
//  num elma3dh
//       "EqpID": "10139",
// اسم المعدة 
//       "EqpDesc": "301-PM-12B", 
//       "PlannedCheckDate": "",
// تاريخ الفحص
//       "ScheduledCheckDate": "2025-01-13",
//       "CompletedCheckDate": "",
//       "Status": "01",
// اسم النموذج
//       "RealtedFormID": "301PM12B"