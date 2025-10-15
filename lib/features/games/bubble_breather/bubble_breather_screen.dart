// features/games/bubble_breather/bubble_breather_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class BubbleBreatherScreen extends StatefulWidget {
  const BubbleBreatherScreen({Key? key}) : super(key: key);

  @override
  State<BubbleBreatherScreen> createState() => _BubbleBreatherScreenState();
}

class _BubbleBreatherScreenState extends State<BubbleBreatherScreen>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;
  
  bool _isBreathingIn = false;
  int _breathCount = 0;
  String _breathPhase = "Tap to begin";

  @override
  void initState() {
    super.initState();
    
    // Create animation controller for smooth breathing
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000), // 4 seconds for inhale/exhale
    );

    _breatheAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breatheController,
      curve: Curves.easeInOut,
    ));

    _breatheController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _breathPhase = "Release to breathe out";
        });
      }
    });
  }

  void _startBreathing() {
    if (!_isBreathingIn) {
      setState(() {
        _isBreathingIn = true;
        _breathPhase = "Breathe in...";
      });
      
      // Haptic feedback
      HapticFeedback.lightImpact();
      
      _breatheController.forward();
    }
  }

  void _stopBreathing() {
    if (_isBreathingIn) {
      setState(() {
        _isBreathingIn = false;
        _breathPhase = "Breathe out...";
        _breathCount++;
      });
      
      // Haptic feedback
      HapticFeedback.lightImpact();
      
      _breatheController.reverse().then((_) {
        if (!_isBreathingIn) {
          setState(() {
            _breathPhase = "Tap to breathe in";
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
  const Color(0xFF5B4B8A), // Deep lavender base
  const Color(0xFF8E7CC3), // Soft pastel lavender
  const Color(0xFFB8A9D6), // Light cool lavender highlight
],

          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    Text(
                      'Breath Count: $_breathCount',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Bubble Breather',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const Spacer(),

              // Breathing Bubble
              GestureDetector(
                onTapDown: (_) => _startBreathing(),
                onTapUp: (_) => _stopBreathing(),
                onTapCancel: _stopBreathing,
                child: AnimatedBuilder(
                  animation: _breatheAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 300,
                      height: 300,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow rings
                          ...List.generate(3, (index) {
                            return Container(
                              width: 280 * _breatheAnimation.value + (index * 40),
                              height: 280 * _breatheAnimation.value + (index * 40),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue.withOpacity(
                                    0.1 * (1 - index * 0.3) * _breatheAnimation.value
                                  ),
                                  width: 2,
                                ),
                              ),
                            );
                          }),
                          
                         // Main bubble
Container(
  width: 200 * _breatheAnimation.value,
  height: 200 * _breatheAnimation.value,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      colors: [
        const Color(0xFF9A80D0).withOpacity(0.8), // darker lavender core
        const Color(0xFF7A5AB8).withOpacity(0.6), // mid-tone violet
        const Color(0xFF5B3E99).withOpacity(0.5), // deep lavender edge
      ],
      center: Alignment.center,
      radius: 0.85,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF7A5AB8).withOpacity(0.5 * _breatheAnimation.value),
        blurRadius: 40 * _breatheAnimation.value,
        spreadRadius: 10 * _breatheAnimation.value,
      ),
    ],
  ),
),

                          
                          // Center dot
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Breath phase text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _breathPhase,
                  key: ValueKey<String>(_breathPhase),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const Spacer(),

              // Instructions
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    _buildInstructionRow(
                      Icons.touch_app,
                      'Hold to breathe in',
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionRow(
                      Icons.air,
                      'Release to breathe out',
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionRow(
                      Icons.repeat,
                      'Find your rhythm',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white54,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}