import 'package:flutter/material.dart';
import '../models/tetromino.dart';

class HoldPieceDisplay extends StatelessWidget {
  final Tetromino? heldPiece;

  const HoldPieceDisplay({Key? key, this.heldPiece}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          const Text(
            'HOLD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 80,
            alignment: Alignment.center,
            child: heldPiece != null
                ? _buildMiniPiece(heldPiece!)
                : const Text(
                    'Press C',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPiece(Tetromino piece) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          piece.shape.length,
          (y) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              piece.shape[y].length,
              (x) => Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: piece.shape[y][x] == 1
                      ? piece.color
                      : Colors.transparent,
                  border: piece.shape[y][x] == 1
                      ? Border.all(color: Colors.black26)
                      : null,
                ),
              ),
            ),
            ),
        ),
      ),
    );
  }
}