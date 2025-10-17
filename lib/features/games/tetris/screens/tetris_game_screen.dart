// lib/features/games/tetris/screens/tetris_game_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/tetromino.dart';
import '../providers/tetris_provider.dart';
import '../widgets/game_board.dart';
import '../widgets/next_pieces_display.dart';
import '../widgets/game_controls.dart';

class TetrisGameScreen extends StatefulWidget {
  final Difficulty difficulty;

  const TetrisGameScreen({Key? key, required this.difficulty}) : super(key: key);

  @override
  State<TetrisGameScreen> createState() => _TetrisGameScreenState();
}

class _TetrisGameScreenState extends State<TetrisGameScreen> {
  late TetrisProvider _provider;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _provider = TetrisProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.startGame(widget.difficulty);
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _provider.moveLeft();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _provider.moveRight();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _provider.moveDown();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _provider.rotate();
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        _provider.hardDrop();
      } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
        if (_provider.state.status == GameStatus.playing) {
          _provider.pauseGame();
        } else if (_provider.state.status == GameStatus.paused) {
          _provider.resumeGame();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: Scaffold(
          backgroundColor: const Color(0xFF0A0E27),
          body: SafeArea(
            child: Consumer<TetrisProvider>(
              builder: (context, provider, child) {
                return Stack(
                  children: [
                    // Main game content
                    Column(
                      children: [
                        _buildTopBar(provider),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 800;
                              
                              if (isWide) {
                                return _buildWideLayout(provider);
                              } else {
                                return _buildNarrowLayout(provider);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    // Overlays - positioned to cover the entire screen
                    if (provider.state.status == GameStatus.paused)
                      Positioned.fill(
                        child: _buildPauseOverlay(),
                      ),
                    if (provider.state.status == GameStatus.gameOver)
                      Positioned.fill(
                        child: _buildGameOverOverlay(provider),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(TetrisProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SCORE',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              Text(
                provider.state.score.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'TOP',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(TetrisProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 16),
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GameBoard(),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildNarrowLayout(TetrisProvider provider) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 100,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game board centered
            Container(
              padding: const EdgeInsets.all(16),
              child: GameBoard(),
            ),
            
            // Game info below the board
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            
            // Controls at the bottom
            Container(
              padding: const EdgeInsets.all(16),
              child: GameControls(provider: provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F3A),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.pause_circle_outline,
                color: Colors.white,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'PAUSED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Press P to resume',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _provider.resumeGame(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F0F0),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: const Text(
                  'RESUME',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay(TetrisProvider provider) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F3A),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Final Score: ${provider.state.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Lines: ${provider.state.lines}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      provider.startGame(widget.difficulty);
                      _focusNode.requestFocus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00F0F0),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'EXIT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}