import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../widgets/puzzle_piece.dart';
import '../models/difficulty_level.dart';

class SlidePuzzleScreen extends StatefulWidget {
  final DifficultyLevel difficulty;

  const SlidePuzzleScreen({super.key, required this.difficulty});

  @override
  State<SlidePuzzleScreen> createState() => _SlidePuzzleScreenState();
}

class _SlidePuzzleScreenState extends State<SlidePuzzleScreen> {
  late List<List<int?>> _puzzle;
  late List<List<int?>> _solution;
  int _moves = 0;
  int _correctTiles = 0;
  late Stopwatch _stopwatch;
  late int _emptyRow;
  late int _emptyCol;
  bool _isSolved = false;
  bool _gameStarted = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _initializePuzzle();
    // Set up timer to update UI every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameStarted && !_isSolved && mounted) {
        setState(() {}); // Trigger UI update to show new time
      }
    });
  }

  void _initializePuzzle() {
    final size = widget.difficulty.gridSize;
    _puzzle = List.generate(size, (i) => List.generate(size, (j) => i * size + j + 1));
    
    // Set the last tile as empty
    _emptyRow = size - 1;
    _emptyCol = size - 1;
    _puzzle[_emptyRow][_emptyCol] = null;
    
    _solution = List.generate(size, (i) => List.generate(size, (j) => i * size + j + 1));
    _solution[size - 1][size - 1] = null;
    
    _moves = 0;
    _correctTiles = _countCorrectTiles();
    _gameStarted = false;
    _isSolved = false;
    _stopwatch.reset();
    _shufflePuzzle();
    setState(() {});
  }

  void _shufflePuzzle() {
    // Shuffle the puzzle with valid moves
    const shuffleMoves = 100;
    final random = Random();
    
    for (int i = 0; i < shuffleMoves; i++) {
      final possibleMoves = _getPossibleMoves();
      if (possibleMoves.isNotEmpty) {
        final move = possibleMoves[random.nextInt(possibleMoves.length)];
        _swapTilesWithoutCounting(move['row']!, move['col']!);
      }
    }
    
    _correctTiles = _countCorrectTiles();
  }

  void _swapTilesWithoutCounting(int row, int col) {
    _puzzle[_emptyRow][_emptyCol] = _puzzle[row][col];
    _puzzle[row][col] = null;
    _emptyRow = row;
    _emptyCol = col;
  }

  List<Map<String, int>> _getPossibleMoves() {
    final moves = <Map<String, int>>[];
    final directions = [
      {'row': -1, 'col': 0}, // up
      {'row': 1, 'col': 0},  // down
      {'row': 0, 'col': -1}, // left
      {'row': 0, 'col': 1},  // right
    ];

    for (final dir in directions) {
      final newRow = _emptyRow + dir['row']!;
      final newCol = _emptyCol + dir['col']!;
      
      if (newRow >= 0 &&
          newRow < widget.difficulty.gridSize &&
          newCol >= 0 &&
          newCol < widget.difficulty.gridSize) {
        moves.add({'row': newRow, 'col': newCol});
      }
    }
    
    return moves;
  }

  int _countCorrectTiles() {
    int count = 0;
    final size = widget.difficulty.gridSize;
    int expectedNumber = 1;
    
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        final currentTile = _puzzle[i][j];
        
        // For the last position (bottom-right), it should be empty
        if (i == size - 1 && j == size - 1) {
          if (currentTile == null) {
            count++; // Empty space is correct
          }
        } 
        // For all other positions, check if number matches expected sequence
        else if (currentTile == expectedNumber) {
          count++;
        }
        
        // Only increment expected number for non-empty positions
        if (!(i == size - 1 && j == size - 1)) {
          expectedNumber++;
        }
      }
    }
    return count;
  }

  void _swapTiles(int row, int col) {
    setState(() {
      // Start timer on first move
      if (!_gameStarted) {
        _gameStarted = true;
        _stopwatch.start();
      }

      _puzzle[_emptyRow][_emptyCol] = _puzzle[row][col];
      _puzzle[row][col] = null;
      _emptyRow = row;
      _emptyCol = col;
      _moves++;
      _correctTiles = _countCorrectTiles();
      
      // Win condition: all positions correct (including empty space in bottom-right)
      if (_correctTiles == widget.difficulty.gridSize * widget.difficulty.gridSize) {
        _isSolved = true;
        _stopwatch.stop();
        _showSuccessDialog();
      }
    });
  }

  bool _isAdjacentToEmpty(int row, int col) {
    return (row == _emptyRow && (col == _emptyCol - 1 || col == _emptyCol + 1)) ||
           (col == _emptyCol && (row == _emptyRow - 1 || row == _emptyRow + 1));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.amber, width: 3),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'You solved the puzzle!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildStatRow(Icons.timer, 'Time:', _formatTime(_stopwatch.elapsedMilliseconds)),
              const SizedBox(height: 12),
              _buildStatRow(Icons.directions_run, 'Moves:', '$_moves'),
              const SizedBox(height: 12),
              _buildStatRow(Icons.auto_awesome, 'Difficulty:', widget.difficulty.displayName),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Center(
                  child: Text(
                    _getCongratulationMessage(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Play Again', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                    _initializePuzzle();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: const Text('Main Menu', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build consistent stat rows
  Widget _buildStatRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  String _getCongratulationMessage() {
    final timeInSeconds = _stopwatch.elapsedMilliseconds ~/ 1000;
    final movesPerSecond = _moves / timeInSeconds;
    
    if (timeInSeconds < 60 && _moves < 50) {
      return 'Amazing! You\'re a puzzle genius! 🧠';
    } else if (movesPerSecond > 2) {
      return 'Lightning fast! You solved it in record time! ⚡';
    } else if (_moves < 100) {
      return 'Excellent strategy! Very efficient moves! 🏆';
    } else {
      return 'Well done! You mastered the puzzle! 🎯';
    }
  }

  String _formatTime(int milliseconds) {
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.difficulty.gridSize;
    final pieceSize = MediaQuery.of(context).size.width * 0.8 / size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: Text(
          '${widget.difficulty.gridText} Slide Puzzle',
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 104, 75, 42),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializePuzzle,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/number_bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Stats Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Time',
                          style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 36, 98, 156)),
                        ),
                        Text(
                          _formatTime(_stopwatch.elapsedMilliseconds),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Moves',
                          style: TextStyle(fontSize: 12, color:Color.fromARGB(255, 36, 98, 156)),
                        ),
                        Text(
                          '$_moves',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Correct Tiles',
                          style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 36, 98, 156)),
                        ),
                        Text(
                          '$_correctTiles/${size * size - 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Puzzle Grid
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < size; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int j = 0; j < size; j++)
                            PuzzlePiece(
                              number: _puzzle[i][j] ?? 0,
                              isEmpty: _puzzle[i][j] == null,
                              onTap: () {
                                if (_isAdjacentToEmpty(i, j)) {
                                  _swapTiles(i, j);
                                }
                              },
                              isCorrectPosition: _puzzle[i][j] == _solution[i][j],
                              size: pieceSize,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'How to Play:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap adjacent tiles to move them into the empty space. Arrange all numbers in order from 1 to ${size * size - 1}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Important: cancel the timer to prevent memory leaks
    _stopwatch.stop();
    super.dispose();
  }
}