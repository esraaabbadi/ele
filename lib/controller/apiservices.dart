import 'dart:convert';
import 'dart:io';
import 'package:equapp/apis/helper.dart';
import 'package:equapp/models/checked_equ.dart';
import 'package:equapp/models/equ_id.dart';
import 'package:equapp/models/equipment.dart';
import 'package:equapp/models/form.dart';
import 'package:equapp/models/formTemplate.dart';
import 'package:equapp/models/group_member.dart';
import 'package:equapp/models/image.dart';
import 'package:equapp/models/query_equid.dart';
import 'package:equapp/models/save.dart';
import 'package:equapp/models/saveform.dart';
import 'package:equapp/models/show_m_reuest.dart';
import 'package:equapp/models/upload_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../models/form-details.dart';
import '../models/notification.dart';

class ApiService {
  Future checklogin(String userid, String PWD) async {
    String DN = "EE" + '$userid';
    var body = {'EMPID': '$userid', 'PWD': '$PWD', 'deviceName': '$DN'};
    var allData;
    //await executeAppGw(body, "CheckUserLogin");
    print("body: $body");
    await callApi(
            method: ApiMethod.post, endPoint: "CheckUserLogin", body: body)
        .then((onValue) {
      print("checklogin values: $onValue");
      allData = onValue;
      return onValue;
    });
    return allData;
  }

  Future<List<FormData>> getSubmittedFormInDate(
      String UserID, String Date) async {
    List<FormData> allData = [];
    String DN = "EE" + '$UserID';
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    var body = {
      'Date':
          // '16/10/2024',
          currentDate,
      'deviceName': '$DN'
    };

    await callApi(
            method: ApiMethod.post,
            endPoint: "getSubmmittedFormsInDate",
            body: body)
        .then((onValue) {
      print("getSubmittedFormInDate values $onValue");
      // Check if 'data' exists and is not null
      if (onValue != null && onValue['data'] != null) {
        allData = (onValue['data'] as List)
            .map((item) => FormData.fromJson(item))
            .toList();
        print("getSubmittedFormInDate Data: $allData");
      }
    }).catchError((error) {
      print("Error fetching getSubmittedFormInDate data: $error");
    });

    return allData;
  }

  Future<List<FormsDetailsData>> getDetailForms(String UserID) async {
    //change the EQPID
    List<FormsDetailsData> allData = [];
    String DN = "EE" + '$UserID';
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    var body = {
      'EQPID': '9774',
      'formid': '142',
      'EntryEmp': '90016159',
      'DateToQuery':
          // currentDate,
          '16/10/2024',
      'DEVICENAME': '$DN'
    };
    await callApi(
            method: ApiMethod.post, endPoint: "getDetailForms", body: body)
        .then((onValue) {
      print("getDetailForms values: $onValue");
      // Check if 'data' exists and is not null
      if (onValue != null && onValue['data'] != null) {
        allData = (onValue['data'] as List)
            .map((item) => FormsDetailsData.fromJson(item))
            .toList();
        print("getDetailForms Data: $allData"); // Print parsed data to verify
      }
    }).catchError((error) {
      print("Error fetching getDetailForms data: $error");
    });

    return allData;
  }

  Future<List<NotificationData>> getGNFByStatus(
    String UserID,
  ) async {
    List<NotificationData> allData = [];
    String DN = "EE" + '$UserID';

    var body = {'deviceName': '$DN', 'Status': 'OP'};
    await callApi(
            method: ApiMethod.post, endPoint: "getGNFByStatus", body: body)
        .then((onValue) {
      print("getGNFByStatus values $onValue");
      // Check if 'data' exists and is not null
      if (onValue != null && onValue['data'] != null) {
        allData = (onValue['data'] as List)
            .map((item) => NotificationData.fromJson(item))
            .toList();
        print("getGNFByStatus Data: $allData"); // Print parsed data to verify
      }
    }).catchError((error) {
      print("Error fetching getGNFByStatus form data: $error");
    });

    return allData;
  }

