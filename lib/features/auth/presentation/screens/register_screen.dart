import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:serenote/core/services/auth_service.dart';
import 'login_screen.dart';
import 'package:serenote/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  
  AnimationController? _shimmerController;
  AnimationController? _pulseController;
  
  // Validation flags
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;
  bool _fullNameTouched = false;

  bool get _isEmailValid {
  final email = _emailController.text.trim();
  if (email.isEmpty) return false;
  
  // More comprehensive email regex
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'
  );
  
  return emailRegex.hasMatch(email);
}

  bool get _isPasswordValid {
    return _passwordController.text.length >= 6;
  }

  bool get _isConfirmPasswordValid {
    return _confirmPasswordController.text.isNotEmpty &&
           _passwordController.text == _confirmPasswordController.text;
  }

  bool get _isFullNameValid {
    return _fullNameController.text.trim().isNotEmpty;
  }

  bool get _isFormValid {
    return _isEmailValid && 
           _isPasswordValid && 
           _isConfirmPasswordValid && 
           _isFullNameValid &&
           _agreedToTerms;
  }

  @override
  void initState() {
    super.initState();
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    // Add listeners to update state when text changes
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
    _fullNameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _shimmerController?.dispose();
    _pulseController?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _showTermsAndConditions() {
    showDialog(
      
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.description,
                    color: Color.fromARGB(255, 71, 134, 145),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 71, 134, 145),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermsSection(
                        'Welcome to SereNote',
                        'SereNote is your mindful companion for emotional awareness, mood tracking, and personal growth. By using our app, you agree to the following terms.',
                      ),
                      _buildTermsSection(
                        '1. Use of Service',
                        'SereNote provides tools for mood tracking, journaling, habit tracking, and mindfulness exercises. This service is for personal, non-commercial use only.',
                      ),
                      _buildTermsSection(
                        '2. Privacy & Data',
                        'We respect your privacy. Your journal entries, mood data, and personal information are securely stored and never shared with third parties without your explicit consent. You maintain full ownership of your data.',
                      ),
                      _buildTermsSection(
                        '3. User Content',
                        'You retain all rights to content you create in SereNote, including journal entries, notes, and habit logs. We do not claim ownership of your personal reflections.',
                      ),
                      _buildTermsSection(
                        '4. Health Disclaimer',
                        'SereNote is a wellness tool and not a substitute for professional medical or mental health advice. If you\'re experiencing a mental health crisis, please contact a qualified healthcare provider or emergency services.',
                      ),
                      _buildTermsSection(
                        '5. Account Security',
                        'You are responsible for maintaining the confidentiality of your account credentials. Please notify us immediately if you suspect unauthorized access.',
                      ),
                      _buildTermsSection(
                        '6. Changes to Terms',
                        'We may update these terms periodically. Continued use of SereNote after changes constitutes acceptance of the updated terms.',
                      ),
                      _buildTermsSection(
                        '7. Mindful Community',
                        'SereNote is built on principles of kindness, respect, and mindfulness. We encourage users to approach their journey with compassion for themselves and others.',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Last updated: October 2025',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _agreedToTerms = true;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 71, 134, 145),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'I Agree',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 50, 100, 110),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    final loc = AppLocalizations.of(context);

    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService().signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _fullNameController.text.trim(),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc?.registration_success ?? 'Registration successful! Please check your email for verification.')),
      );
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc?.error_occurred(e.toString()) ?? 'Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _getFullNameError() {
    final loc = AppLocalizations.of(context);
    if (!_fullNameTouched) return null;
    if (_fullNameController.text.trim().isEmpty) {
      return loc?.full_name_required ?? 'Full name is required';
    }
    return null;
  }

  String? _getEmailError() {
    final loc = AppLocalizations.of(context);
    if (!_emailTouched) return null;
    if (_emailController.text.trim().isEmpty) {
      return loc?.email_required ?? 'Email is required';
    }
    if (!_isEmailValid) {
      return loc?.email_invalid ?? 'Invalid email format';
    }
    return null;
  }

  String? _getPasswordError() {
    final loc = AppLocalizations.of(context);
    if (!_passwordTouched) return null;
    if (_passwordController.text.isEmpty) {
      return loc?.password_required ?? 'Password is required';
    }
    if (_passwordController.text.length < 6) {
      return loc?.password_length_error ?? 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _getConfirmPasswordError() {
    final loc = AppLocalizations.of(context);
    if (!_confirmPasswordTouched) return null;
    if (_confirmPasswordController.text.isEmpty) {
      return loc?.confirm_password_required ?? 'Please confirm your password';
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return loc?.passwords_not_match ?? 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_shimmerController == null || _pulseController == null) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 239, 245, 247),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 245, 247),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              TweenAnimationBuilder<double>(
                tween: Tween(begin: -50.0, end: 0.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 71, 134, 145)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              
              // Title with shimmer
              AnimatedBuilder(
                animation: _shimmerController!,
                builder: (context, child) {
                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: const [
                          Color.fromARGB(255, 50, 100, 110),
                          Color.fromARGB(255, 71, 134, 145),
                          Color.fromARGB(255, 120, 200, 215),
                          Color.fromARGB(255, 71, 134, 145),
                          Color.fromARGB(255, 50, 100, 110),
                        ],
                        stops: [
                          0.0,
                          _shimmerController!.value - 0.2,
                          _shimmerController!.value,
                          _shimmerController!.value + 0.2,
                          1.0,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      loc?.create_account ?? 'Create Account',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              
              // Subtitle
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Text(
                      loc?.signup_subtitle ?? 'Sign up to get started with SereNote',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              
              // Text fields
              _buildAnimatedTextField(
                controller: _fullNameController,
                label: loc?.full_name_label ?? 'Full Name',
                icon: Icons.person,
                delay: 200,
                errorText: _getFullNameError(),
                onChanged: (value) {
                  setState(() {
                    _fullNameTouched = true;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildAnimatedTextField(
                controller: _emailController,
                label: loc?.email_label ?? 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                delay: 400,
                errorText: _getEmailError(),
                onChanged: (value) {
                  setState(() {
                    _emailTouched = true;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildAnimatedTextField(
                controller: _passwordController,
                label: loc?.password_label ?? 'Password',
                icon: Icons.lock,
                obscureText: _obscurePassword,
                delay: 600,
                errorText: _getPasswordError(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    _passwordTouched = true;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildAnimatedTextField(
                controller: _confirmPasswordController,
                label: loc?.confirm_password_label ?? 'Confirm Password',
                icon: Icons.lock,
                obscureText: _obscureConfirmPassword,
                delay: 800,
                errorText: _getConfirmPasswordError(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    _confirmPasswordTouched = true;
                  });
                },
              ),
              const SizedBox(height: 20),
              
              // Terms and Conditions Checkbox
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 71, 134, 145),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 71, 134, 145),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _showTermsAndConditions,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 3000),
                      builder: (context, fadeValue, child) {
                        return Opacity(
                          opacity: fadeValue,
                          child: AnimatedBuilder(
                            animation: _pulseController!,
                            builder: (context, child) {
                              final scale = _isFormValid ? 1.0 + (_pulseController!.value * 0.03) : 1.0;
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: _isFormValid ? [
                                      BoxShadow(
                                        color: const Color.fromARGB(255, 71, 134, 145)
                                            .withOpacity(0.3 * _pulseController!.value),
                                        blurRadius: 15 * _pulseController!.value,
                                        spreadRadius: 2 * _pulseController!.value,
                                      ),
                                    ] : [],
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _isFormValid ? _register : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isFormValid 
                                            ? const Color.fromARGB(255, 71, 134, 145)
                                            : Colors.grey.shade400,
                                        disabledBackgroundColor: Colors.grey.shade400,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: _isFormValid ? 4 : 1,
                                      ),
                                      child: Text(
                                        loc?.create_account_button ?? 'Create Account',
                                        style: TextStyle(
                                          color: _isFormValid ? Colors.white : Colors.grey.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 20),
              
              // Login link
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 2700),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Text(
                          loc?.already_have_account ?? "Already have an account? Login",
                          style: const TextStyle(color: Color.fromARGB(255, 71, 134, 145)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int delay,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? errorText,
    Function(String)? onChanged,
  }) {
    final hasError = errorText != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey,
                width: hasError ? 2 : 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey,
                width: hasError ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : const Color.fromARGB(255, 71, 134, 145),
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              icon,
              color: hasError ? Colors.red : null,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}