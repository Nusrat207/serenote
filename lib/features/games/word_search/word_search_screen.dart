// lib/features/games/presentation/screens/word_search_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({super.key});

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  bool showMenu = true;
  String selectedDifficulty = '';

  void startGame(String difficulty) {
    setState(() {
      selectedDifficulty = difficulty;
      showMenu = false;
    });
  }

  void backToMenu() {
    setState(() {
      showMenu = true;
      selectedDifficulty = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showMenu) {
      return MenuScreen(onStartGame: startGame);
    } else {
      return GameScreen(
        difficulty: selectedDifficulty,
        onBackToMenu: backToMenu,
      );
    }
  }
}

class MenuScreen extends StatelessWidget {
  final Function(String) onStartGame;

  const MenuScreen({super.key, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFB39DDB), // Light purple
              const Color(0xFFF48FB1), // Pink
              const Color(0xFFB3E5FC), // Powder blue
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search, size: 100, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      'Wordzee',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Find all the hidden words!',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      'Select Difficulty',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildDifficultyButton(
                      context,
                      'Easy',
                      '6x6 Grid • 4 Words',
                      const Color(0xFF81C784), // Soft green
                      () => onStartGame('easy'),
                    ),
                    const SizedBox(height: 16),
                    _buildDifficultyButton(
                      context,
                      'Medium',
                      '8x8 Grid • 6 Words',
                      const Color(0xFFBA68C8), // Purple
                      () => onStartGame('medium'),
                    ),
                    const SizedBox(height: 16),
                    _buildDifficultyButton(
                      context,
                      'Hard',
                      '10x10 Grid • 8 Words',
                      const Color(0xFFE57373), // Soft red
                      () => onStartGame('hard'),
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

  Widget _buildDifficultyButton(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String difficulty;
  final VoidCallback onBackToMenu;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.onBackToMenu,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int gridSize = 10;
  List<String> wordList = [];
  int wordsToSelect = 4;

  // Enhanced word pools organized by length
  static const Map<String, List<String>> wordPools = {
    'easy': [
      // 4-5 letter words
      'HOPE', 'LOVE', 'JOY', 'CALM', 'KIND', 'WISH', 'SOUL', 'EASY', 'GOOD',
      'FAIR', 'TRUE', 'BOLD', 'WARM', 'NEAT', 'FINE', 'PURE', 'DEAR', 'RARE',
      'SAFE', 'FREE', 'HAPPY', 'PEACE', 'SMILE', 'DREAM', 'LIGHT', 'HEART',
      'BRAVE', 'SWEET', 'CHARM', 'BLISS', 'GRACE', 'TRUST', 'FAITH', 'CHEER',
    ],
    'medium': [
      // 5-7 letter words
      'HAPPY', 'PEACE', 'SMILE', 'DREAM', 'LIGHT', 'HEART', 'BRAVE', 'SWEET',
      'CHARM', 'BLISS', 'GRACE', 'TRUST', 'FAITH', 'CHEER', 'BRIGHT', 'GENTLE',
      'SERENE', 'QUIET', 'STILL', 'CALMER', 'KINDER', 'WARMER', 'BETTER',
      'PUREST', 'SAFEST', 'FREEST', 'LOVING', 'CARING', 'SHARING', 'GIVING',
      'HELPING', 'GROWING', 'LEARNING', 'TEACHING', 'GUIDING', 'HEALING',
    ],
    'hard': [
      // 6-10 letter words
      'SERENITY', 'HARMONY', 'PATIENCE', 'KINDNESS', 'WISDOM', 'COURAGE',
      'STRENGTH', 'BEAUTY', 'JUSTICE', 'FREEDOM', 'HAPPINESS', 'PEACEFUL',
      'GRATEFUL', 'MINDFUL', 'HEALING', 'GROWING', 'LEARNING', 'TEACHING',
      'GUIDING', 'INSPIRE', 'CREATIVE', 'POSITIVE', 'BRIGHTNESS', 'CHEERFUL',
      'DAZZLING', 'GLOWING', 'RADIANT', 'VIBRANT', 'WONDROUS', 'MAGICAL',
      'SPIRITED', 'ENERGETIC', 'POWERFUL', 'FOCUSED', 'BALANCED', 'COMPLETE',
    ],
  };

  List<List<String>> grid = [];
  Set<String> foundWords = {};
  List<Point<int>> selectedCells = [];
  String currentWord = '';
  int score = 0;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    setupDifficulty();
    selectRandomWords();
    generateGrid();
  }

  void setupDifficulty() {
    switch (widget.difficulty) {
      case 'easy':
        gridSize = 8;
        wordsToSelect = 4;
        break;
      case 'medium':
        gridSize = 10;
        wordsToSelect = 6;
        break;
      case 'hard':
        gridSize = 12;
        wordsToSelect = 8;
        break;
      default:
        gridSize = 10;
        wordsToSelect = 6;
    }
  }

  void selectRandomWords() {
    final availableWords = List<String>.from(
      wordPools[widget.difficulty] ?? [],
    );
    final selectedWords = <String>{};

    // For hard difficulty, ensure we have mostly long words with 1-2 short ones
    if (widget.difficulty == 'hard') {
      // Select 6-7 long words (6+ letters)
      final longWords = availableWords
          .where((word) => word.length >= 6)
          .toList();
      longWords.shuffle(random);
      selectedWords.addAll(longWords.take(min(7, wordsToSelect - 2)));

      // Select 1-2 short words (4-5 letters) from medium pool
      if (selectedWords.length < wordsToSelect) {
        final shortWords = wordPools['medium']!
            .where((word) => word.length <= 5)
            .toList();
        shortWords.shuffle(random);
        final needed = wordsToSelect - selectedWords.length;
        selectedWords.addAll(shortWords.take(min(2, needed)));
      }
    } else {
      // For easy and medium, just select randomly from the appropriate pool
      availableWords.shuffle(random);
      selectedWords.addAll(availableWords.take(wordsToSelect));
    }

    // If we still don't have enough words, fill from any available
    if (selectedWords.length < wordsToSelect) {
      final remainingNeeded = wordsToSelect - selectedWords.length;
      final allWords = [
        ...wordPools['easy']!,
        ...wordPools['medium']!,
        ...wordPools['hard']!,
      ];
      allWords.shuffle(random);

      for (final word in allWords) {
        if (!selectedWords.contains(word)) {
          selectedWords.add(word);
          if (selectedWords.length >= wordsToSelect) break;
        }
      }
    }

    wordList = selectedWords.toList();
  }

  void generateGrid() {
    grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));

