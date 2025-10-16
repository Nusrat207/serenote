// lib/features/games/snake/snake_game_screen.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Difficulty Levels
enum Difficulty {
  easy(speed: 400, label: 'Easy', color: Colors.green),
  medium(speed: 250, label: 'Medium', color: Colors.orange),
  hard(speed: 150, label: 'Hard', color: Colors.red),
  expert(speed: 100, label: 'Expert', color: Colors.purple);

  final int speed;
  final String label;
  final Color color;

  const Difficulty({
    required this.speed,
    required this.label,
    required this.color,
  });
}

// Score History Manager (In-Memory Storage)
class ScoreHistory {
  static final List<GameScore> _scores = [];

  static void addScore(GameScore score) {
    _scores.add(score);
    if (_scores.length > 3) {
      _scores.removeAt(0);
    }
  }

  static List<GameScore> getScores() => List.unmodifiable(_scores);

  static void clear() => _scores.clear();
}

class GameScore {
  final int score;
  final Difficulty difficulty;
  final DateTime timestamp;

  GameScore({
    required this.score,
    required this.difficulty,
    required this.timestamp,
  });
}

// Main Snake Game Screen (Entry Point)
class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  Difficulty selectedDifficulty = Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    final scores = ScoreHistory.getScores();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Snake Game',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Swipe to control the snake',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                // Difficulty Selection Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Difficulty',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: Difficulty.values.map((difficulty) {
                            final isSelected = selectedDifficulty == difficulty;
                            return ChoiceChip(
                              label: Text(difficulty.label),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedDifficulty = difficulty;
                                });
                              },
                              selectedColor: difficulty.color.withOpacity(0.2),
                              checkmarkColor: difficulty.color,
                              side: BorderSide(
                                color: isSelected
                                    ? difficulty.color
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Start Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              GamePage(difficulty: selectedDifficulty),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Game'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                // Score History
                if (scores.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Scores',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() {
                                    ScoreHistory.clear();
                                  });
                                },
                                tooltip: 'Clear history',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...scores.reversed.map((gameScore) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: gameScore.difficulty.color.withOpacity(
                                0.1,
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: gameScore.difficulty.color,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    gameScore.difficulty.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Score: ${gameScore.score}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Text(
                                  _formatTime(gameScore.timestamp),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

// Game Play Screen
class GamePage extends StatefulWidget {
  final Difficulty difficulty;

  const GamePage({super.key, required this.difficulty});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int gridSize = 15;

  int score = 0;
  List<Point<int>> snake = [];
  Point<int> food = const Point(7, 7);
  String direction = 'right';
  bool isPlaying = false;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void _initGame() {
    snake = [const Point(7, 7), const Point(7, 6), const Point(7, 5)];
    direction = 'right';
    score = 0;
    isPlaying = false;
    _generateFood();
  }

  void _generateFood() {
    final random = Random();
    Point<int> newFood;
    do {
      newFood = Point(random.nextInt(gridSize), random.nextInt(gridSize));
    } while (snake.contains(newFood));
    food = newFood;
  }

  void _startGame() {
    if (isPlaying) return;

    isPlaying = true;
    gameTimer?.cancel();
    gameTimer = Timer.periodic(
      Duration(milliseconds: widget.difficulty.speed),
      (timer) {
        if (mounted) {
          _updateGame();
        }
      },
    );
    setState(() {});
  }

  void _pauseGame() {
    isPlaying = false;
    gameTimer?.cancel();
    setState(() {});
  }

  void _updateGame() {
    if (!isPlaying || !mounted) return;

    setState(() {
      Point<int> head = snake.last;
      Point<int> newHead;

      switch (direction) {
        case 'up':
          newHead = Point(head.x, head.y - 1);
          break;
        case 'down':
          newHead = Point(head.x, head.y + 1);
          break;
        case 'left':
          newHead = Point(head.x - 1, head.y);
          break;
        case 'right':
          newHead = Point(head.x + 1, head.y);
          break;
        default:
          newHead = head;
      }

      if (newHead.x < 0 ||
          newHead.x >= gridSize ||
          newHead.y < 0 ||
          newHead.y >= gridSize) {
        _gameOver();
        return;
      }

      if (snake.contains(newHead)) {
        _gameOver();
        return;
      }

      snake.add(newHead);

      if (newHead == food) {
        score += 10;
        _generateFood();
      } else {
        snake.removeAt(0);
      }
    });
  }

  void _gameOver() {
    isPlaying = false;
    gameTimer?.cancel();

    if (!mounted) return;

    ScoreHistory.addScore(
      GameScore(
        score: score,
        difficulty: widget.difficulty,
        timestamp: DateTime.now(),
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                GameOver(score: score, difficulty: widget.difficulty),
          ),
        );
      }
    });
  }

  void _changeDirection(String newDirection) {
    if (!isPlaying) return;

    if ((direction == 'up' && newDirection == 'down') ||
        (direction == 'down' && newDirection == 'up') ||
        (direction == 'left' && newDirection == 'right') ||
        (direction == 'right' && newDirection == 'left')) {
      return;
    }

    setState(() {
      direction = newDirection;
    });
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quit Game'),
        content: const Text(
          'Are you sure you want to quit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Snake Game'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.difficulty.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.difficulty.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _showQuitDialog,
            tooltip: 'Quit Game',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Score Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars),
                  const SizedBox(width: 8),
                  Text(
                    'Score: $score',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Game Grid
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: _buildGameGrid(),
                ),
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Play/Pause Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isPlaying ? _pauseGame : _startGame,
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(isPlaying ? 'Pause' : 'Start Game'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Direction Controls
                  Column(
                    children: [
                      _DirectionButton(
                        icon: Icons.arrow_upward,
                        onPressed: () => _changeDirection('up'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _DirectionButton(
                            icon: Icons.arrow_back,
                            onPressed: () => _changeDirection('left'),
                          ),
                          const SizedBox(width: 80),
                          _DirectionButton(
                            icon: Icons.arrow_forward,
                            onPressed: () => _changeDirection('right'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _DirectionButton(
                        icon: Icons.arrow_downward,
                        onPressed: () => _changeDirection('down'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameGrid() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          _changeDirection('down');
        } else if (details.delta.dy < 0) {
          _changeDirection('up');
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          _changeDirection('right');
        } else if (details.delta.dx < 0) {
          _changeDirection('left');
        }
      },
      child: Container(
        color: Colors.grey[900],
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            final x = index % gridSize;
            final y = index ~/ gridSize;
            final point = Point(x, y);

            if (snake.isNotEmpty && snake.last == point) {
              // Snake head
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            } else if (snake.contains(point)) {
              // Snake body
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            } else if (food == point) {
              // Food
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              );
            }

            // Empty cell
            return Container(
              margin: const EdgeInsets.all(1),
              color: Colors.grey[800],
            );
          },
        ),
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
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon, size: 28),
    );
  }
}

// Game Over Screen
class GameOver extends StatelessWidget {
  final int score;
  final Difficulty difficulty;

  const GameOver({super.key, required this.score, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),

                Text(
                  'Game Over',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: difficulty.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    difficulty.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Your Score',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$score',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              GamePage(difficulty: difficulty),
                        ),
                      );
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('Play Again'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Menu'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
