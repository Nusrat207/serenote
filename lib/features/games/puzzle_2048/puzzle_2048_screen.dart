// lib/features/games/presentation/screens/puzzle_2048_screen.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class Puzzle2048Screen extends StatefulWidget {
  const Puzzle2048Screen({super.key});

  @override
  State<Puzzle2048Screen> createState() => _Puzzle2048ScreenState();
}

class _Puzzle2048ScreenState extends State<Puzzle2048Screen>
    with SingleTickerProviderStateMixin {
  late int gridSize;
  late List<List<int>> grid;
  late List<List<Key>> tileKeys;
  int score = 0;
  int bestScore = 0;
  String difficulty = 'Medium';
  bool gameOver = false;
  bool hasWon = false;
  bool showStartScreen = true;
  late AnimationController _animationController;

  List<int> easyHighScores = [];
  List<int> mediumHighScores = [];
  List<int> hardHighScores = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    gridSize = 4;
    _loadHighScores();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();

    easyHighScores = (prefs.getStringList('2048_easy_highscores') ?? [])
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    mediumHighScores = (prefs.getStringList('2048_medium_highscores') ?? [])
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    hardHighScores = (prefs.getStringList('2048_hard_highscores') ?? [])
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    setState(() {});
  }

  Future<void> _saveHighScores() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
      '2048_easy_highscores',
      easyHighScores.map((e) => e.toString()).toList(),
    );
    prefs.setStringList(
      '2048_medium_highscores',
      mediumHighScores.map((e) => e.toString()).toList(),
    );
    prefs.setStringList(
      '2048_hard_highscores',
      hardHighScores.map((e) => e.toString()).toList(),
    );
  }

  void _updateHighScores() {
    List<int> currentHighScores;

    switch (difficulty) {
      case 'Easy':
        currentHighScores = easyHighScores;
        break;
      case 'Medium':
        currentHighScores = mediumHighScores;
        break;
      case 'Hard':
        currentHighScores = hardHighScores;
        break;
      default:
        currentHighScores = mediumHighScores;
    }

    currentHighScores.add(score);
    currentHighScores.sort((a, b) => b.compareTo(a));

    if (currentHighScores.length > 3) {
      currentHighScores = currentHighScores.sublist(0, 3);
    }

    switch (difficulty) {
      case 'Easy':
        easyHighScores = currentHighScores;
        break;
      case 'Medium':
        mediumHighScores = currentHighScores;
        break;
      case 'Hard':
        hardHighScores = currentHighScores;
        break;
    }

    _saveHighScores();
  }

  void initializeGame() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    tileKeys = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => UniqueKey()),
    );
    score = 0;
    gameOver = false;
    hasWon = false;
    addRandomTile();
    addRandomTile();
    setState(() {});
  }

  void startGame(String selectedDifficulty) {
    setState(() {
      difficulty = selectedDifficulty;
      switch (difficulty) {
        case 'Easy':
          gridSize = 3;
          break;
        case 'Medium':
          gridSize = 4;
          break;
        case 'Hard':
          gridSize = 5;
          break;
      }
      showStartScreen = false;
      initializeGame();
    });
  }

  void quitGame() {
    setState(() {
      showStartScreen = true;
      gameOver = false;
      hasWon = false;
    });
  }

  void addRandomTile() {
    List<Point<int>> emptyCells = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) {
          emptyCells.add(Point(i, j));
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final random = Random();
      final cell = emptyCells[random.nextInt(emptyCells.length)];
      grid[cell.x][cell.y] = random.nextDouble() < 0.9 ? 2 : 4;
      tileKeys[cell.x][cell.y] = UniqueKey();
    }
  }

  bool canMove() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 0) return true;
      }
    }

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (j < gridSize - 1 && grid[i][j] == grid[i][j + 1]) return true;
        if (i < gridSize - 1 && grid[i][j] == grid[i + 1][j]) return true;
      }
    }

    return false;
  }

  void move(String direction) {
    if (gameOver) return;

    bool moved = false;

    switch (direction) {
      case 'left':
        moved = moveLeft();
        break;
      case 'right':
        moved = moveRight();
        break;
      case 'up':
        moved = moveUp();
        break;
      case 'down':
        moved = moveDown();
        break;
    }

    if (moved) {
      _animationController.forward(from: 0);
      addRandomTile();

      if (!hasWon && hasReached2048()) {
        hasWon = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          showWinDialog();
        });
      }

      if (!canMove()) {
        gameOver = true;
        _updateHighScores();
        Future.delayed(const Duration(milliseconds: 500), () {
          showGameOverDialog();
        });
      }

      setState(() {});
    }
  }

  bool hasReached2048() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == 2048) return true;
      }
    }
    return false;
  }

  bool moveLeft() {
    bool moved = false;
    for (int i = 0; i < gridSize; i++) {
      List<int> row = grid[i].where((cell) => cell != 0).toList();
      List<int> newRow = [];

      for (int j = 0; j < row.length; j++) {
        if (j < row.length - 1 && row[j] == row[j + 1]) {
          newRow.add(row[j] * 2);
          score += row[j] * 2;
          if (score > bestScore) bestScore = score;
          j++;
        } else {
          newRow.add(row[j]);
        }
      }

      while (newRow.length < gridSize) {
        newRow.add(0);
      }

      if (!listEquals(grid[i], newRow)) {
        moved = true;
        grid[i] = newRow;
      }
    }
    return moved;
  }

  bool moveRight() {
    bool moved = false;
    for (int i = 0; i < gridSize; i++) {
      List<int> row = grid[i].where((cell) => cell != 0).toList();
      List<int> newRow = [];

      for (int j = row.length - 1; j >= 0; j--) {
        if (j > 0 && row[j] == row[j - 1]) {
          newRow.insert(0, row[j] * 2);
          score += row[j] * 2;
          if (score > bestScore) bestScore = score;
          j--;
        } else {
          newRow.insert(0, row[j]);
        }
      }

      while (newRow.length < gridSize) {
        newRow.insert(0, 0);
      }

      if (!listEquals(grid[i], newRow)) {
        moved = true;
        grid[i] = newRow;
      }
    }
    return moved;
  }

  bool moveUp() {
    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      List<int> column = [];
      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != 0) column.add(grid[i][j]);
      }

      List<int> newColumn = [];
      for (int i = 0; i < column.length; i++) {
        if (i < column.length - 1 && column[i] == column[i + 1]) {
          newColumn.add(column[i] * 2);
          score += column[i] * 2;
          if (score > bestScore) bestScore = score;
          i++;
        } else {
          newColumn.add(column[i]);
        }
      }

      while (newColumn.length < gridSize) {
        newColumn.add(0);
      }

      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != newColumn[i]) {
          moved = true;
          grid[i][j] = newColumn[i];
        }
      }
    }
    return moved;
  }

  bool moveDown() {
    bool moved = false;
    for (int j = 0; j < gridSize; j++) {
      List<int> column = [];
      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != 0) column.add(grid[i][j]);
      }

      List<int> newColumn = [];
      for (int i = column.length - 1; i >= 0; i--) {
        if (i > 0 && column[i] == column[i - 1]) {
          newColumn.insert(0, column[i] * 2);
          score += column[i] * 2;
          if (score > bestScore) bestScore = score;
          i--;
        } else {
          newColumn.insert(0, column[i]);
        }
      }

      while (newColumn.length < gridSize) {
        newColumn.insert(0, 0);
      }

      for (int i = 0; i < gridSize; i++) {
        if (grid[i][j] != newColumn[i]) {
          moved = true;
          grid[i][j] = newColumn[i];
        }
      }
    }
    return moved;
  }

  bool listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Color getTileColor(int value) {
    switch (value) {
      case 0:
        return const Color(0xFFE6E6FA).withOpacity(0.3);
      case 2:
        return const Color(0xFFFFE5EC);
      case 4:
        return const Color(0xFFFFD4E5);
      case 8:
        return const Color(0xFFFFB3D9);
      case 16:
        return const Color(0xFFFF99CC);
      case 32:
        return const Color(0xFFFF80BF);
      case 64:
        return const Color(0xFFFF66B2);
      case 128:
        return const Color(0xFFD4A7D6);
      case 256:
        return const Color(0xFFB4A7D6);
      case 512:
        return const Color(0xFF9B8FD6);
      case 1024:
        return const Color(0xFF8B7FD6);
      case 2048:
        return const Color(0xFF7B6FD6);
      default:
        return const Color(0xFF6B5FD6);
    }
  }

  Color getTextColor(int value) {
    return value <= 4 ? const Color(0xFF666666) : Colors.white;
  }

  void showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF5F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You Win!',
              style: TextStyle(
                color: Color(0xFFFF69B4),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉 You reached 2048! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF69B4),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFB4A7D6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              initializeGame();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFFB3D9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Play Again',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF5F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9F40).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sentiment_dissatisfied,
                color: Color(0xFFFF9F40),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Game Over',
              style: TextStyle(
                color: Color(0xFFFF9F40),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No more moves available!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9F40).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9F40),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              quitGame();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: const Color(0xFF666666),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Quit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              initializeGame();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFFB3D9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Play Again',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE5EC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '2048 Puzzle',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF69B4),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFE5EC),
              const Color(0xFFFFF5F7),
              const Color(0xFFE6E6FA).withOpacity(0.3),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game Logo
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFFB3D9).withOpacity(0.8),
                        const Color(0xFFB4A7D6).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB3D9).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '2048',
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Join the tiles, reach 2048!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Difficulty Cards
                const Text(
                  'Choose Your Level',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 20),

                _LevelCard(
                  level: 'Easy',
                  gridSize: '3×3 Grid',
                  color: const Color(0xFFB3E5A7),
                  icon: Icons.child_care,
                  scores: easyHighScores,
                  onTap: () => startGame('Easy'),
                ),
                const SizedBox(height: 12),
                _LevelCard(
                  level: 'Medium',
                  gridSize: '4×4 Grid',
                  color: const Color(0xFFFFD4A3),
                  icon: Icons.person,
                  scores: mediumHighScores,
                  onTap: () => startGame('Medium'),
                ),
                const SizedBox(height: 12),
                _LevelCard(
                  level: 'Hard',
                  gridSize: '5×5 Grid',
                  color: const Color(0xFFFFB3B3),
                  icon: Icons.local_fire_department,
                  scores: hardHighScores,
                  onTap: () => startGame('Hard'),
                ),

                const SizedBox(height: 40),

                // High Scores Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: Color(0xFFFFD700),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Top Scores',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF69B4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _ScoreSection(
                        difficulty: 'Easy',
                        scores: easyHighScores,
                        color: const Color(0xFFB3E5A7),
                      ),
                      const SizedBox(height: 16),
                      _ScoreSection(
                        difficulty: 'Medium',
                        scores: mediumHighScores,
                        color: const Color(0xFFFFD4A3),
                      ),
                      const SizedBox(height: 16),
                      _ScoreSection(
                        difficulty: 'Hard',
                        scores: hardHighScores,
                        color: const Color(0xFFFFB3B3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6FA).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFB4A7D6).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFFB4A7D6),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'How to Play',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• Swipe to move tiles in any direction\n'
                        '• When two tiles with the same number touch, they merge\n'
                        '• Create a tile with 2048 to win\n'
                        '• Keep playing to beat your high score!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE5EC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Color(0xFFFF69B4)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFFFFF5F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'Quit Game?',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text(
                  'Your current progress will be lost.',
                  style: TextStyle(color: Color(0xFF666666)),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      quitGame();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB3D9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Quit'),
                  ),
                ],
              ),
            );
          },
        ),
        title: Text(
          '2048 - $difficulty',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF69B4),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFFF69B4)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFFFFF5F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    'Reset Game?',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Start a new game? Your current progress will be lost.',
                    style: TextStyle(color: Color(0xFF666666)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        initializeGame();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFB4A7D6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            move('right');
          } else if (details.primaryVelocity! < 0) {
            move('left');
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            move('down');
          } else if (details.primaryVelocity! < 0) {
            move('up');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFE5EC),
                const Color(0xFFFFF5F7),
                const Color(0xFFE6E6FA).withOpacity(0.3),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Score Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ScoreCard(label: 'SCORE', value: score),
                      const SizedBox(width: 12),
                      _ScoreCard(label: 'BEST', value: bestScore),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Game Grid
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB3E5FC).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemCount: gridSize * gridSize,
                        itemBuilder: (context, index) {
                          final row = index ~/ gridSize;
                          final col = index % gridSize;
                          final value = grid[row][col];

                          return AnimatedContainer(
                            key: tileKeys[row][col],
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: getTileColor(value),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: value != 0
                                  ? [
                                      BoxShadow(
                                        color: getTileColor(
                                          value,
                                        ).withOpacity(0.5),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: value != 0
                                  ? Text(
                                      value.toString(),
                                      style: TextStyle(
                                        fontSize: gridSize == 3
                                            ? 36
                                            : gridSize == 4
                                            ? 28
                                            : 22,
                                        fontWeight: FontWeight.bold,
                                        color: getTextColor(value),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Control Buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _DirectionButton(
                          icon: Icons.keyboard_arrow_up,
                          onPressed: () => move('up'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _DirectionButton(
                              icon: Icons.keyboard_arrow_left,
                              onPressed: () => move('left'),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6E6FA).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFFB4A7D6,
                                  ).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.swipe,
                                  color: Color(0xFFB4A7D6),
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _DirectionButton(
                              icon: Icons.keyboard_arrow_right,
                              onPressed: () => move('right'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _DirectionButton(
                          icon: Icons.keyboard_arrow_down,
                          onPressed: () => move('down'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Swipe or use arrow buttons',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return showStartScreen ? _buildStartScreen() : _buildGameScreen();
  }
}

class _LevelCard extends StatelessWidget {
  final String level;
  final String gridSize;
  final Color color;
  final IconData icon;
  final List<int> scores;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.gridSize,
    required this.color,
    required this.icon,
    required this.scores,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      gridSize,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (scores.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '🏆 Best: ${scores[0]}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreSection extends StatelessWidget {
  final String difficulty;
  final List<int> scores;
  final Color color;

  const _ScoreSection({
    required this.difficulty,
    required this.scores,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                difficulty,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          scores.isEmpty
              ? const Text(
                  'No scores yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                )
              : Column(
                  children: scores.asMap().entries.map((entry) {
                    final index = entry.key;
                    final score = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$score points',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int value;

  const _ScoreCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFB3D9).withOpacity(0.8),
            const Color(0xFFFFB3D9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB3D9).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _DirectionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFB4A7D6).withOpacity(0.9),
                const Color(0xFFB4A7D6),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB4A7D6).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 32, color: Colors.white),
        ),
      ),
    );
  }
}
