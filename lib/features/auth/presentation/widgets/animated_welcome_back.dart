import 'package:flutter/material.dart';

class AnimatedWelcomeBack extends StatefulWidget { // Changed from WelcomeBackAnimator
  final String text;
  final Color baseColor;

  const AnimatedWelcomeBack({ // Changed from WelcomeBackAnimator
    super.key,
    required this.text,
    required this.baseColor,
  });

  @override
  State<AnimatedWelcomeBack> createState() => _AnimatedWelcomeBackState(); // Changed
}

class _AnimatedWelcomeBackState extends State<AnimatedWelcomeBack> // Changed
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: widget.baseColor,
      end: widget.baseColor.withOpacity(0.7),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.05),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value * 20,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _colorAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}