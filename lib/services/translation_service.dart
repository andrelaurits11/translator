import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/translation.dart';

class TranslationService {
  final String apiKey = 'AIzaSyCcL_bGjaRTptVqYQsVIe6ryBFdHzC8Dow';

  Future<Translation> translateText(String text, String sourceLang, String targetLang) async {
    final url = Uri.parse('https://translation.googleapis.com/language/translate/v2?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'source': sourceLang,
        'target': targetLang,
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Translation.fromJson(data['data']['translations'][0]);
    } else {
      throw Exception('Tõlkimine ebaõnnestus: ${response.statusCode}');
    }
  }
}
