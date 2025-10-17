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
      
      if (_correctTiles == widget.difficulty.gridSize * widget.difficulty.gridSize - 1) {
        _isSolved = true;
        _stopwatch.stop();
        _showSuccessDialog();
      }
    });
  }

  int _countCorrectTiles() {
    int count = 0;
    for (int i = 0; i < widget.difficulty.gridSize; i++) {
      for (int j = 0; j < widget.difficulty.gridSize; j++) {
        if (_puzzle[i][j] == _solution[i][j]) {
          count++;
        }
      }
    }
    return count;
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
        title: const Text('Puzzle Solved!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${_formatTime(_stopwatch.elapsedMilliseconds)}'),
            Text('Moves: $_moves'),
            Text('Difficulty: ${widget.difficulty.displayName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializePuzzle();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Main Menu'),
          ),
        ],
      ),
    );
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
        title: Text('${widget.difficulty.gridText} Slide Puzzle',
      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
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