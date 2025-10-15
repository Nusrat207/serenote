// features/games/wordle/wordle_screen.dart

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; // ✅ for word validation
import 'dart:math';

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key}) : super(key: key);

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  late String _targetWord;
  int _currentRow = 0;
  int _currentCol = 0;

  final List<List<String>> _guesses = List.generate(6, (_) => List.filled(5, ''));
  final List<List<LetterState>> _states = List.generate(6, (_) => List.filled(5, LetterState.empty));
  final Map<String, LetterState> _keyboardStates = {};

  bool _gameOver = false;
  bool _won = false;

  // ✅ English words list (converted to uppercase)
  late final Set<String> _wordList = all.toSet().map((w) => w.toUpperCase()).toSet();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _targetWord = _wordList
          .where((w) => w.length == 5)
          .elementAt(Random().nextInt(_wordList.where((w) => w.length == 5).length));
      _currentRow = 0;
      _currentCol = 0;
      _guesses.forEach((row) => row.fillRange(0, 5, ''));
      _states.forEach((row) => row.fillRange(0, 5, LetterState.empty));
      _keyboardStates.clear();
      _gameOver = false;
      _won = false;
    });
  }

  void _onKeyTap(String letter) {
    if (_gameOver) return;

    if (letter == 'ENTER') {
      _submitGuess();
    } else if (letter == '⌫') {
      _deleteLetter();
    } else if (_currentCol < 5) {
      setState(() {
        _guesses[_currentRow][_currentCol] = letter;
        _currentCol++;
      });
    }
  }

  void _deleteLetter() {
    if (_currentCol > 0) {
      setState(() {
        _currentCol--;
        _guesses[_currentRow][_currentCol] = '';
      });
    }
  }

  void _submitGuess() {
    if (_currentCol != 5) {
      _showMessage('Not enough letters');
      return;
    }

    String guess = _guesses[_currentRow].join('');

    if (!_wordList.contains(guess)) {
      _showMessage('Not in word list');
      return;
    }

    Map<String, int> targetLetterCount = {};
    for (var char in _targetWord.split('')) {
      targetLetterCount[char] = (targetLetterCount[char] ?? 0) + 1;
    }

    for (int i = 0; i < 5; i++) {
      if (_guesses[_currentRow][i] == _targetWord[i]) {
        _states[_currentRow][i] = LetterState.correct;
        targetLetterCount[_guesses[_currentRow][i]] = targetLetterCount[_guesses[_currentRow][i]]! - 1;
      }
    }

    for (int i = 0; i < 5; i++) {
      if (_states[_currentRow][i] == LetterState.empty) {
        String letter = _guesses[_currentRow][i];
        if (targetLetterCount.containsKey(letter) && targetLetterCount[letter]! > 0) {
          _states[_currentRow][i] = LetterState.present;
          targetLetterCount[letter] = targetLetterCount[letter]! - 1;
        } else {
          _states[_currentRow][i] = LetterState.absent;
        }
      }
    }

    for (int i = 0; i < 5; i++) {
      String letter = _guesses[_currentRow][i];
      LetterState currentState = _keyboardStates[letter] ?? LetterState.empty;
      LetterState newState = _states[_currentRow][i];

      if (newState == LetterState.correct ||
          (newState == LetterState.present && currentState != LetterState.correct)) {
        _keyboardStates[letter] = newState;
      } else if (newState == LetterState.absent && currentState == LetterState.empty) {
        _keyboardStates[letter] = newState;
      }
    }

    setState(() {
      if (guess == _targetWord) {
        _gameOver = true;
        _won = true;
        _showWinDialog();
      } else if (_currentRow == 5) {
        _gameOver = true;
        _showLoseDialog();
      } else {
        _currentRow++;
        _currentCol = 0;
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showWinDialog() {
    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: const Text('🎉 Congratulations!', style: TextStyle(color: Colors.white)),
          content: Text(
            'You guessed the word in ${_currentRow + 1} ${_currentRow + 1 == 1 ? 'try' : 'tries'}!',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startNewGame();
              },
              child: const Text('Play Again', style: TextStyle(color: Color(0xFF64B5F6))),
            ),
          ],
        ),
      );
    });
  }

  void _showLoseDialog() {
    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: const Text('Game Over', style: TextStyle(color: Colors.white)),
          content: Text(
            'The word was: $_targetWord',
            style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startNewGame();
              },
              child: const Text('Play Again', style: TextStyle(color: Color(0xFF64B5F6))),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF), // 💜 Lavender background
   appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.black87),
    onPressed: () => Navigator.pop(context),
  ),
  title: const Text(
    'Word Puzzle',
    style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
  ),
  centerTitle: true,
  actions: [
    IconButton(
      icon: const Icon(Icons.help_outline, color: Colors.black87), // ❓ How to play
      tooltip: 'How to Play',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            title: const Text('How to Play', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  '• Guess the 5-letter word in 6 tries.',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 6),
                Text(
                  '• Green: Correct letter and position.',
                  style: TextStyle(color: Color(0xFF538D4E)),
                ),
                Text(
                  '• Yellow: Correct letter, wrong position.',
                  style: TextStyle(color: Color(0xFFB59F3B)),
                ),
                Text(
                  '• Grey: Letter not in word.',
                  style: TextStyle(color: Color(0xFF3A3A3C)),
                ),
                SizedBox(height: 6),
                Text(
                  '• Use the keyboard below to type your guesses.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(color: Color(0xFF64B5F6))),
              ),
            ],
          ),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.refresh, color: Colors.black87),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            title: const Text('New Game?', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Start a new game with a different word?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startNewGame();
                },
                child: const Text('New Game', style: TextStyle(color: Color(0xFF64B5F6))),
              ),
            ],
          ),
        );
      },
    ),
  ],
),

