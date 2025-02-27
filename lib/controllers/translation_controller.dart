import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class TranslationController {
final TranslationService _service = TranslationService();
final TextEditingController textController = TextEditingController();

String sourceLang = 'et';
String targetLang = 'en';
String translatedText = '';

  final Map<String, String> languages = {
    'et': 'Eesti',
    'en': 'Inglise',
    'de': 'Saksa',
    'ja': 'Jaapan',
    'es': 'Hispaania',
    'fr': 'Prantsuse',
    'lv': 'Läti',
    'lt': 'Leedu',
  };



  void init() {
    textController.addListener(() {
      if (textController.text.isEmpty && translatedText.isNotEmpty) {
       translatedText = '';
      }
    });
  }

  Future<void> translate() async {
    if (textController.text.trim().isEmpty) return;
    final result = await _service.translateText(textController.text, sourceLang, targetLang);
    translatedText = result.translatedText;
  }

  DropdownButtonFormField<String> buildLanguageDropdown(String label) {
    return DropdownButtonFormField<String>(
      value: label == 'Lähtekeel' ? sourceLang : targetLang,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: languages.entries
          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          if (label == 'Lähtekeel') sourceLang = value;
          if (label == 'Sihtkeel') targetLang = value;
        }
      },
    );
  }

  Widget buildTextField() {
    return TextField(
      controller: textController,
      decoration: const InputDecoration(
        labelText: 'Sisesta tekst',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: null,
      autofocus: true,
      enableSuggestions: true,
      autocorrect: true,
    );
  }

  Widget buildTranslationDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        translatedText.isEmpty ? 'Tõlge ilmub siia' : 'Tõlge: $translatedText',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}


