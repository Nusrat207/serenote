import 'package:flutter/material.dart';

enum TetrominoType { I, O, T, S, Z, J, L }

class Tetromino {
  final TetrominoType type;
  final Color color;
  final List<List<int>> shape;
  int rotation;

  Tetromino({
    required this.type,
    required this.color,
    required this.shape,
    this.rotation = 0,
  });

  static Tetromino createRandom() {
    final types = TetrominoType.values;
    final type = types[DateTime.now().microsecond % types.length];
    return create(type);
  }

  static Tetromino create(TetrominoType type) {
    switch (type) {
      case TetrominoType.I:
        return Tetromino(
          type: type,
          color: const Color(0xFF00F0F0),
          shape: [
            [0, 0, 0, 0],
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
          ],
        );
        case TetrominoType.O:
        return Tetromino(
          type: type,
          color: const Color(0xFFF0F000),
          shape: [
            [1, 1],
            [1, 1],
          ],
        );
      case TetrominoType.T:
        return Tetromino(
          type: type,
          color: const Color(0xFFA000F0),
          shape: [
            [0, 1, 0],
            [1, 1, 1],
            [0, 0, 0],
          ],
        );
      case TetrominoType.S:
        return Tetromino(
          type: type,
          color: const Color(0xFF00F000),
          shape: [
            [0, 1, 1],
            [1, 1, 0],
            [0, 0, 0],
          ],
        );
      case TetrominoType.Z:
        return Tetromino(
          type: type,
          color: const Color(0xFFF00000),
          shape: [
            [1, 1, 0],
            [0, 1, 1],
            [0, 0, 0],
          ],
        );
      case TetrominoType.J:
      return Tetromino(
          type: type,
          color: const Color(0xFF0000F0),
          shape: [
            [1, 0, 0],
            [1, 1, 1],
            [0, 0, 0],
          ],
        );
      case TetrominoType.L:
        return Tetromino(
          type: type,
          color: const Color(0xFFF0A000),
          shape: [
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 0],
          ],
        );
    }
  }
List<List<int>> rotate() {
    final n = shape.length;
    final rotated = List.generate(n, (_) => List.filled(n, 0));
    
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        rotated[j][n - 1 - i] = shape[i][j];
      }
    }
    return rotated;
  }

  Tetromino copyWith({List<List<int>>? shape, int? rotation}) {
    return Tetromino(
      type: type,
      color: color,
      shape: shape ?? this.shape,
      rotation: rotation ?? this.rotation,
    );
  }
}