import 'package:flutter/material.dart';
import '../providers/tetris_provider.dart';
import '../models/game_state.dart';


class GameControls extends StatelessWidget {
  final TetrisProvider provider;

  const GameControls({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.restart_alt,
            onPressed: () => provider.startGame(provider.state.difficulty),
            color: Colors.orange,
          ),
          _buildControlButton(
            icon: Icons.replay,
            onPressed: provider.rotate,
            color: Colors.purple,
          ),
          _buildControlButton(
            icon: provider.state.status == GameStatus.playing
                ? Icons.pause
                : Icons.play_arrow,
            onPressed: provider.state.status == GameStatus.playing
                ? provider.pauseGame
                : provider.resumeGame,
            color: Colors.blue,
          ),
          _buildControlButton(
            icon: Icons.arrow_left,
            onPressed: provider.moveLeft,
            color: Colors.cyan,
          ),
          _buildControlButton(
            icon: Icons.arrow_downward,
            onPressed: provider.moveDown,
            color: Colors.cyan,
          ),
          _buildControlButton(
            icon: Icons.arrow_right,
            onPressed: provider.moveRight,
            color: Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }
}