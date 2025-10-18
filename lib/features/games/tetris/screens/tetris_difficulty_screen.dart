
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'tetris_game_screen.dart';

class TetrisDifficultyScreen extends StatelessWidget {
  const TetrisDifficultyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 82, 96, 124),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        title: const Text(
          'TETRIS',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              const SizedBox(height: 40),
              _buildDifficultyCard(
                context,
                'EASY',
                'Perfect for beginners',
                'Starting speed: Slow',
                Colors.green,
                Difficulty.easy,
              ),
              const SizedBox(height: 16),
              _buildDifficultyCard(
                context,
                'MEDIUM',
                'Balanced gameplay',
                'Starting speed: Moderate',
                Colors.blue,
                Difficulty.medium,
              ),
              const SizedBox(height: 16),
              _buildDifficultyCard(
                context,
                'HARD',
                'For experienced players',
                'Starting speed: Fast',
                Colors.orange,
                Difficulty.hard,
              ),
              const SizedBox(height: 16),
              _buildDifficultyCard(
                context,
                'EXPERT',
                'Ultimate challenge',
                'Starting speed: Very Fast',
                Colors.red,
                Difficulty.expert,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    Color color,
    Difficulty difficulty,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TetrisGameScreen(difficulty: difficulty),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F3A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.videogame_asset,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
