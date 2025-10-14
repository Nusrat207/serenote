import 'package:flutter/material.dart';

class ShimmeringText extends StatefulWidget {
  final String text;
  final String subtitle;

  const ShimmeringText({
    super.key,
    required this.text,
    required this.subtitle,
  });

  @override
  State<ShimmeringText> createState() => _ShimmeringTextState();
}

class _ShimmeringTextState extends State<ShimmeringText>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Column(
          children: [
            // Main title with shimmer
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.6),
                    Colors.white,
                    Colors.white.withOpacity(0.6),
                  ],
                  stops: [0.0, _shimmerController.value, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 42, // Bigger text
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle with fade animation
            FadeTransition(
              opacity: _shimmerController,
              child: Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 18, // Bigger subtitle
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}