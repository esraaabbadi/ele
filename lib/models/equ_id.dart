class EquipmentID {
  final String id;
  final String CheckerName;
  final String EqpDesc;
  final String LastCheckDate;

  EquipmentID(this.id, this.CheckerName, this.EqpDesc, this.LastCheckDate);

  factory EquipmentID.fromJson(Map<String, dynamic> json) {
    return EquipmentID(
      json['EqpID'],
      json['CheckerName'],
      json['EqpDesc'],
      json['LastCheckDate'],
    );
  }
}
  // {
  //        "CheckerID": "90015271",
  //        "SchDate": "31/12/2024"
  //     },