    // Sort words by length (longest first) for better placement
    wordList.sort((a, b) => b.length.compareTo(a.length));

    // Place words in grid
    for (final word in wordList) {
      bool placed = false;
      int attempts = 0;

      while (!placed && attempts < 200) {
        // Increased attempts for better placement
        attempts++;

        // Try different directions: horizontal, vertical, and diagonal
        final direction = random.nextInt(
          3,
        ); // 0: horizontal, 1: vertical, 2: diagonal
        final row = random.nextInt(gridSize);
        final col = random.nextInt(gridSize);

        bool canPlace = true;
        List<Point<int>> potentialCells = [];

        switch (direction) {
          case 0: // Horizontal
            if (col + word.length > gridSize) continue;
            for (int i = 0; i < word.length; i++) {
              final currentRow = row;
              final currentCol = col + i;
              if (grid[currentRow][currentCol].isNotEmpty &&
                  grid[currentRow][currentCol] != word[i]) {
                canPlace = false;
                break;
              }
              potentialCells.add(Point(currentRow, currentCol));
            }
            break;
          case 1: // Vertical
            if (row + word.length > gridSize) continue;
            for (int i = 0; i < word.length; i++) {
              final currentRow = row + i;
              final currentCol = col;
              if (grid[currentRow][currentCol].isNotEmpty &&
                  grid[currentRow][currentCol] != word[i]) {
                canPlace = false;
                break;
              }
              potentialCells.add(Point(currentRow, currentCol));
            }
            break;
          case 2: // Diagonal (down-right)
            if (row + word.length > gridSize || col + word.length > gridSize)
              continue;
            for (int i = 0; i < word.length; i++) {
              final currentRow = row + i;
              final currentCol = col + i;
              if (grid[currentRow][currentCol].isNotEmpty &&
                  grid[currentRow][currentCol] != word[i]) {
                canPlace = false;
                break;
              }
              potentialCells.add(Point(currentRow, currentCol));
            }
            break;
        }

        if (canPlace && potentialCells.length == word.length) {
          for (int i = 0; i < word.length; i++) {
            final point = potentialCells[i];
            grid[point.x][point.y] = word[i];
          }
          placed = true;
        }
      }

      // If word couldn't be placed after many attempts, regenerate the grid
      if (!placed) {
        if (mounted) {
          setState(() {
            generateGrid(); // Restart grid generation
          });
        }
        return;
      }
    }

