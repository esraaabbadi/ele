import 'package:equapp/apis/helper.dart';
import 'package:equapp/models/form.dart';

Future<List<FormData>> getSubmittedFormInDate(
    String UserID, String Date) async {
  List<FormData> allData = [];
  String DN = "EE" + '$UserID';
  var body = {'Date': '16/10/2024', 'deviceName': '$DN'};

  await callApi(
          method: ApiMethod.post,
          endPoint: "getSubmmittedFormsInDate",
          body: body)
      .then((onValue) {
    print("onValuess $onValue");
    // Check if 'data' exists and is not null
    if (onValue != null && onValue['data'] != null) {
      allData = (onValue['data'] as List)
          .map((item) => FormData.fromJson(item))
          .toList();
      print("Parsed Data: $allData");
    }
  }).catchError((error) {
    print("Error fetching form data: $error");
  });

  return allData;
}
