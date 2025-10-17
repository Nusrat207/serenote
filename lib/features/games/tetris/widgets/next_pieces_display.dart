import 'package:flutter/material.dart';
import '../models/tetromino.dart';

class NextPiecesDisplay extends StatelessWidget {
  final List<Tetromino> nextPieces;

  const NextPiecesDisplay({Key? key, required this.nextPieces}) : super(key: key);

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
            'NEXT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          ...nextPieces.take(3).map((piece) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMiniPiece(piece),
              )),
        ],
      ),
    );
  }

  Widget _buildMiniPiece(Tetromino piece) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
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