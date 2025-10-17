// lib/features/games/tetris/providers/tetris_provider.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/tetromino.dart';

class TetrisProvider extends ChangeNotifier {
  static const int boardWidth = 10;
  static const int boardHeight = 20;

  GameState _state = GameState(
    board: List.generate(boardHeight, (_) => List.filled(boardWidth, null)),
    currentPosition: Position(3, 0),
  );

  Timer? _gameTimer;
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;
  final Random _random = Random();

  GameState get state => _state;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isMusicEnabled => _isMusicEnabled;

  Tetromino _createRandomPiece() {
    final types = TetrominoType.values;
    final type = types[_random.nextInt(types.length)];
    return Tetromino.create(type);
  }

  void startGame(Difficulty difficulty) {
    _state = GameState(
      board: List.generate(boardHeight, (_) => List.filled(boardWidth, null)),
      currentPosition: Position(3, 0),
      difficulty: difficulty,
      status: GameStatus.playing,
      nextPieces: List.generate(3, (_) => _createRandomPiece()),
    );
    _spawnNewPiece();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(Duration(milliseconds: _state.getSpeed()), (_) {
      if (_state.status == GameStatus.playing) {
        moveDown();
      }
    });
  }

  void _spawnNewPiece() {
    if (_state.nextPieces.isEmpty) return;

    final newPiece = _state.nextPieces.first;
    final newNext = [..._state.nextPieces.sublist(1), _createRandomPiece()];
    
    _state = _state.copyWith(
      currentPiece: newPiece,
      currentPosition: Position(3, 0),
      nextPieces: newNext,
      canHold: true,
    );

    if (_checkCollision(_state.currentPiece!, _state.currentPosition)) {
      _gameOver();
    }
  }

  bool _checkCollision(Tetromino piece, Position pos) {
    for (int y = 0; y < piece.shape.length; y++) {
      for (int x = 0; x < piece.shape[y].length; x++) {
        if (piece.shape[y][x] == 1) {
          final newX = pos.x + x;
          final newY = pos.y + y;

          if (newX < 0 || newX >= boardWidth || newY >= boardHeight) {
            return true;
          }

          if (newY >= 0 && _state.board[newY][newX] != null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void moveLeft() {
    if (_state.status != GameStatus.playing || _state.currentPiece == null) return;

    final newPos = _state.currentPosition.copyWith(x: _state.currentPosition.x - 1);
    if (!_checkCollision(_state.currentPiece!, newPos)) {
      _state = _state.copyWith(currentPosition: newPos);
      notifyListeners();
    }
  }

  void moveRight() {
    if (_state.status != GameStatus.playing || _state.currentPiece == null) return;

    final newPos = _state.currentPosition.copyWith(x: _state.currentPosition.x + 1);
    if (!_checkCollision(_state.currentPiece!, newPos)) {
      _state = _state.copyWith(currentPosition: newPos);
      notifyListeners();
    }
  }

  void moveDown() {
    if (_state.status != GameStatus.playing || _state.currentPiece == null) return;

    final newPos = _state.currentPosition.copyWith(y: _state.currentPosition.y + 1);
    if (!_checkCollision(_state.currentPiece!, newPos)) {
      _state = _state.copyWith(currentPosition: newPos);
      notifyListeners();
    } else {
      _lockPiece();
    }
  }

  void hardDrop() {
    if (_state.status != GameStatus.playing || _state.currentPiece == null) return;

    int dropDistance = 0;
    Position newPos = _state.currentPosition;
    
    while (!_checkCollision(_state.currentPiece!, newPos.copyWith(y: newPos.y + 1))) {
      newPos = newPos.copyWith(y: newPos.y + 1);
      dropDistance++;
    }

    _state = _state.copyWith(
      currentPosition: newPos,
      score: _state.score + (dropDistance * 2),
    );
    notifyListeners();
    _lockPiece();
  }

  void rotate() {
    if (_state.status != GameStatus.playing || _state.currentPiece == null) return;

    final rotated = _state.currentPiece!.copyWith(
      shape: _state.currentPiece!.rotate(),
      rotation: (_state.currentPiece!.rotation + 1) % 4,
    );

    if (!_checkCollision(rotated, _state.currentPosition)) {
      _state = _state.copyWith(currentPiece: rotated);
      notifyListeners();
    }
  }

  void hold() {
    if (_state.status != GameStatus.playing || 
        _state.currentPiece == null || 
        !_state.canHold) return;

    if (_state.heldPiece == null) {
      _state = _state.copyWith(
        heldPiece: _state.currentPiece,
        canHold: false,
      );
      _spawnNewPiece();
    } else {
      final temp = _state.currentPiece;
      _state = _state.copyWith(
        currentPiece: _state.heldPiece,
        heldPiece: temp,
        currentPosition: Position(3, 0),
        canHold: false,
      );
    }
    notifyListeners();
  }

  void _lockPiece() {
    if (_state.currentPiece == null) return;

    final newBoard = _state.board.map((row) => [...row]).toList();
    
    for (int y = 0; y < _state.currentPiece!.shape.length; y++) {
      for (int x = 0; x < _state.currentPiece!.shape[y].length; x++) {
        if (_state.currentPiece!.shape[y][x] == 1) {
          final boardY = _state.currentPosition.y + y;
          final boardX = _state.currentPosition.x + x;
          if (boardY >= 0 && boardY < boardHeight && boardX >= 0 && boardX < boardWidth) {
            newBoard[boardY][boardX] = _state.currentPiece!.type.index;
          }
        }
      }
    }

    _state = _state.copyWith(board: newBoard);
    _clearLines();
    _spawnNewPiece();
    notifyListeners();
  }

  void _clearLines() {
    int linesCleared = 0;
    final newBoard = <List<int?>>[];

    for (var row in _state.board) {
      if (row.any((cell) => cell == null)) {
        newBoard.add(row);
      } else {
        linesCleared++;
      }
    }

    while (newBoard.length < boardHeight) {
      newBoard.insert(0, List.filled(boardWidth, null));
    }

    if (linesCleared > 0) {
      final lineScore = [0, 100, 300, 500, 800][linesCleared];
      final newScore = _state.score + (lineScore * _state.level * _state.combo);
      final newLines = _state.lines + linesCleared;
      final newLevel = (newLines ~/ 10) + 1;
      final newCombo = _state.combo + 1;

      _state = _state.copyWith(
        board: newBoard,
        score: newScore,
        lines: newLines,
        level: newLevel,
        combo: newCombo,
      );

      if (newLevel > _state.level) {
        _startTimer();
      }
    } else {
      _state = _state.copyWith(board: newBoard, combo: 1);
    }
  }

  void _gameOver() {
    _gameTimer?.cancel();
    _state = _state.copyWith(status: GameStatus.gameOver);
    notifyListeners();
  }

  void pauseGame() {
    if (_state.status == GameStatus.playing) {
      _gameTimer?.cancel();
      _state = _state.copyWith(status: GameStatus.paused);
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_state.status == GameStatus.paused) {
      _state = _state.copyWith(status: GameStatus.playing);
      _startTimer();
      notifyListeners();
    }
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
  }

  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}