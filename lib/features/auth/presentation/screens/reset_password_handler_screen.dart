// reset_password_handler_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/core/services/auth_service.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/update_password_screen.dart';

class ResetPasswordHandlerScreen extends StatefulWidget {
  const ResetPasswordHandlerScreen({super.key});

  @override
  State<ResetPasswordHandlerScreen> createState() => _ResetPasswordHandlerScreenState();
}

class _ResetPasswordHandlerScreenState extends State<ResetPasswordHandlerScreen> {
  bool _isLoading = true;
  bool _isValidLink = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _handleResetPasswordLink();
  }

  Future<void> _handleResetPasswordLink() async {
    try {
      // Get the initial session from the deep link
      final session = Supabase.instance.client.auth.currentSession;
      
      if (session != null) {
        // The link is valid, navigate to update password screen
        setState(() {
          _isValidLink = true;
          _isLoading = false;
        });
        
        // Navigate to update password screen after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UpdatePasswordScreen(),
              ),
            );
          }
        });
      } else {
        setState(() {
          _isValidLink = false;
          _isLoading = false;
          _errorMessage = 'Invalid or expired reset link';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error processing reset link: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 245, 247),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true, // ensures scroll when keyboard opens
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : _isValidLink
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(
                              'Processing reset link...',
                              style: TextStyle(
                                color: Color.fromARGB(255, 71, 134, 145),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 64,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _errorMessage ?? 'Invalid reset link',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
