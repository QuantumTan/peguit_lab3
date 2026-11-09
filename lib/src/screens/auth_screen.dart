import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/user_account.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_requirement_indicator.dart';
import '../widgets/segmented_auth_toggle.dart';
import '../widgets/student_footer.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoggedIn = false;

  UserAccount? _registeredUser;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  void _showMessage(
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : (isSuccess
                      ? Icons.check_circle_outline_rounded
                      : Icons.info_outline_rounded),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? const Color(0xFFE11D48)
            : (isSuccess ? const Color(0xFF0D9488) : const Color(0xFF1E293B)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _switchForm() {
    _formKey.currentState?.reset();
    _clearFields();
    setState(() {
      _isLogin = !_isLogin;
      _hidePassword = true;
      _hideConfirmPassword = true;
    });
  }

  void _setFormMode(bool isLoginMode) {
    if (_isLogin == isLoginMode) return;
    _switchForm();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (_isLogin) {
      if (_registeredUser == null) {
        _showMessage(
          'Please register an account first.',
          isError: true,
        );
        return;
      }

      if (email != _registeredUser!.email ||
          password != _registeredUser!.password) {
        _showMessage(
          'Incorrect email or password.',
          isError: true,
        );
        return;
      }

      _clearFields();
      setState(() {
        _isLoggedIn = true;
      });
      _showMessage(
        'Welcome back, ${_registeredUser!.name}!',
        isSuccess: true,
      );
    } else {
      if (_registeredUser != null) {
        _showMessage(
          'An account already exists. Please log in.',
          isError: true,
        );
        return;
      }

      _registeredUser = UserAccount(
        name: _nameController.text.trim(),
        email: email,
        password: password,
      );

      _formKey.currentState!.reset();
      _clearFields();
      setState(() {
        _isLogin = true;
        _hidePassword = true;
        _hideConfirmPassword = true;
      });

      _showMessage(
        'Registration successful! Please log in.',
        isSuccess: true,
      );
    }
  }

  void _logout() {
    _clearFields();
    setState(() {
      _isLoggedIn = false;
      _isLogin = true;
      _hidePassword = true;
      _hideConfirmPassword = true;
    });
    _showMessage('Logged out successfully.');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn && _registeredUser != null) {
      return HomeScreen(
        user: _registeredUser!,
        onLogout: _logout,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Application Name Above The Form
                  const AuthHeader(),
                  const SizedBox(height: 24),

                  // Main Form Card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x080F172A),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Segmented Mode Switcher
                          SegmentedAuthToggle(
                            isLogin: _isLogin,
                            onModeChanged: _setFormMode,
                          ),
                          const SizedBox(height: 24),

                          // Heading
                          Text(
                            _isLogin ? 'Welcome Back!' : 'Create an Account',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isLogin
                                ? 'Sign in to access your dashboard'
                                : 'Fill in the information below to register',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Registration Full Name
                          if (!_isLogin) ...[
                            TextFormField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your full name.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) {
                                return 'Please enter your email.';
                              }
                              final emailPattern =
                                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                              if (!emailPattern.hasMatch(email)) {
                                return 'Please enter a valid email.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: _isLogin
                                ? TextInputAction.done
                                : TextInputAction.next,
                            onFieldSubmitted: (_) {
                              if (_isLogin) {
                                _submitForm();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                tooltip: _hidePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password.';
                              }
                              if (value.length < AppConstants.minPasswordLength) {
                                return 'Use at least ${AppConstants.minPasswordLength} characters.';
                              }
                              return null;
                            },
                          ),

                          // Realtime Password Length Helper (Register Mode)
                          if (!_isLogin &&
                              _passwordController.text.isNotEmpty) ...[
                            PasswordRequirementIndicator(
                              passwordLength: _passwordController.text.length,
                            ),
                          ],
                          const SizedBox(height: 16),

                          // Confirm Password (Register Mode)
                          if (!_isLogin) ...[
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _hideConfirmPassword,
                              autocorrect: false,
                              enableSuggestions: false,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submitForm(),
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon:
                                    const Icon(Icons.lock_reset_rounded),
                                suffixIcon: IconButton(
                                  tooltip: _hideConfirmPassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  icon: Icon(
                                    _hideConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _hideConfirmPassword =
                                          !_hideConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password.';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Submit Button
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text(
                              _isLogin ? 'Login' : 'Register',
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Switch Form Button
                          TextButton(
                            onPressed: _switchForm,
                            child: Text(
                              _isLogin
                                  ? 'No account yet? Register'
                                  : 'Already have an account? Login',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Student Name and Section Below The Form
                  const Center(child: StudentFooter()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

