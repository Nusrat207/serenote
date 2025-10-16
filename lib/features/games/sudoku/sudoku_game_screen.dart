import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

enum Difficulty { easy, medium, hard }

class SudokuGameScreen extends StatefulWidget {
  const SudokuGameScreen({Key? key}) : super(key: key);

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  late Sudoku _sudoku;
  late List<List<int>> _board;
  late List<List<int>> _solution;
  late List<List<bool>> _isFixed;
  int? _selectedRow;
  int? _selectedCol;
  Difficulty _difficulty = Difficulty.medium;
  bool _gameWon = false;
  bool _isLoading = true;
  
  Color get _difficultyColor {
    switch (_difficulty) {
      case Difficulty.easy:
        return const Color.fromARGB(255, 216, 253, 218);  // Pastel green
      case Difficulty.medium:
        return const Color(0xFFFFDAB9); // Pastel orange
      case Difficulty.hard:
        return const Color.fromARGB(255, 246, 172, 172);  // Pastel red/pink
    }
  }
  
  Color get _difficultyDarkColor {
    switch (_difficulty) {
      case Difficulty.easy:
        return const Color.fromARGB(255, 122, 161, 118); 
      case Difficulty.medium:
        return const Color.fromARGB(255, 204, 160, 103); 
      case Difficulty.hard:
        return const Color.fromARGB(255, 174, 84, 84); 
    }
  }
  
  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    setState(() {
      _isLoading = true;
    });
    
    // Generate puzzle
    _sudoku = Sudoku.generate(_getDifficultyLevel());
    _board = List.generate(9, (i) => List.generate(9, (j) => -1));
    _solution = List.generate(9, (i) => List.generate(9, (j) => 0));
    _isFixed = List.generate(9, (i) => List.generate(9, (j) => false));
    
    // Parse the puzzle and solution
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        int idx = i * 9 + j;
        _board[i][j] = _sudoku.puzzle[idx];
        _solution[i][j] = _sudoku.solution[idx];
        _isFixed[i][j] = _sudoku.puzzle[idx] != -1;
      }
    }
    
    setState(() {
      _selectedRow = null;
      _selectedCol = null;
      _gameWon = false;
      _isLoading = false;
    });
    
    // Debug print
    print('Puzzle generated - Difficulty: $_difficulty');
    print('First row: ${_board[0]}');
  }

  Level _getDifficultyLevel() {
    switch (_difficulty) {
      case Difficulty.easy:
        return Level.easy;
      case Difficulty.medium:
        return Level.medium;
      case Difficulty.hard:
        return Level.hard;
    }
  }

  void _selectCell(int row, int col) {
    print('Cell tapped: row=$row, col=$col, isFixed=${_isFixed[row][col]}');
    if (!_isFixed[row][col] && !_gameWon) {
      setState(() {
        _selectedRow = row;
        _selectedCol = col;
      });
      print('Cell selected: $_selectedRow, $_selectedCol');
    } else {
      print('Cannot select - fixed cell or game won');
    }
  }

  void _inputNumber(int num) {
    print('Number $num tapped. Selected: $_selectedRow, $_selectedCol');
    if (_selectedRow != null && _selectedCol != null && !_gameWon) {
      setState(() {
        _board[_selectedRow!][_selectedCol!] = num;
        print('Number placed at ($_selectedRow, $_selectedCol): $num');
      });
      _checkWin();
    }
  }

  void _clearCell() {
    if (_selectedRow != null && _selectedCol != null && !_isFixed[_selectedRow!][_selectedCol!]) {
      setState(() {
        _board[_selectedRow!][_selectedCol!] = -1;
      });
      print('Cell cleared at ($_selectedRow, $_selectedCol)');
    }
  }

  void _checkWin() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_board[i][j] != _solution[i][j]) {
          return;
        }
      }
    }
    setState(() {
      _gameWon = true;
    });
    print('Game Won!');
  }

  void _newGame(Difficulty difficulty) {
    setState(() {
      _difficulty = difficulty;
    });
    _initGame();
  }

  bool _hasConflict(int row, int col) {
    if (_board[row][col] == -1) return false;
    
    int val = _board[row][col];
    
    // Check row
    for (int j = 0; j < 9; j++) {
      if (j != col && _board[row][j] == val) return true;
    }
    
    // Check column
    for (int i = 0; i < 9; i++) {
      if (i != row && _board[i][col] == val) return true;
    }
    
    // Check 3x3 box
    int boxRow = (row ~/ 3) * 3;
    int boxCol = (col ~/ 3) * 3;
    for (int i = boxRow; i < boxRow + 3; i++) {
      for (int j = boxCol; j < boxCol + 3; j++) {
        if ((i != row || j != col) && _board[i][j] == val) return true;
      }
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sudoku')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Sudoku'),
        backgroundColor: _difficultyDarkColor,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _initGame(),
            tooltip: 'New Game',
          ),
          PopupMenuButton<Difficulty>(
            icon: const Icon(Icons.tune),
            onSelected: _newGame,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Difficulty.easy,
                child: Text('Easy'),
              ),
              const PopupMenuItem(
                value: Difficulty.medium,
                child: Text('Medium'),
              ),
              const PopupMenuItem(
                value: Difficulty.hard,
                child: Text('Hard'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _difficultyDarkColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _difficulty.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (_gameWon)
                    const Row(
                      children: [
                        Icon(Icons.celebration, color: Colors.green, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'You Won!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: _buildBoard(),
                  ),
                ),
              ),
            ),
            _buildNumberPad(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(9, (i) {
          return Expanded(
            child: Row(
              children: List.generate(9, (j) {
                return Expanded(
                  child: _buildCell(i, j),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCell(int row, int col) {
    bool isSelected = _selectedRow == row && _selectedCol == col;
    bool isFixed = _isFixed[row][col];
    bool hasConflict = _hasConflict(row, col);
    int value = _board[row][col];
    
    return InkWell(
      onTap: () => _selectCell(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? _difficultyColor
              : hasConflict
                  ? Colors.red.shade200
                  : (row ~/ 3 + col ~/ 3) % 2 == 0
                      ? Colors.grey.shade50
                      : Colors.white,
          border: Border(
            right: BorderSide(
              color: Colors.grey.shade400,
              width: (col + 1) % 3 == 0 && col != 8 ? 2.5 : 0.8,
            ),
            bottom: BorderSide(
              color: Colors.grey.shade400,
              width: (row + 1) % 3 == 0 && row != 8 ? 2.5 : 0.8,
            ),
          ),
        ),
        child: Center(
          child: value != -1
              ? Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isFixed ? Colors.black : _difficultyDarkColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              int num = i + 1;
              return _buildNumberButton(num);
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(4, (i) {
                int num = i + 6;
                return _buildNumberButton(num);
              }),
              _buildClearButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(int num) {
    return Material(
      color: _difficultyDarkColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => _inputNumber(num),
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Text(
            '$num',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return Material(
      color: Colors.red.shade600,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: _clearCell,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: const Icon(
            Icons.backspace_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}