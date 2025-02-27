import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/translation_controller.dart';
import 'home_view.dart';
class TranslateView extends StatefulWidget {
  const TranslateView({super.key});

  @override
  State<TranslateView> createState() => _TranslateViewState();
}

class _TranslateViewState extends State<TranslateView> {
  final TranslationController _controller = TranslationController();

  @override
  void initState() {
    super.initState();
    _controller.init();
  }

  String _getFlagUrl(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return 'https://flagcdn.com/w40/gb.png';
      case 'ja':
        return 'https://flagcdn.com/w40/jp.png';
      case 'et':
        return 'https://flagcdn.com/w40/ee.png';
      default:
        return 'https://flagcdn.com/w40/${code.toLowerCase()}.png';
    }
  }

  Widget _buildLanguageDropdown(String label, bool isSource) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00FFFF), width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: isSource ? _controller.sourceLang : _controller.targetLang,
          items: _controller.languages.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  Image.network(_getFlagUrl(entry.key), width: 24, height: 24),
                  const SizedBox(width: 8),
                  Text(entry.value, style: const TextStyle(color: Colors.white)),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                isSource ? _controller.sourceLang = value : _controller.targetLang = value;
              });
            }
          },
          dropdownColor: const Color(0xFF1F1F1F),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('Tõlkimine', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildLanguageDropdown('Lähtekeel', true)),
                const SizedBox(width: 12),
                Expanded(child: _buildLanguageDropdown('Sihtkeel', false)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00FFFF), width: 2),
              ),
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller.textController,
                decoration: const InputDecoration(
                  labelText: 'Sisesta tekst',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A4A4A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                await _controller.translate();
                setState(() {});
              },
              child: const Text('Tõlgi', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00FFFF), width: 2),
              ),
              child: Text(
                _controller.translatedText.isEmpty
                    ? 'Tõlge ilmub siia'
                    : _controller.translatedText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signOut,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: 'Logi välja',
        child: const Icon(Icons.logout),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
