import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';
import 'translate_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthController().userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return const TranslateView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}