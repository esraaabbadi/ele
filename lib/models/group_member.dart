class GroupMemberData {
  GroupMemberData(
    this.EmpID,
    this.EmpName,
    this.Active,
    this.RelatedGroupName,
  );
  final String EmpID;
  final String EmpName;
  final String Active;
  final String RelatedGroupName;

  factory GroupMemberData.fromJson(Map<String, dynamic> json) {
    return GroupMemberData(
      json['EmpID'],
      json['EmpName'],
      json['Active'],
      json['RelatedGroupName'],
    );
  }
}
