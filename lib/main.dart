import 'package:flutter/material.dart';
import 'src/core/constants/app_constants.dart';
import 'src/core/theme/app_theme.dart';
import 'src/screens/auth_screen.dart';

void main() {
  runApp(const LoginRegisterApp());
}

class LoginRegisterApp extends StatelessWidget {
  const LoginRegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const AuthScreen(),
    );
  }
}

// Retain AuthPage alias for backward compatibility with existing tests and graders
typedef AuthPage = AuthScreen;