  Future<List<ImageBase64>> getAttByName(String FFAttName) async {
    List<ImageBase64> allData = [];
    var body = {
      'FFAttName': FFAttName
    }; // No need for '$' in string interpolation

    try {
      var onValue = await callApi(
          method: ApiMethod.post, endPoint: "getAttByName", body: body);
      print("API Response getAttByName: $onValue");

      if (onValue != null && onValue['data'] != null) {
        if (onValue['data'] is List) {
          allData = (onValue['data'] as List)
              .map((item) => ImageBase64.fromJson(item))
              .toList();
        } else {
          allData.add(ImageBase64.fromJson(onValue['data']));
        }
        print("getAttByName Data: $allData"); // Verify the data
      }
    } catch (error) {
      print("Error fetching getAttByName form data: $error");
    }

    return allData;
  }

  Future<List<UploadImage>> UplBase64String(
      String FFAttName, String base64String) async {
    List<UploadImage> allData = [];
    var body = {
      'FFAttName': FFAttName,
      'FFAttUploadedBy': '90013234', // Assuming this is the uploaded by user ID
      'FFAttBase64': base64String,
    };

    try {
      var response = await callApi(
        method: ApiMethod.post,
        endPoint: "UplBase64String",
        body: body,
      );

      print("API UplBase64String Response: $response");
      if (response != null && response['Data'] != null) {
        var responseData = response['Data'];
        var success = responseData['Success'] ?? 'Unknown';

        print("Success: $success");

        if (success == "Saved") {
          allData.add(UploadImage(Success: success));
          print("Form saved successfully: $success");
        }
      } else {
        print("Unexpected UplBase64String Response Structure: $response");
        Fluttertoast.showToast(msg: "حدث خطأ أثناء رفع الصورة");
      }
    } catch (error) {
      print("Error during UplBase64String API call: $error");
    }

    return allData;
  }

  Future<List<ShowMaintenanceRequestDetails>> getSRQByStatus(
      String UserID) async {
    List<ShowMaintenanceRequestDetails> allData = [];
    String DN = "EE" + '$UserID';

    var body = {'deviceName': '$DN', 'Status': 'OP'};
    await callApi(
            method: ApiMethod.post, endPoint: "getSRQByStatus", body: body)
        .then((onValue) {
      print("getSRQByStatus $onValue");
      // Check if 'data' exists and is not null
      if (onValue != null && onValue['data'] != null) {
        allData = (onValue['data'] as List)
            .map((item) => ShowMaintenanceRequestDetails.fromJson(item))
            .toList();
        print("getSRQByStatus Data: $allData"); // Print parsed data to verify
      }
    }).catchError((error) {
      print("Error fetching getSRQByStatus form data: $error");
    });

    return allData;
  }

  String getCurrentShift() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour > 6 && hour <= 14) {
      return 'A';
    } else if (hour > 14 && hour <= 22) {
      return 'B';
    } else if (hour > 22 && hour < 6) {
      return 'C';
    } else {
      return 'خطأ في استيراد الوقت';
    }
  }

