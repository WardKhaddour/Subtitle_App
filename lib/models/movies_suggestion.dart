import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchData() async {
  final String url =
      'https://parseapi.back4app.com/classes/Moviesdatabase_Movie?count=1&limit=10&order=title&excludeKeys=screentime';

  final response = await http.get(Uri.parse(url), headers: {
    "X-Parse-Application-Id":
        "dAAXb2tsvu1H4KeA1SWnf4Du2l7EtfWn4FdZO9tt", // This is your app's application id
    "X-Parse-REST-API-Key":
        "JCbIxxAjZNyeOdHDy5IpqtuCAPkdaHKceEvvPxnZ" // This is your app's REST API key
  });
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch data');
  }
}
