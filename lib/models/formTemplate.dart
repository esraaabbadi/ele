class FormTemplate {
  final String formID;
  final String itemDataType;
  final String itemText;
  final String formItemDetail;
  final String itemOrder;
  final String ItemRequired;

  final String FormItemValue;

  FormTemplate(
      this.formID,
      this.itemDataType,
      this.itemText,
      this.formItemDetail,
      this.itemOrder,
      this.ItemRequired,
      this.FormItemValue);

  factory FormTemplate.fromJson(Map<String, dynamic> json) {
    return FormTemplate(
      json['FFFormID']?.toString() ?? "",
      json['ItemDataType']?.toString() ?? "",
      json['ItemText']?.toString() ?? "",
      json['FormItemDetail']?.toString() ?? "",
      json['ItemOrder']?.toString() ?? "",
      json['ItemRequired']?.toString() ?? "",
      json['FormItemValue']?.toString() ?? "",
    );
  }
}


// {
//    "SysErrorFlag": false,
//    "SysErrorMsg": "",
//    "CallStatusFlag": true,
//    "CallStatusMsg": "",
//    "DatetimeStamp": "2025-01-15 10:47:15",
//    "Data":    [
//             {
//          "FFFormID": "003",
//          "z_Y55FFIDT_22": "H",
//          "z_Y55FFIDC_21": "التفتيش والفحص والصيانة الدورية للمدفع",
//          "z_Y55FFORD_26": "1",
//          "z_Y55FFFITD_28": "",
//          "FormItemDetail": "",
//          "ItemDataType": "H",
//          "ItemText": "التفتيش والفحص والصيانة الدورية للمدفع",
//          "ItemOrder": "1"
//       },
// {
      //    "FFFormID": "117",
      //    "z_Y55FFDTV_23": " ",
      //    "z_Y55FFIDC_22": "NEPCO Incomer No.  Y105",
      //    "z_Y55FFFITD_44": null,
      //    "z_Y55FFIDT_42": "",
      //    "z_Y55FFORD_33": "1",
      //    "FormItemDetail": "",
      //    "ItemDataType": "",
      //    "ItemText": "NEPCO Incomer No.  Y105",
      //    "ItemOrder": "1",
      //    "FormItemValue": ""
      // },