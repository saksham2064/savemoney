import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'AIzaSyCPLKaT4wtvzKKcXkf37vaP4Ur8HIWJzfw'; // replace with your actual key

  Future<String> generateContent(String prompt) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": prompt,
            }
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final message = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      return message;
    } else {
      throw Exception('Failed to generate content: ${response.body}');
    }
  }
}