// {'Status':'OP', 'deviceName':'FF90013234','SRDesc':'SRDesc','AttID':'AttID','SectionAdminID':'90013234',
// 'DepAdminID':'90013234','GroupAdminID':'90013234',
//'SRDesc':'SRDesc',
// 'EqupID':'46825', 'EntryShift':'A', 'EntryID':'90013234' ,'ServiceID':'ELE' ,'EntryName':'sdf'}
  Future<List<SaveMaintainRequist>> RegisterSRQ(
      String UserID, String AttID, String SRDesc, dynamic EqupID) async {
    String DN = "FF$UserID"; // Concatenating user ID
    List<SaveMaintainRequist> allData = [];

    var body = {
      'Status': 'OP',
      'deviceName': DN,
      'SRDesc': SRDesc,
      'AttID': AttID,
      'SectionAdminID': UserID,
      'DepAdminID': UserID,
      'GroupAdminID': UserID,
      'EqupID': EqupID is int ? EqupID : int.tryParse(EqupID.toString()),
      'EntryShift': 'A',
      'EntryID': UserID,
      'ServiceID': 'ELE',
      'EntryName': 'sdf',
    };

    try {
      var response = await callApi(
        method: ApiMethod.post,
        endPoint: "RegisterSRQ",
        body: body,
      );

      print(" RegisterSRQ Response: $response");

      // ✅ Fix: Access the correct key (`data`, not `Data`)
      if (response != null && response['data'] != null) {
        var responseData = response['data'];
        var success = responseData['Success'] ?? 'Unknown';

        print("Success: $success");

        if (success == "Saved") {
          allData.add(SaveMaintainRequist(Success: success));
          print("Form saved successfully: $success");
        }
      } else {
        print("Unexpected RegisterSRQ Response : $response");
      }
    } catch (error) {
      print("Error during API call: $error");
    }

    return allData;
  }

  // Future<List<FormTemplate>> GetFormInfo(
  //   String FormId,
  //   String UserID,
  // ) async {
  //  List<FormTemplate> allData = [];
  //   String DN = "EE" + '$UserID';
  //   var body = {
  //     'FormID': '$FormId',
  //     'EQIP': '7875',
  //     'DEVICENAME': '$DN',
  //     'datetody': '03/02/2025'
  //   };
  //   // {'FormID':'ME210_03','EQIP':'7875','DEVICENAME':'$DN','datetody':'03/02/2025'};
  //   //  {'FormID': '$FormId', 'deviceName': 'FF90013234'};
  //   await callApi(
  //     method: ApiMethod.post,
  //     endPoint: "GetFormInfo",
  //     body: body,
  //   ).then((onValue) {
  //     print("API Response: $onValue");
  //   if (onValue != null && onValue['data'] != null) {
  //     final responseData = onValue['data'];
  //     // Check if `responseData` is a list or a map
  //     if (responseData is List) {
  //       allData =
  //           responseData.map((item) => FormTemplate.fromJson(item)).toList();
  //     } else if (responseData is Map<String, dynamic>) {
  //       // If it's a map, convert it to a single EquipmentCheckesData
  //       allData = [FormTemplate.fromJson(responseData)];
  //     }
  //     print("Parsed Data: $allData");
  //   }
  // }).catchError((error) {
  //   print("Error fetching form data: $error");
  // });
  //   return allData;
  // }
  Future uploadImage({
    required String fileName,
    required String uploadedBy,
    required File imageFile,
  }) async {
    String base64Image = base64Encode(await imageFile.readAsBytes());

    var body = {
      'FFAttName': fileName,
      'FFAttUploadedBy': uploadedBy,
      'FFAttBase64': base64Image,
    };

    var response;

    await callApi(
      method: ApiMethod.post,
      endPoint: "UplBase64String",
      body: body,
    ).then((onValue) {
      print("Response from uploadImage: $onValue");
      response = onValue;
    });

    return response;
  }

  Future<List<EquipmentID>> getFireFighEqp(String userID) async {
    List<EquipmentID> allData = [];
    String DN = "EE" + userID;
    var body = {
      'LoginID': '',
      'DEVICENAME': '$DN',
    };

    try {
      var response = await callApi(
        method: ApiMethod.post,
        endPoint: "getFireFighEqp",
        body: body,
      );

      if (response != null && response['data'] != null) {
        allData = (response['data'] as List)
            .map((item) => EquipmentID.fromJson(item))
            .toList();
        print(" getFireFighEqp Data: $allData");
      }
    } catch (error) {
      print("Error fetching equipment IDs: $error");
    }

    return allData;
  }

  Future<List<EquDetailsData>> getEqpHistoryByQRID(
      String equipmentID, String UserID) async {
    List<EquDetailsData> allData = [];
    String DN = "EE" + '$UserID';

    var body = {
      'EQPID': '$equipmentID',
      'deviceName': '$DN',
    };

    try {
      var response = await callApi(
        method: ApiMethod.post,
        endPoint: "getEqpHistoryByQRID",
        body: body,
      );

      if (response != null && response['data'] != null) {
        allData = (response['data'] as List)
            .map((item) => EquDetailsData.fromJson(item))
            .toList();
        print("Parsed equ details Data: $allData");
      }
    } catch (error) {
      print("Error fetching equipment details: $error");
    }

    return allData;
  }

  Future<List<GroupMemberData>> getUsersList(String UserID) async {
    List<GroupMemberData> allData = [];
    String DN = "EE" + '$UserID';

    var body = {'deviceName': '$DN', 'Group': 'E'};
    await callApi(method: ApiMethod.post, endPoint: "getUsersList", body: body)
        .then((onValue) {
      print("getUsersList : $onValue");

      if (onValue != null && onValue['data'] != null) {
        allData = (onValue['data'] as List)
            .map((item) => GroupMemberData.fromJson(item))
            .toList();
        print("getUsersList Data: $allData"); // Print parsed data to verify
      }
    }).catchError((error) {
      print("Error fetching getUsersList data: $error");
    });

    return allData;
  }

