// animated_app_bar.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serenote/l10n/app_localizations.dart';
import 'dart:math';
import 'dart:async';

class AnimatedAppBar extends StatefulWidget {
  const AnimatedAppBar({Key? key}) : super(key: key);

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Update every 2 minutes
    Timer.periodic(Duration(minutes: 2), (timer) {
      if (mounted) {
        setState(() {
          _controller.reset();
          _controller.forward();
        });
      }
    });
  }

  String _getTimeBasedEmoji() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return '☀️';
    if (hour >= 12 && hour < 17) return '😎';
    if (hour >= 17 && hour < 20) return '🌇';
    return '🌙';
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return AppLocalizations.of(context)?.good_morning ?? 'Good Morning';
    }
    if (hour >= 12 && hour < 17) {
      return AppLocalizations.of(context)?.good_afternoon ?? 'Good Afternoon';
    }
    if (hour >= 17 && hour < 21) {
      return AppLocalizations.of(context)?.good_evening ?? 'Good Evening';
    }
    return AppLocalizations.of(context)?.good_night ?? 'Good Night';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SliverAppBar(
          expandedHeight: 140,
          floating: false,
          pinned: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            title: FadeTransition(
              opacity: _opacityAnimation,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      _getTimeBasedEmoji(),
                      key: ValueKey(_getTimeBasedEmoji()),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        DateFormat('EEEE, MMM dd').format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            titlePadding: const EdgeInsets.only(left: 30, bottom: 16),
            background: _buildAnimatedBackground(),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(child: _buildFloatingParticles());
  }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(5, (index) {
        return _FloatingParticle(
          key: ValueKey(index),
          delay: index * 200,
          size: 8 + Random().nextDouble() * 16,
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _FloatingParticle extends StatefulWidget {
  final int delay;
  final double size;

  const _FloatingParticle({Key? key, required this.delay, required this.size})
    : super(key: key);

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topAnimation;
  late Animation<double> _leftAnimation;
  late double _startTop;
  late double _startLeft;
  late double _endTop;
  late double _endLeft;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4 + Random().nextInt(3)),
    );

    _initializePositions();

    _topAnimation = Tween<double>(
      begin: _startTop,
      end: _endTop,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _leftAnimation = Tween<double>(
      begin: _startLeft,
      end: _endLeft,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  void _initializePositions() {
    _startTop = Random().nextDouble() * 100;
    _startLeft = Random().nextDouble() * 100;
    _endTop = Random().nextDouble() * 100;
    _endLeft = Random().nextDouble() * 100;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: _topAnimation.value,
          left: _leftAnimation.value * screenWidth / 100,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
