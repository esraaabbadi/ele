class EquDetailsData {
  EquDetailsData(
    this.z_DL01_51, // اسم النموذج
    this.z_Y55FFNFN_39, //رقم الفحص
    this.z_DL01_34, //الفاحص
    this.z_Y55VMED_24, //تاريخ الفحص
  );
  final String z_DL01_51;
  final String z_Y55FFNFN_39;
  final String z_DL01_34;
  final String z_Y55VMED_24;

  factory EquDetailsData.fromJson(Map<String, dynamic> json) {
    return EquDetailsData(
      json['z_DL01_51'],
      json['z_Y55FFNFN_39']?.toString() ?? '',
      json['z_DL01_34'],
      json['z_Y55VMED_24'],
    );
  }
}
//  "z_Y55VMET_25": 110714,
//          "z_DL01_61": "Electricity Group",
// اسم النوذج
//          "z_DL01_51": "ME238_07",
//          "z_Y55FFITN_49": "9774",
//          "z_Y55FFESF_42": " ",
//الفاحص
//          "z_DL01_34": "محمد تيسير خالد عبد السلام",
//          "z_Y55VMED_24": "20241016",
//          "z_Y55FFORD_50": 1,
//          "z_Y55FFFNO_38": "130",
//          "z_Y55FFDTV_22": " ",
// رقم الفحص
//          "z_Y55FFNFN_39": 12429001309774,
//          "z_AN81_23": 90014626,
//          "z_Y55FFGRP_60": "E",
//          "z_Y55FFIDC_21": "304-CM-1A"