    // Fill empty cells with random letters
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j].isEmpty) {
          grid[i][j] = String.fromCharCode(65 + random.nextInt(26));
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onCellTap(int row, int col) {
    final point = Point(row, col);

    if (selectedCells.isEmpty) {
      selectedCells.add(point);
      currentWord = grid[row][col];
    } else {
      final lastPoint = selectedCells.last;
      // Check if the new cell is adjacent to the last selected cell
      final rowDiff = (row - lastPoint.x).abs();
      final colDiff = (col - lastPoint.y).abs();

      if (rowDiff <= 1 && colDiff <= 1 && !selectedCells.contains(point)) {
        selectedCells.add(point);
        currentWord += grid[row][col];

        // Check if word is complete
        if (wordList.contains(currentWord) &&
            !foundWords.contains(currentWord)) {
          foundWords.add(currentWord);
          score += currentWord.length * 10;

          if (foundWords.length == wordList.length) {
            showWinDialog();
          } else {
            // Clear selection after finding a word
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                setState(() {
                  selectedCells.clear();
                  currentWord = '';
                });
              }
            });
          }
        }
      } else {
        // If not adjacent, start new selection
        selectedCells.clear();
        selectedCells.add(point);
        currentWord = grid[row][col];
      }
    }

    setState(() {});
  }

  void onDragEnd() {
    if (mounted) {
      setState(() {
        selectedCells.clear();
        currentWord = '';
      });
    }
  }

  void showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You found all the words!'),
            const SizedBox(height: 16),
            Text(
              'Final Score: $score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFBA68C8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onBackToMenu();
            },
            child: const Text('Menu'),
          ),
        ],
      ),
    );
  }

  void showQuitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quit Game?'),
        content: const Text(
          'Are you sure you want to quit and return to the main menu?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onBackToMenu();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      foundWords.clear();
      selectedCells.clear();
      currentWord = '';
      score = 0;
      selectRandomWords(); // Select new random words
      generateGrid();
    });
  }

  Color _getThemeColor() {
    switch (widget.difficulty) {
      case 'easy':
        return const Color(0xFFB3E5FC); // Powder blue
      case 'medium':
        return const Color(0xFFBA68C8); // Purple
      case 'hard':
        return const Color(0xFFF48FB1); // Pink
      default:
        return const Color(0xFFBA68C8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Search - ${widget.difficulty.toUpperCase()}'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: showQuitDialog,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetGame,
            tooltip: 'Restart',
          ),
        ],
      ),
      body: Column(
        children: [
          // Score display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeColor.withOpacity(0.1),
                  themeColor.withOpacity(0.05),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                      'Score',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Found',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '${foundWords.length}/${wordList.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF81C784),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Words list
          Container(
            height: widget.difficulty == 'hard' ? 100 : 90,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: wordList.map((word) {
                  final found = foundWords.contains(word);
                  return Chip(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    label: Text(
                      word,
                      style: TextStyle(
                        fontSize: 11,
                        decoration: found
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: found ? Colors.grey : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: found
                        ? const Color(0xFF81C784).withOpacity(0.3)
                        : themeColor.withOpacity(0.2),
                    side: BorderSide(
                      color: found ? const Color(0xFF81C784) : themeColor,
                      width: 1,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Current word display
          Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: currentWord.isNotEmpty
                  ? Text(
                      'Current: $currentWord',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // Grid
          Expanded(
            child: GestureDetector(
              onPanEnd: (_) => onDragEnd(),
              child: GridView.builder(
                padding: EdgeInsets.all(widget.difficulty == 'hard' ? 8 : 12),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  mainAxisSpacing: widget.difficulty == 'hard' ? 3 : 4,
                  crossAxisSpacing: widget.difficulty == 'hard' ? 3 : 4,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  final row = index ~/ gridSize;
                  final col = index % gridSize;
                  final point = Point(row, col);
                  final isSelected = selectedCells.contains(point);

                  return GestureDetector(
                    onTap: () => onCellTap(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? themeColor.withOpacity(0.5)
                            : themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: themeColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          grid[row][col],
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getFontSize() {
    if (gridSize <= 8) return 20;
    if (gridSize <= 10) return 16;
    return 12;
  }
}