//   Future<List<FormTemplate>> getFormTemplate(
//       String formID, String UserID) async {
//     List<FormTemplate> allData = [];
//     String DN = "FF" + '$UserID';
// // {'FormID':'QF-205A', 'deviceName':'FF90013234'}
//     var body = {'FormID': 'QF-205A', 'deviceName': 'FF90013234'};
//     await callApi(
//             method: ApiMethod.post, endPoint: "getFormTemplate ", body: body)
//         .then((onValue) {
//       print("onValuess $onValue");
//       if (onValue != null && onValue['data'] != null) {
//         allData = (onValue['data'] as List)
//             .map((item) => FormTemplate.fromJson(item))
//             .toList();
//         print("Parsed Data: $allData"); // Print parsed data to verify
//       }
//     }).catchError((error) {
//       print("Error fetching form data: $error");
//     });
//     return allData;
//   }

  // Future<List<FormTemplate>> getFormTemplate(String formID, String deviceName) async {
  //   List<FormTemplate> formTemplates = [];
  //   var body = {'FormID': formID, 'deviceName': deviceName};
  //   try {
  //     var response = await ApiService().callApi(
  //       method: ApiMethod.post,
  //       endPoint: "getFormTemplate",
  //       body: body,
  //     );
  //     if (response != null && response['Data'] != null) {
  //       formTemplates = (response['Data'] as List)
  //           .map((item) => FormTemplate.fromJson(item))
  //           .toList();
  //     }
  //   } catch (e) {
  //     print("Error fetching form templates: $e");
  //   }
  //   return formTemplates;
  // }

  Future<List<FormTemplate>> getFormTemplate(
    String FormId,
    String UserID,
  ) async {
    List<FormTemplate> allData = [];
    String DN = "EE" + '$UserID';
// QF-205A
    var body = {'FormID': '$FormId', 'deviceName': '$DN'};
    await callApi(
      method: ApiMethod.post,
      endPoint: "getFormTemplate",
      body: body,
    ).then((onValue) {
      print("getFormTemplate Response: $onValue");

      if (onValue != null && onValue['data'] != null) {
        final responseData = onValue['data'];
        // Check if `responseData` is a list or a map
        if (responseData is List) {
          allData =
              responseData.map((item) => FormTemplate.fromJson(item)).toList();
        } else if (responseData is Map<String, dynamic>) {
          // If it's a map, convert it to a single EquipmentCheckesData
          allData = [FormTemplate.fromJson(responseData)];
        }
        print("getFormTemplate Data: $allData");
      }
    }).catchError((error) {
      print("Error fetching getFormTemplate data: $error");
    });

    return allData;
  }

  Future<List<FormTemplate>> GetFormInfo(
    String FormId,
    String UserID,
  ) async {
    List<FormTemplate> allData = [];
    String DN = "EE" + '$UserID';
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    var body = {
      'FormID': '$FormId',
      'EQIP': '7875',
      'DEVICENAME': '$DN',
      'datetody': currentDate
      // '03/02/2025'
    };
    // {'FormID':'ME210_03','EQIP':'7875','DEVICENAME':'$DN','datetody':'03/02/2025'};
    //  {'FormID': '$FormId', 'deviceName': 'FF90013234'};

    await callApi(
      method: ApiMethod.post,
      endPoint: "GetFormInfo",
      body: body,
    ).then((onValue) {
      print("GetFormInfo Response: $onValue");

      if (onValue != null && onValue['data'] != null) {
        final responseData = onValue['data'];
        // Check if `responseData` is a list or a map
        if (responseData is List) {
          allData =
              responseData.map((item) => FormTemplate.fromJson(item)).toList();
        } else if (responseData is Map<String, dynamic>) {
          // If it's a map, convert it to a single EquipmentCheckesData
          allData = [FormTemplate.fromJson(responseData)];
        }
        print("GetFormInfo Data: $allData");
      }
    }).catchError((error) {
      print("Error fetching GetFormInfo data: $error");
    });

    return allData;
  }

  Future<List<EquipmentCheckesData>>
      getUserRelatedEquipmentsToCheckTodayOrThisweekOrThisMonth(
          String UserID, String Filtter) async {
    List<EquipmentCheckesData> allData = [];
    String DN = "FF" + '$UserID';

    var body = {
      'deviceName': '$DN',
      'LoginID': '71600002',
      'Filter': '$Filtter'
    };

    await callApi(
      method: ApiMethod.post,
      endPoint: "getUserRelatedEquipmentsToCheckTodayOrThisweekOrThisMonth",
      body: body,
    ).then((onValue) {
      print("getUserRelatedEquipmentsToCheck Response: $onValue");

      if (onValue != null && onValue['data'] != null) {
        final responseData = onValue['data'];
        // Check if `responseData` is a list or a map
        if (responseData is List) {
          allData = responseData
              .map((item) => EquipmentCheckesData.fromJson(item))
              .toList();
        } else if (responseData is Map<String, dynamic> &&
            responseData.isNotEmpty) {
          // If it's a map, convert it to a single EquipmentCheckesData
          allData = [EquipmentCheckesData.fromJson(responseData)];
        }
        print("getUserRelatedEquipmentsToCheck Data: $allData");
      }
    }).catchError((error) {
      print("Error fetching getUserRelatedEquipmentsToCheck data: $error");
    });

    return allData;
  }

