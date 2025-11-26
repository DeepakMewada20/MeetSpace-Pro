import 'dart:convert';

import 'package:http/http.dart' as http;

class AppConfigaretion {
  final String appSing;
  final int appID;
  AppConfigaretion({required this.appID, required this.appSing});
}

Future<AppConfigaretion> fetchAppconfig() async {
  final url = Uri.parse('https://testfunction-3vnkonrqfa-uc.a.run.app');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return AppConfigaretion(appID: data['appId'], appSing: data['appSign']);
  } else {
    throw Exception('Failed to load app sign');
  }
}
