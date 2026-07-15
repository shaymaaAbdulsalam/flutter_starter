import 'package:flutter/material.dart';

/// Shown while [AuthStatus] is `unknown` — i.e. during the brief window at
/// startup when we are reading the cached session. Prevents the login screen
/// from flashing before we know whether the user is already authenticated.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
