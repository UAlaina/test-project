import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> summarizeText(String text) async {
  final apiKey = 'AIzaSyCnjoBASmCxWPrhur-G7kcrbONy3pyqhKY';

  // Using text-bison model which is available in v1beta
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/text-bison:generateText?key=$apiKey',
  );

  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'prompt': {
      'text': 'Please summarize the following text briefly:\n$text',
    },
    'temperature': 0.7,
    'maxOutputTokens': 150,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final summary = data['candidates'][0]['output'];
      return summary.trim();
    } else {
      throw Exception('Failed to summarize text: ${response.body}');
    }
  } catch (error) {
    throw Exception('Error while summarizing text: $error');
  }
}