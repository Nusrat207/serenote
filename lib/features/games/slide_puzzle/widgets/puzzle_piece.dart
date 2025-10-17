import 'package:flutter/material.dart';

class PuzzlePiece extends StatelessWidget {
  final int number;
  final bool isEmpty;
  final VoidCallback onTap;
  final bool isCorrectPosition;
  final double size;

  const PuzzlePiece({
    super.key,
    required this.number,
    required this.isEmpty,
    required this.onTap,
    required this.isCorrectPosition,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEmpty ? null : onTap,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isEmpty ? Colors.transparent : _getTileColor(),
          borderRadius: BorderRadius.circular(8),
          border: isEmpty ? null : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: isEmpty
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: isEmpty
            ? null
            : Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: size * 0.3,
                    fontWeight: FontWeight.bold,
                    color: isCorrectPosition ? Colors.white : Colors.black87,
                  ),
                ),
              ),
      ),
    );
  }

  Color _getTileColor() {
    if (isCorrectPosition) {
      return Colors.green.shade600;
    }
    return Colors.blue.shade100;
  }
}