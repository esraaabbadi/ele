import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:equapp/services/check-internet.dart';
import 'package:equapp/shared/settings.dart' as settings;
import 'package:equapp/services/apiUtils.dart' as service;

enum ApiMethod {
  get,
  post,
}

enum WithBaseURL {
  yes,
  no,
}

enum ShowConnectionPage {
  yes,
  no,
}

String url = "https://93.115.15.19:8441/EEGW/api/Values/";
// String url = "http://172.16.100.167:8442/EEGW/api/Values/";

Future callApi(
    {endPoint,
    body,
    required method,
    withBaseURL = WithBaseURL.yes,
    showConnectionPage = ShowConnectionPage.yes}) async {
  var responseJson;
  var response;
  var bodyApi = body;
  service.setHeader(bodyApi.toString());

  await checkInternet(showConnectionPage).then((value) async {
    if (true) {
      try {
        response = method == ApiMethod.get
            ? await http.get(
                Uri.parse(withBaseURL == WithBaseURL.yes
                    ? '${settings.baseURL}$endPoint' //jopotrol.com/apis/login ==> baseurl (jopotrol.com/apis/), ==> endpoint (login)
                    : '$endPoint'), //efwateerkom.com/login
                headers: settings.headers,
              )
            : await http.post(
                Uri.parse(withBaseURL == WithBaseURL.yes
                    ? '${settings.baseURL}$endPoint'
                    : '$endPoint'),
                body: jsonEncode(bodyApi), //{'key':'value'}
                headers: settings.headers,
              );
        print("body response ${response.body}");
        responseJson = json.decode(response.body);
      } catch (e) {
        print("Url is :" + endPoint.toString());
        print("exception handld is :" + e.toString());
      }
    }
  });

  Map data = {'data': responseJson["Data"], 'res': response};
  return data;
}