body: SafeArea(
  child: SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      children: [
        const SizedBox(height: 20),

        // Game Board
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              6,
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (col) => _buildTile(row, col)),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Keyboard
        _buildKeyboard(),
      ],
    ),
  ),
),

    );
  }

  Widget _buildTile(int row, int col) {
    String letter = _guesses[row][col];
    LetterState state = _states[row][col];

    Color backgroundColor;
    switch (state) {
      case LetterState.correct:
        backgroundColor = const Color(0xFF538D4E);
        break;
      case LetterState.present:
        backgroundColor = const Color(0xFFB59F3B);
        break;
      case LetterState.absent:
        backgroundColor = const Color(0xFF3A3A3C);
        break;
      case LetterState.empty:
        backgroundColor = letter.isEmpty ? Colors.transparent : const Color(0xFF3A3A3C);
        break;
    }

    return Container(
      width: 62,
      height: 62,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.white54, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

Widget _buildKeyboard() {
  final List<List<String>> keyboardRows = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '⌫'],
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildKeyboardRow(keyboardRows[0]),
        const SizedBox(height: 6),
        _buildKeyboardRow(keyboardRows[1], sidePadding: 10),
        const SizedBox(height: 6),
        _buildKeyboardRow(keyboardRows[2], sidePadding: 20),
      ],
    ),
  );
}

Widget _buildKeyboardRow(List<String> row, {double sidePadding = 0}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: sidePadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((key) {
        bool isWide = key == 'ENTER';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: GestureDetector(
            onTap: () => _onKeyTap(key),
            child: Container(
              width: isWide ? 55 : 28,
              height: 45,
              decoration: BoxDecoration(
                color: _getKeyColor(key),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  key,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isWide ? 13 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

Color _getKeyColor(String letter) {
  LetterState state = _keyboardStates[letter] ?? LetterState.empty;

  switch (state) {
    case LetterState.correct:
      return const Color(0xFF538D4E);
    case LetterState.present:
      return const Color(0xFFB59F3B);
    case LetterState.absent:
      return const Color(0xFF3A3A3C);
    case LetterState.empty:
    default:
      return const Color(0xFF818384);
  }
}


  Widget _buildKey(String letter) {
    LetterState state = _keyboardStates[letter] ?? LetterState.empty;

    Color backgroundColor;
    switch (state) {
      case LetterState.correct:
        backgroundColor = const Color(0xFF538D4E);
        break;
      case LetterState.present:
        backgroundColor = const Color(0xFFB59F3B);
        break;
      case LetterState.absent:
        backgroundColor = const Color(0xFF3A3A3C);
        break;
      case LetterState.empty:
        backgroundColor = const Color(0xFF818384);
        break;
    }

    bool isWide = letter == 'ENTER' || letter == '⌫';

    return GestureDetector(
      onTap: () => _onKeyTap(letter),
      child: Container(
        width: isWide ? 70 : 40,
        height: 55,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: Colors.white,
              fontSize: isWide ? 13 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

enum LetterState { empty, absent, present, correct }