//saveSubmittedFormInfo
// {'FormValues':[
//{
//'EqupDesc':'',
//'EqupID':'98745',
// 'FormType':'Daily',
// 'EntryShift':'A',
// 'FormID':'003',
// 'ItemText':'ItemText',
// 'ItemValue':'1',
// 'EntryID':'90013234',
// 'EntryDate':'10/10/2024',
// 'EntryTime':'135130',
// 'TabletID':'TAB1',
// 'deviceName':'FF90013234',
// 'ItemOrder':'3',
// 'Group':'B'
// }
// ]}
// String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
// String currentTime = DateFormat('HHmmss').format(DateTime.now());
  Future<List<SaveForm>> saveSubmittedFormInfo(
    String Group,
    String UserID,
    List<Map<String, String>> formValues,
    String FormType,
    String FormID,
  ) async {
    String entryShift = determineShift();
    List<SaveForm> allData = [];
    String DN = "FF" + '$UserID';
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    var body = {
      'FormValues': formValues.map((item) {
        return {
          'EqupDesc': '',
          'EqupID': '',
          'FormType': FormType,
          'EntryShift': '$entryShift',
          'FormID': "$FormID",
          'ItemText': item['ItemText'] ?? '',
          'ItemValue': item['ItemValue'] ?? '',
          'EntryID': '$UserID',
          'EntryDate':
              // "10/10/2024",
              currentDate,
          'EntryTime': "135130",
          'TabletID': 'TAB1',
          'deviceName': '$DN',
          'ItemOrder':
              item['ItemOrder'] ?? '0', // Default to '0' if not provided
          'Group': '$Group',
        };
      }).toList()
    };

    print("Request Body: $body"); // Debugging print

    try {
      var response = await callApi(
        method: ApiMethod.post,
        endPoint: "saveSubmittedFormInfo",
        body: body,
      );

      print("saveSubmittedFormInfo Response: $response");

      // Check if `response` contains the expected key
      if (response != null && response is Map && response['data'] != null) {
        var responseData = response['data']; // Assuming lowercase `data`
        var success = responseData['Success'] ?? 'Unknown';
        var subFormID = responseData['SubFormID'] ?? 'N/A';

        print("Success: $success");
        print("SubFormID: $subFormID");

        // Extract and parse the Forms list
        if (success == "Saved") {
          // Create a SaveForm object manually from available data
          allData.add(SaveForm(
            success: success,
            subFormID: subFormID, Success: '',
            // Add other fields as needed
          ));
          print("Form saved successfully with SubFormID: $subFormID");
        }
      } else {
        print("Unexpected saveSubmittedFormInfo Response Structure: $response");
      }
    } catch (error) {
      print("Error during API call: $error");
    }

    return allData;
  }

