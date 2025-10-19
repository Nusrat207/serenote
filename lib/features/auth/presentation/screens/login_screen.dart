import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/core/services/auth_service.dart';
import 'package:serenote/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:serenote/features/journal/presentation/providers/journal_provider.dart';
import 'package:serenote/features/mood/presentation/providers/mood_provider.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/features/auth/presentation/widgets/animated_welcome_back.dart';
import 'package:serenote/l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  AnimationController? _fadeController;
  AnimationController? _slideController;
  AnimationController? _buttonController;

  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _buttonScaleAnimation;

  Animation<double>? _emailFadeAnimation;
  Animation<double>? _passwordFadeAnimation;
  Animation<double>? _forgotPasswordFadeAnimation;
  Animation<double>? _buttonFadeAnimation;
  Animation<double>? _signupFadeAnimation;

  bool _animationsInitialized = false;

  // Validation flags
  bool _emailTouched = false;
  bool _passwordTouched = false;

  bool get _isEmailValid {
    final email = _emailController.text.trim();
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool get _isPasswordValid {
    return _passwordController.text.length >= 6;
  }

  bool get _isFormValid {
    return _isEmailValid && _isPasswordValid;
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    // Add listeners to update state when text changes
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController!, curve: Curves.easeInOut);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController!, curve: Curves.easeOutCubic),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController!, curve: Curves.easeInOut),
    );

    _emailFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController!, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _passwordFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController!, curve: const Interval(0.3, 0.7, curve: Curves.easeOut)),
    );
    _forgotPasswordFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController!, curve: const Interval(0.5, 0.8, curve: Curves.easeOut)),
    );
    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController!, curve: const Interval(0.6, 0.9, curve: Curves.easeOut)),
    );
    _signupFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController!, curve: const Interval(0.7, 1.0, curve: Curves.easeOut)),
    );

    _animationsInitialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }

  void _startAnimations() {
    _fadeController?.forward();
    _slideController?.forward();
  }

  Animation<double> _getFadeAnimation(Animation<double>? animation) {
    return animation ?? AlwaysStoppedAnimation(1.0);
  }

  Animation<Offset> _getSlideAnimation(Animation<Offset>? animation) {
    return animation ?? const AlwaysStoppedAnimation(Offset.zero);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController?.dispose();
    _slideController?.dispose();
    _buttonController?.dispose();
    super.dispose();
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

  Future<void> _login() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    final loc = AppLocalizations.of(context);

    try {
      await AuthService().signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      final String userId = Supabase.instance.client.auth.currentUser!.id;
      print('✅ LOGIN SUCCESS - User ID: $userId');

      await ref.read(moodEntriesProvider.notifier).refreshEntries();
      await ref.read(journalListProvider.notifier).loadJournals();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc?.error_occurred(e.toString()) ?? 'Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goBack() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
      (route) => false,
    );
  }

  void _onLoginPressed() {
    if (!_isFormValid) return;
    
    _buttonController?.forward().then((_) {
      _buttonController?.reverse();
    });
    _login();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 245, 247),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _getFadeAnimation(_fadeAnimation),
                child: IconButton(
                  onPressed: _goBack,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 71, 134, 145),
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),

              const SizedBox(height: 20),

              AnimatedWelcomeBack(
                text: loc?.welcome_back ?? 'Welcome Back',
                baseColor: const Color.fromARGB(255, 71, 134, 145),
              ),

              const SizedBox(height: 8),

              FadeTransition(
                opacity: _getFadeAnimation(_fadeAnimation),
                child: Text(
                  loc?.sign_in_subtitle ?? 'Sign in to continue your journey',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 40),

              FadeTransition(
                opacity: _getFadeAnimation(_emailFadeAnimation),
                child: SlideTransition(
                  position: _getSlideAnimation(_slideAnimation),
                  child: _buildValidatedTextField(
                    controller: _emailController,
                    label: loc?.email_label ?? 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _getEmailError(),
                    onChanged: (value) {
                      setState(() {
                        _emailTouched = true;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              FadeTransition(
                opacity: _getFadeAnimation(_passwordFadeAnimation),
                child: SlideTransition(
                  position: _getSlideAnimation(_slideAnimation),
                  child: _buildValidatedTextField(
                    controller: _passwordController,
                    label: loc?.password_label ?? 'Password',
                    icon: Icons.lock,
                    obscureText: _obscurePassword,
                    errorText: _getPasswordError(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
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
                ),
              ),

              const SizedBox(height: 16),

              FadeTransition(
                opacity: _getFadeAnimation(_forgotPasswordFadeAnimation),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      loc?.forgot_password ?? 'Forgot Password?',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 71, 134, 145),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              FadeTransition(
                opacity: _getFadeAnimation(_buttonFadeAnimation),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ScaleTransition(
                        scale: _getFadeAnimation(_buttonScaleAnimation),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isFormValid ? _onLoginPressed : null,
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
                              loc?.sign_in_button ?? 'Sign In',
                              style: TextStyle(
                                color: _isFormValid ? Colors.white : Colors.grey.shade600,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              FadeTransition(
                opacity: _getFadeAnimation(_signupFadeAnimation),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      loc?.signup_prompt ?? "Don't have an account? Sign up",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 71, 134, 145),
                      ),
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

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
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