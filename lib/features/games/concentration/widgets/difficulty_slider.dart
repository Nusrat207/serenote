import 'package:flutter/material.dart';
import '../enums/difficulty.dart';

class DifficultySlider extends StatelessWidget {
  final Difficulty difficulty;
  final Function(Difficulty) onChanged;

  const DifficultySlider({
    Key? key,
    required this.difficulty,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex = difficulty.index;

    final colors = [
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    final labels = [
      "Easy",
      "Intermediate",
      "Hard",
    ];

    return SizedBox(
      width: double.infinity, // Force full width
      child: Column(
        children: [
          // Slider with custom track
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: colors[currentIndex],
              inactiveTrackColor: Colors.grey[300],
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 16,
                elevation: 4,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 24,
              ),
              thumbColor: colors[currentIndex],
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              overlayColor: colors[currentIndex].withOpacity(0.2),
            ),
            child: Slider(
              value: currentIndex.toDouble(),
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (value) {
                onChanged(Difficulty.values[value.toInt()]);
              },
            ),
          ),
          const SizedBox(height: 12),
          // Selected difficulty display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colors[currentIndex].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors[currentIndex].withOpacity(0.3)),
            ),
            child: Text(
              labels[currentIndex],
              style: TextStyle(
                color: colors[currentIndex],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}