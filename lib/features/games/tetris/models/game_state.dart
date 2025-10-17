import 'tetromino.dart';

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);

  Position copyWith({int? x, int? y}) {
    return Position(x ?? this.x, y ?? this.y);
  }
}

enum GameStatus { notStarted, playing, paused, gameOver }
enum Difficulty { easy, medium, hard, expert }

class GameState {
  final List<List<int?>> board;
  final Tetromino? currentPiece;
  final Position currentPosition;
  final List<Tetromino> nextPieces;
  final Tetromino? heldPiece;
  final int score;
  final int lines;
  final int level;
  final int combo;
  final GameStatus status;
  final Difficulty difficulty;
  final bool canHold;

  GameState({
    required this.board,
    this.currentPiece,
    required this.currentPosition,
    this.nextPieces = const [],
    this.heldPiece,
    this.score = 0,
    this.lines = 0,
    this.level = 1,
    this.combo = 1,
    this.status = GameStatus.notStarted,
    this.difficulty = Difficulty.medium,
    this.canHold = true,
  });

  GameState copyWith({
    List<List<int?>>? board,
    Tetromino? currentPiece,
    Position? currentPosition,
    List<Tetromino>? nextPieces,
    Tetromino? heldPiece,
    int? score,
    int? lines,
    int? level,
    int? combo,
    GameStatus? status,
    Difficulty? difficulty,
    bool? canHold,
    bool clearHeld = false,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPiece: currentPiece ?? this.currentPiece,
      currentPosition: currentPosition ?? this.currentPosition,
      nextPieces: nextPieces ?? this.nextPieces,
      heldPiece: clearHeld ? null : (heldPiece ?? this.heldPiece),
      score: score ?? this.score,
      lines: lines ?? this.lines,
      level: level ?? this.level,
      combo: combo ?? this.combo,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      canHold: canHold ?? this.canHold,
    );
  }

  int getSpeed() {
    switch (difficulty) {
      case Difficulty.easy:
        return 800 - (level * 30);
      case Difficulty.medium:
        return 600 - (level * 40);
      case Difficulty.hard:
        return 400 - (level * 50);
      case Difficulty.expert:
        return 200 - (level * 30);
    }
  }
}
