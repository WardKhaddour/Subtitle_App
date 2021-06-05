import 'dart:convert';
import 'package:http/http.dart' as http;

class OmdbApi {
  Future<String> getId(String name) async {
    const apiKey = '1c9d8247';
    final url = 'http://www.omdbapi.com/?t=$name&apikey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return extractedData['imdbID'].toString();
    } catch (e) {
      return '';
    }
  }
}
