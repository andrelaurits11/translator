class Translation {
  final String translatedText;

  Translation({required this.translatedText});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      translatedText: json['translatedText'] ?? 'Tõlge puudub',
    );
  }
}
