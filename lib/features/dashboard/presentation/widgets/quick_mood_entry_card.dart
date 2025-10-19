import 'package:flutter/material.dart';
import 'package:serenote/l10n/app_localizations.dart';
import '../../../mood/presentation/screens/quick_mood_entry_screen.dart';

class QuickMoodEntryCard extends StatefulWidget {
  const QuickMoodEntryCard({super.key});

  @override
  State<QuickMoodEntryCard> createState() => _QuickMoodEntryCardState();
}

class _QuickMoodEntryCardState extends State<QuickMoodEntryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 248, 255, 253),
              const Color.fromARGB(255, 252, 253, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 112, 111, 111).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _controller.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const QuickMoodEntryScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)?.quick_mood_title ??
                                  'How do you feel?',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            AppLocalizations.of(context)?.quick_mood_subtitle ??
                                'Quick check-in • Takes 10 seconds',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 46,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 84, 103, 91),
                          const Color.fromARGB(255, 80, 77, 80),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            224,
                            255,
                            240,
                          ).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
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
