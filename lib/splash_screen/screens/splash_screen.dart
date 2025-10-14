import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _particleController;
  late AnimationController _rotateController;

  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleInAnimation;
  late Animation<double> _scaleOutAnimation;
  late Animation<double> _rotationAnimation;

  int _currentPhase = 0; // 0: Logo, 1-3: Messages
  int _nextPhase = -1;

  final List<MessageData> _messages = [
    MessageData(
      text: "More Positive",
      icon: Icons.wb_sunny_outlined,
      gradient: [Color(0xFFFFF9C4), Color(0xFFFFE082)],
      exitAnimation: AnimationType.zoomOut,
      enterAnimation: AnimationType.fadeScale,
    ),
    MessageData(
      text: "More Healthy",
      icon: Icons.favorite_outline,
      gradient: [Color(0xFFE1F5DC), Color(0xFFC8E6C9)],
      exitAnimation: AnimationType.rotateOut,
      enterAnimation: AnimationType.slideFromRight,
    ),
    MessageData(
      text: "More Happiness",
      icon: Icons.auto_awesome_outlined,
      gradient: [Color(0xFFF8E1FF), Color(0xFFE1BEE7)],
      exitAnimation: AnimationType.fadeUp,
      enterAnimation: AnimationType.bounceIn,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600), // faster
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 600), // faster
      vsync: this,
    );

    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInCubic),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleInAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _scaleOutAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInCubic),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rotateController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startSequence() async {
    // Logo phase
    await Future.delayed(const Duration(milliseconds: 100));
    await _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    // Three message phases, each around 800 ms
    for (int i = 1; i <= 3; i++) {
      await _transitionToPhase(i);
      await Future.delayed(const Duration(milliseconds: 800));
    }

    // Navigate to home
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _transitionToPhase(int newPhase) async {
    setState(() {
      _nextPhase = newPhase;
    });

    _fadeController.reset();
    _rotateController.reset();
    _rotateController.forward();
    await _fadeController.forward();

    setState(() {
      _currentPhase = newPhase;
      _nextPhase = -1;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _particleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  List<Color> _getGradientForPhase(int phase) {
    if (phase == 0) {
      return [Color(0xFFE8F5E9), Color(0xFFC8E6C9)];
    }
    return _messages[phase - 1].gradient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500), // faster gradient transition
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                _getGradientForPhase(_nextPhase != -1 ? _nextPhase : _currentPhase),
          ),
        ),
        child: Stack(
          children: [
            _buildParticleBackground(),
            Stack(
              children: [
                if (_nextPhase != -1)
                  Center(child: _buildExitingContent(_currentPhase)),
                Center(
                    child: _buildEnteringContent(
                        _nextPhase != -1 ? _nextPhase : _currentPhase)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExitingContent(int phase) {
    if (phase == 0) {
      return FadeTransition(
        opacity: _fadeOutAnimation,
        child: ScaleTransition(
          scale: _scaleOutAnimation,
          child: _buildLogoContent(),
        ),
      );
    }

    final message = _messages[phase - 1];
    switch (message.exitAnimation) {
      case AnimationType.zoomOut:
        return FadeTransition(
          opacity: _fadeOutAnimation,
          child: ScaleTransition(
            scale: _scaleOutAnimation,
            child: _buildMessageContent(phase - 1),
          ),
        );
      case AnimationType.rotateOut:
        return FadeTransition(
          opacity: _fadeOutAnimation,
          child: RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 0.5).animate(_fadeController),
            child: ScaleTransition(
              scale: _scaleOutAnimation,
              child: _buildMessageContent(phase - 1),
            ),
          ),
        );
      case AnimationType.fadeUp:
        return FadeTransition(
          opacity: _fadeOutAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, -0.5),
            ).animate(CurvedAnimation(
              parent: _fadeController,
              curve: const Interval(0.0, 0.4, curve: Curves.easeInCubic),
            )),
            child: _buildMessageContent(phase - 1),
          ),
        );
      default:
        return FadeTransition(
          opacity: _fadeOutAnimation,
          child: _buildMessageContent(phase - 1),
        );
    }
  }

  Widget _buildEnteringContent(int phase) {
    if (phase == 0) {
      return FadeTransition(
        opacity: _fadeInAnimation,
        child: ScaleTransition(
          scale: _scaleInAnimation,
          child: _buildLogoContent(),
        ),
      );
    }

    final message = _messages[phase - 1];
    switch (message.enterAnimation) {
      case AnimationType.fadeScale:
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: ScaleTransition(
            scale: _scaleInAnimation,
            child: _buildMessageContent(phase - 1),
          ),
        );
      case AnimationType.slideFromRight:
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _fadeController,
              curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
            )),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _fadeController,
                  curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: _buildMessageContent(phase - 1),
            ),
          ),
        );
      case AnimationType.bounceIn:
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _fadeController,
                curve: const Interval(0.5, 1.0, curve: Curves.bounceOut),
              ),
            ),
            child: RotationTransition(
              turns: Tween<double>(begin: -0.2, end: 0.0).animate(
                CurvedAnimation(
                  parent: _fadeController,
                  curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: _buildMessageContent(phase - 1),
            ),
          ),
        );
      default:
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: _buildMessageContent(phase - 1),
        );
    }
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particleController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildLogoContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/images/logo.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Color(0xFF4CAF50),
                Color(0xFF66BB6A),
                Color(0xFF81C784),
              ],
              stops: [0.0, _particleController.value, 1.0],
            ).createShader(bounds);
          },
          child: const Text(
            'SereNote',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A mindful companion',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(int messageIndex) {
    final message = _messages[messageIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(
            message.icon,
            size: 56,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          message.text,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.6,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

enum AnimationType {
  fadeScale,
  zoomOut,
  rotateOut,
  slideFromRight,
  fadeUp,
  bounceIn,
}

class MessageData {
  final String text;
  final IconData icon;
  final List<Color> gradient;
  final AnimationType exitAnimation;
  final AnimationType enterAnimation;

  MessageData({
    required this.text,
    required this.icon,
    required this.gradient,
    required this.exitAnimation,
    required this.enterAnimation,
  });
}

class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 15; i++) {
      final x = (size.width / 15) * i;
      final y = (math.sin((animationValue * 2 * math.pi) + i) * 40) +
          (size.height / 3);
      final radius = 2.5 + (math.sin(animationValue * math.pi + i) * 1.5);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    for (int i = 0; i < 8; i++) {
      final x = (size.width / 8) * i + 30;
      final y = (math.cos((animationValue * math.pi) + i * 0.5) * 60) +
          (size.height * 0.7);
      final radius = 4 + (math.cos(animationValue * 2 * math.pi + i) * 2);
      paint.color = Colors.white.withOpacity(0.05);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
