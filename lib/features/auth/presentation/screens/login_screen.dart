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

  // Initialize with default values first
  AnimationController? _fadeController;
  AnimationController? _slideController;
  AnimationController? _buttonController;

  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _buttonScaleAnimation;

  // Individual animations for staggered effect
  Animation<double>? _emailFadeAnimation;
  Animation<double>? _passwordFadeAnimation;
  Animation<double>? _forgotPasswordFadeAnimation;
  Animation<double>? _buttonFadeAnimation;
  Animation<double>? _signupFadeAnimation;

  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Initialize animation controllers
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

    // Main animations
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideController!,
            curve: Curves.easeOutCubic,
          ),
        );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController!, curve: Curves.easeInOut),
    );

    // Staggered fade animations with more noticeable intervals
    _emailFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController!,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _passwordFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController!,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _forgotPasswordFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController!,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController!,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    _signupFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController!,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationsInitialized = true;

    // Start animations after a brief delay to ensure widgets are built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });
  }

  void _startAnimations() {
    _fadeController?.forward();
    _slideController?.forward();
  }

  // Helper method to get animation with fallback
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

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
    // Animate button press
    _buttonController?.forward().then((_) {
      _buttonController?.reverse();
    });
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 245, 247),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
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

              // Welcome back text
              AnimatedWelcomeBack(
                text: 'Welcome Back',
                baseColor: const Color.fromARGB(255, 71, 134, 145),
              ),

              const SizedBox(height: 8),

              // Subtitle
              FadeTransition(
                opacity: _getFadeAnimation(_fadeAnimation),
                child: const Text(
                  'Sign in to continue your journey',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 40),

              // Email field with animation
              FadeTransition(
                opacity: _getFadeAnimation(_emailFadeAnimation),
                child: SlideTransition(
                  position: _getSlideAnimation(_slideAnimation),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password field with animation
              FadeTransition(
                opacity: _getFadeAnimation(_passwordFadeAnimation),
                child: SlideTransition(
                  position: _getSlideAnimation(_slideAnimation),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
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
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Forgot password with animation
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
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 71, 134, 145),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Login button with animation
              FadeTransition(
                opacity: _getFadeAnimation(_buttonFadeAnimation),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ScaleTransition(
                        scale: _getFadeAnimation(_buttonScaleAnimation),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onLoginPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                71,
                                134,
                                145,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // Sign up link with animation
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
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(
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
}
