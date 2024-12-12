import 'package:http/http.dart' as http;

import '../config/api_constants.dart';

class ApiService {

  Future<dynamic> fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/$endpoint'));
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