// UpdateFormInfo
  Future<List<SaveForm>> UpdateFormInfo(
    String UserID,
    List<Map<String, String>> formValues,
    String FormType,
    String FormID,
  ) async {
    String entryShift = determineShift();
    List<SaveForm> allData = [];
    String DN = "FF" + '$UserID';
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

// {'FormValues':[{'EqupID':'12242', 'FormType':'Daily', 'EntryShift':'A', 'FormID':'003', 'ItemText':'ItemText','ItemValue':'ItemValue',
// 'EntryID':'90013234','EntryDate':'19/11/2023','EntryTime':'135130','TabletID':''},
// "DATE","EE90016134"]}
// {'FormValues':[{'EqupID':'12242', 'FormType':'Daily',
//  'EntryShift':'A','FormID':'003','ItemText':'ItemText',
//  'ItemValue':'ItemValue','EntryID':'90013234','EntryDate':'19/11/2023',
//  'EntryTime':'135130','TabletID':'','deviceName': 'EE90016134','Date': ''}]};
    var body = {
      'FormValues': formValues.map((item) {
        return {
          // 'EqupID': '98745',
          // 'FormType': "Daily",
          // 'EntryShift': '$entryShift',
          // 'FormID': "$FormID",
          // 'ItemText': item['ItemText'] ?? '',
          // 'ItemValue': item['ItemValue'] ?? '',
          // 'EntryID': '$UserID',
          // 'EntryDate': "10/10/2024",
          // 'EntryTime': "135130",
          // 'TabletID': 'TAB1',
          'EqupID': '12242', 'FormType': 'Daily',
          'EntryShift': '$entryShift', 'FormID': "$FormID",
          'ItemText': item['ItemText'] ?? '',
          'ItemValue': item['ItemValue'] ?? '', 'EntryID': '$UserID',
          'EntryDate': currentDate,
          // '19/11/2023',
          'EntryTime': '135130', 'TabletID': '', 'deviceName': '$DN',
          'Date': '',
        };
      }).toList()
    };

    print("Request Body: $body"); // Debugging print

    try {
      var response = await callApi(
        method: ApiMethod.post,
        endPoint: "UpdateFormInfo",
        body: body,
      );

      print("UpdateFormInfo Response: $response");

      // Check if `response` contains the expected key
      if (response != null && response is Map && response['data'] != null) {
        var responseData = response['data']; // Assuming lowercase `data`
        var success = responseData['Success'] ?? 'Unknown';
        var subFormID = responseData['SubFormID'] ?? 'N/A';

        print("Success: $success");
        print("SubFormID: $subFormID");

        // Extract and parse the Forms list
        if (success == "Saved") {
          // Create a SaveForm object manually from available data
          allData.add(SaveForm(
            success: success,
            subFormID: subFormID, Success: '',
            // Add other fields as needed
          ));
          print("Form saved successfully with SubFormID: $subFormID");
        }
      } else {
        print("Unexpected Response Structure: $response");
      }
    } catch (error) {
      print("Error during API call: $error");
    }

    return allData;
  }

  String determineShift() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour >= 1 && hour < 7) {
      return 'A'; // Shift A: 1 AM - 7 AM
    } else if (hour >= 7 && hour < 16) {
      return 'B'; // Shift B: 7 AM - 4 PM
    } else if (hour >= 16 && hour <= 23) {
      return 'C'; // Shift C: 4 PM - 11 PM
    } else {
      return 'C'; // Default to C if no other conditions match
    }
  }

  Future<List<EquipmentCheckedData>> getRelatedEqpCompleted(
      String UserID) async {
    List<EquipmentCheckedData> allData = [];
    String DN = "EE" + '$UserID';

    var body = {'LoginID': '71600002', 'DEVICENAME': '$DN'};

    await callApi(
      method: ApiMethod.post,
      endPoint: "getRelatedEqpCompleted",
      body: body,
    ).then((onValue) {
      print("getRelatedEqpCompleted Response: $onValue");

      if (onValue != null && onValue['data'] != null) {
        final responseData = onValue['data'];
        // Check if `responseData` is a list or a map
        if (responseData is List) {
          allData = responseData
              .map((item) => EquipmentCheckedData.fromJson(item))
              .toList();
        } else if (responseData is Map<String, dynamic> &&
            responseData.isNotEmpty) {
          // If it's a map, convert it to a single EquipmentCheckesData
          allData = [EquipmentCheckedData.fromJson(responseData)];
        }
        print("getRelatedEqpCompleted Data: $allData");
      }
    }).catchError((error) {
      print("Error fetching getRelatedEqpCompleted data: $error");
    });

    return allData;
  }
}
