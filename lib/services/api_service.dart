import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://bamisapp.bdservers.site/api/exam';

  Future<dynamic> fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      print("data: "+ response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
