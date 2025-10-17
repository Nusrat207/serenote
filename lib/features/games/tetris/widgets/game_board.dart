import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tetris_provider.dart';
import '../models/tetromino.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TetrisProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D1226),
            border: Border.all(
              color: const Color(0xFF00F0F0),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F0F0).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              TetrisProvider.boardHeight,
              (y) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  TetrisProvider.boardWidth,
                  (x) => _buildCell(provider, x, y),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell(TetrisProvider provider, int x, int y) {
    Color cellColor = const Color(0xFF0D1226);
    bool hasBorder = false;

    // Check board
    if (provider.state.board[y][x] != null) {
      final type = TetrominoType.values[provider.state.board[y][x]!];
      cellColor = Tetromino.create(type).color;
      hasBorder = true;
    }

    // Check current piece
    if (provider.state.currentPiece != null) {
      final piece = provider.state.currentPiece!;
      final pos = provider.state.currentPosition;

      for (int py = 0; py < piece.shape.length; py++) {
        for (int px = 0; px < piece.shape[py].length; px++) {
          if (piece.shape[py][px] == 1) {
            final boardX = pos.x + px;
            final boardY = pos.y + py;
            if (boardX == x && boardY == y) {
              cellColor = piece.color;
              hasBorder = true;
            }
          }
        }
      }
    }

    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: cellColor,
        border: hasBorder
            ? Border.all(color: Colors.black26, width: 1)
            : null,
        boxShadow: hasBorder
            ? [
                BoxShadow(
                  color: cellColor.withOpacity(0.5),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
    );
  }
}