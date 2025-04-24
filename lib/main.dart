// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:async';

const String VALID_USER_EMAIL = 'name@gmail.net';
const String VALID_USER_PASS = '12345678';

void main() {
  runApp(const LoginDemoApp());
}

class LoginDemoApp extends StatelessWidget {
  const LoginDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sign In',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true, // Using Material 3 styling
          inputDecorationTheme: const InputDecorationTheme(
            // Consistent border style
            border: OutlineInputBorder(),
            filled: true, // Slightly different look
            fillColor: Colors.white70,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            // Consistent button style
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 24.0),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Different radius
                )),
          )),
      home: const SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _loginFormStateKey = GlobalKey<FormState>();
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _processingLogin = false;

  @override
  void dispose() {
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  Future<void> _handleLoginAttempt() async {
    FocusScope.of(context).requestFocus(FocusNode());

    final bool isFormValid =
        _loginFormStateKey.currentState?.validate() ?? false;

    if (isFormValid) {
      setState(() {
        _processingLogin = true;
      });

      final String emailAttempt = _emailInputController.text.trim();
      final String passwordAttempt = _passwordInputController.text.trim();

      await Future.delayed(const Duration(milliseconds: 1200));

      bool loginSuccess = false;
      if (emailAttempt == VALID_USER_EMAIL &&
          passwordAttempt == VALID_USER_PASS) {
        loginSuccess = true;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loginSuccess
                  ? 'Authentication Successful. Welcome!'
                  : 'Login Failed. Check credentials.',
            ),
            backgroundColor: loginSuccess ? Colors.teal : Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: const Duration(seconds: 3),
          ),
        );

        setState(() {
          _processingLogin = false;
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please correct the highlighted fields.'),
            backgroundColor: Colors.amber[700],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Sign In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        color: Colors.grey[100],
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _loginFormStateKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Access Your Account',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                TextFormField(
                  controller: _emailInputController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.alternate_email),
                    hintText: 'you@example.com',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email cannot be empty';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Enter a valid email format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordInputController,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.password),
                    hintText: 'Your secure password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      tooltip: 'Toggle password visibility',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: _processingLogin ? null : _handleLoginAttempt,
                  icon: _processingLogin
                      ? Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(_processingLogin ? 'Verifying...' : 'Sign In'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextButton(
                    onPressed: _processingLogin
                        ? null
                        : () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Forgot Password action triggered (not implemented)'),
                              duration: Duration(seconds: 2),
                            ));
                          },
                    child: Text(
                      'Trouble logging in?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
