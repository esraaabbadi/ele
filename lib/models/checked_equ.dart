class EquipmentCheckedData {
  EquipmentCheckedData(
    this.EqpDesc,
    this.EqpID,
    this.ScheduledCheckDate, //الفاحص
    this.RealtedFormID,
  );
  final String EqpDesc;
  final String EqpID;
  final String ScheduledCheckDate;
  final String RealtedFormID;

  factory EquipmentCheckedData.fromJson(Map<String, dynamic> json) {
    return EquipmentCheckedData(
      json['EqpDesc'] ?? '',
      json['EqpID'] ?? '',
      json['ScheduledCheckDate'] ?? '',
      json['RealtedFormID'] ?? '',
    );
  }
}
