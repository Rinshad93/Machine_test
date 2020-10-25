import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:machine_test/models/menuList.dart';
class MenuProvider {

  final successCode = 200;

  Future<Menu> getMenuDetails() async {
    String baseUrl = "https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad";

    print(baseUrl);
    final client = new http.Client();
    final response = await client.get(
      baseUrl,

    );
    return parseResponse(response);
  }

  Menu parseResponse(http.Response response) {
    final responseString = jsonDecode(response.body);
    print('response'+ response.body);
    print('response'+ response.statusCode.toString());
    if (response.statusCode == successCode || response.statusCode == 400) {
      print('inside_status_code');
      return Menu.fromJson(responseString[0]);
    } else {
      throw Exception('failed to call');
    }
  }

}
