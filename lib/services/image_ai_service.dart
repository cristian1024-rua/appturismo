import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageAIService {
  final _apiKey = dotenv.env['GEMINI_API_KEY']!;

  Future<List<String>> analyzeImage(String imageUrl) async {
    final uri = Uri.parse(
      'https://vision.googleapis.com/v1/images:annotate?key=$_apiKey'
    );
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'requests': [
          {
            'image': {'source': {'imageUri': imageUrl}},
            'features': [
              {'type': 'LABEL_DETECTION', 'maxResults': 5}
            ]
          }
        ]
      }),
    );
    if (response.statusCode != 200) {
      throw 'Error IA: ${response.body}';
    }
    final data = jsonDecode(response.body);
    return (data['responses'][0]['labelAnnotations'] as List)
        .map((l) => l['description'] as String)
        .toList();
  }
}
