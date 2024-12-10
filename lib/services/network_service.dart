import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class NetworkService {
  static const int timeoutDuration = 10; // Timeout in seconds

  Future<dynamic> getRequest(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No Internet connection.');
    } on HttpException {
      throw Exception('Couldn’t find the requested resource.');
    } on FormatException {
      throw Exception('Bad response format.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again later.');
    }
  }

  Future<dynamic> postRequest(String url, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No Internet connection.');
    } on HttpException {
      throw Exception('Couldn’t find the requested resource.');
    } on FormatException {
      throw Exception('Bad response format.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again later.');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Error: ${response.statusCode}, Message: ${response.reasonPhrase}');
    }
  }
}
