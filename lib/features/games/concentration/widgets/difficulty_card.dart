import '../enums/difficulty.dart';
import '../global/global.dart';
import '../utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef DifficultyCallback = Function(Difficulty difficulty);

class DifficultyCard extends StatelessWidget {
  DifficultyCard({
    Key? key,
    required this.difficulty,
    required this.selected,
    required this.difficultyCallback,
  }) : super(key: key);

  final bool selected;
  final Difficulty difficulty;
  final DifficultyCallback difficultyCallback;

  late final _backgroundGradient = difficulty == Difficulty.easy
      ? const LinearGradient(colors: [Color(0xFF4C956C), Color(0xFF6BCB98)])
      : difficulty == Difficulty.intermediate
          ? const LinearGradient(colors: [Color(0xFFFCBC5D), Color(0xFFFFD97D)])
          : const LinearGradient(colors: [Color(0xFFC1121F), Color(0xFFEF3E36)]);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: selected ? 112 : 96,
      height: selected ? 102 : 87,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: _backgroundGradient,
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white24,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, -2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        border: selected
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
      child: GestureDetector(
        onTap: () {
          difficultyCallback(difficulty);
          HapticFeedback.mediumImpact();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Icon(
                  difficulty == Difficulty.intermediate ||
                          difficulty == Difficulty.hard
                      ? Icons.star
                      : Icons.star_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Icon(
                  difficulty == Difficulty.hard
                      ? Icons.star
                      : Icons.star_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              difficulty.name.capitalize(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
