import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class PacmanGameScreen extends StatefulWidget {
  const PacmanGameScreen({Key? key}) : super(key: key);

  @override
  State<PacmanGameScreen> createState() => _PacmanGameScreenState();
}

class _PacmanGameScreenState extends State<PacmanGameScreen>
    with SingleTickerProviderStateMixin {
  static const int rows = 21;
  static const int cols = 19;
  
  double pacmanX = 9.0;
  double pacmanY = 15.0;
  int gridX = 9;
  int gridY = 15;
  
  String direction = 'right';
  String nextDirection = 'right';
  
  int score = 0;
  int lives = 3;
  bool isGameOver = false;
  bool isPaused = false;
  bool powerUpActive = false;
  
  Timer? gameTimer;
  Timer? ghostTimer;
  Timer? powerUpTimer;
  late AnimationController mouthController;
  
  late List<List<int>> maze;
  List<Ghost> ghosts = [];
  
  // Smooth movement
  static const double moveSpeed = 0.15;
  bool isMoving = false;
  
  @override
  void initState() {
    super.initState();
    mouthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..repeat(reverse: true);
    
    initializeMaze();
    initializeGhosts();
    startGame();
  }
  
  void initializeMaze() {
    maze = [
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0],
      [0,2,0,0,1,0,0,0,1,0,1,0,0,0,1,0,0,2,0],
      [0,1,0,0,1,0,0,0,1,0,1,0,0,0,1,0,0,1,0],
      [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
      [0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1,0],
      [0,1,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,1,0],
      [0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,0,0,0],
      [3,3,3,0,1,0,1,1,1,1,1,1,1,0,1,0,3,3,3],
      [0,0,0,0,1,0,1,0,0,4,0,0,1,0,1,0,0,0,0],
      [3,3,3,3,1,1,1,0,4,4,4,0,1,1,1,3,3,3,3],
      [0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0],
      [3,3,3,0,1,0,1,1,1,1,1,1,1,0,1,0,3,3,3],
      [0,0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,0],
      [0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0],
      [0,1,0,0,1,0,0,0,1,0,1,0,0,0,1,0,0,1,0],
      [0,2,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,2,0],
      [0,0,1,0,1,0,1,0,0,0,0,0,1,0,1,0,1,0,0],
      [0,1,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,1,0],
      [0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    ];
  }
  
  void initializeGhosts() {
    ghosts = [
      Ghost(x: 9.0, y: 9.0, gridX: 9, gridY: 9, color: Colors.red, name: 'Blinky'),
      Ghost(x: 8.0, y: 10.0, gridX: 8, gridY: 10, color: Colors.pink, name: 'Pinky'),
      Ghost(x: 9.0, y: 10.0, gridX: 9, gridY: 10, color: Colors.cyan, name: 'Inky'),
      Ghost(x: 10.0, y: 10.0, gridX: 10, gridY: 10, color: Colors.orange, name: 'Clyde'),
    ];
  }
  
  void startGame() {
    // Smooth Pacman movement
    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isPaused && !isGameOver) {
        movePacmanSmooth();
      }
    });
    
    // Ghost movement
    ghostTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (!isPaused && !isGameOver) {
        moveGhosts();
      }
    });
  }
  
  void movePacmanSmooth() {
    // Try to change direction
    if (canMove(nextDirection)) {
      direction = nextDirection;
    }
    
    double targetX = pacmanX;
    double targetY = pacmanY;
    
    switch (direction) {
      case 'up':
        targetY = pacmanY - moveSpeed;
        break;
      case 'down':
        targetY = pacmanY + moveSpeed;
        break;
      case 'left':
        targetX = pacmanX - moveSpeed;
        break;
      case 'right':
        targetX = pacmanX + moveSpeed;
        break;
    }
    
    // Handle tunnel wrap-around
    if (targetX < 0) targetX = cols - 0.5;
    if (targetX >= cols) targetX = 0.5;
    
    // Check if we can move to target
    int nextGridX = targetX.round();
    int nextGridY = targetY.round();
    
    if (isValidMove(nextGridX, nextGridY)) {
      setState(() {
        pacmanX = targetX;
        pacmanY = targetY;
        
        // Update grid position
        int newGridX = pacmanX.round();
        int newGridY = pacmanY.round();
        
        // Check if entered new cell
        if (newGridX != gridX || newGridY != gridY) {
          gridX = newGridX;
          gridY = newGridY;
          
          // Eat pellet
          if (maze[gridY][gridX] == 1) {
            maze[gridY][gridX] = 3;
            score += 10;
          }
          
          // Eat power pellet
          if (maze[gridY][gridX] == 2) {
            maze[gridY][gridX] = 3;
            score += 50;
            activatePowerUp();
          }
          
          checkCollision();
          checkWin();
        }
      });
    }
  }
  
  bool canMove(String dir) {
    int testX = gridX;
    int testY = gridY;
    
    switch (dir) {
      case 'up':
        testY = gridY - 1;
        break;
      case 'down':
        testY = gridY + 1;
        break;
      case 'left':
        testX = gridX - 1;
        break;
      case 'right':
        testX = gridX + 1;
        break;
    }
    
    if (testX < 0) testX = cols - 1;
    if (testX >= cols) testX = 0;
    
    return isValidMove(testX, testY);
  }
  
  bool isValidMove(int x, int y) {
    if (y < 0 || y >= rows || x < 0 || x >= cols) return false;
    return maze[y][x] != 0;
  }
  
  void moveGhosts() {
    setState(() {
      for (var ghost in ghosts) {
        List<String> possibleMoves = ['up', 'down', 'left', 'right'];
        
        // Simple AI: prefer moving toward Pacman
        if (!powerUpActive && Random().nextDouble() > 0.3) {
          if (ghost.gridX < gridX && possibleMoves.contains('right')) {
            possibleMoves = ['right', ...possibleMoves.where((m) => m != 'right')];
          } else if (ghost.gridX > gridX && possibleMoves.contains('left')) {
            possibleMoves = ['left', ...possibleMoves.where((m) => m != 'left')];
          }
          
          if (ghost.gridY < gridY && possibleMoves.contains('down')) {
            possibleMoves = ['down', ...possibleMoves.where((m) => m != 'down')];
          } else if (ghost.gridY > gridY && possibleMoves.contains('up')) {
            possibleMoves = ['up', ...possibleMoves.where((m) => m != 'up')];
          }
        } else {
          possibleMoves.shuffle();
        }
        
        for (var move in possibleMoves) {
          int newX = ghost.gridX;
          int newY = ghost.gridY;
          
          switch (move) {
            case 'up':
              newY--;
              break;
            case 'down':
              newY++;
              break;
            case 'left':
              newX--;
              break;
            case 'right':
              newX++;
              break;
          }
          
          if (isValidMove(newX, newY) && maze[newY][newX] != 4) {
            ghost.gridX = newX;
            ghost.gridY = newY;
            ghost.x = newX.toDouble();
            ghost.y = newY.toDouble();
            break;
          }
        }
      }
      checkCollision();
    });
  }
  
  void activatePowerUp() {
    powerUpActive = true;
    powerUpTimer?.cancel();
    powerUpTimer = Timer(const Duration(seconds: 7), () {
      setState(() {
        powerUpActive = false;
      });
    });
  }
  
  void checkCollision() {
    for (var ghost in ghosts) {
      double distance = sqrt(
        pow(ghost.x - pacmanX, 2) + pow(ghost.y - pacmanY, 2)
      );
      
      if (distance < 0.6) {
        if (powerUpActive) {
          setState(() {
            score += 200;
            ghost.gridX = 9;
            ghost.gridY = 10;
            ghost.x = 9.0;
            ghost.y = 10.0;
          });
        } else {
          loseLife();
        }
      }
    }
  }
  
  void loseLife() {
    setState(() {
      lives--;
      if (lives <= 0) {
        isGameOver = true;
        gameTimer?.cancel();
        ghostTimer?.cancel();
        showGameOverDialog();
      } else {
        pacmanX = 9.0;
        pacmanY = 15.0;
        gridX = 9;
        gridY = 15;
        direction = 'right';
        nextDirection = 'right';
      }
    });
  }
  
  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('Game Over!',
            style: TextStyle(color: Colors.red, fontSize: 28)),
        content: Text('Final Score: $score',
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartGame();
            },
            child: const Text('Play Again',
                style: TextStyle(color: Colors.yellow, fontSize: 18)),
          ),
        ],
      ),
    );
  }
  
  void checkWin() {
    bool hasFood = false;
    for (var row in maze) {
      if (row.contains(1) || row.contains(2)) {
        hasFood = true;
        break;
      }
    }
    
    if (!hasFood) {
      setState(() {
        isGameOver = true;
        gameTimer?.cancel();
        ghostTimer?.cancel();
      });
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('You Win!',
              style: TextStyle(color: Colors.yellow, fontSize: 28)),
          content: Text('Final Score: $score',
              style: const TextStyle(color: Colors.white, fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                restartGame();
              },
              child: const Text('Play Again',
                  style: TextStyle(color: Colors.yellow, fontSize: 18)),
            ),
          ],
        ),
      );
    }
  }
  
  void restartGame() {
    setState(() {
      score = 0;
      lives = 3;
      isGameOver = false;
      isPaused = false;
      powerUpActive = false;
      pacmanX = 9.0;
      pacmanY = 15.0;
      gridX = 9;
      gridY = 15;
      direction = 'right';
      nextDirection = 'right';
      initializeMaze();
      initializeGhosts();
    });
    gameTimer?.cancel();
    ghostTimer?.cancel();
    startGame();
  }
  
  @override
  void dispose() {
    gameTimer?.cancel();
    ghostTimer?.cancel();
    powerUpTimer?.cancel();
    mouthController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pacman',
            style: TextStyle(
                color: Colors.yellow,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isPaused ? Icons.play_arrow : Icons.pause,
                color: Colors.yellow, size: 28),
            onPressed: () {
              setState(() {
                isPaused = !isPaused;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Score panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.blue[700]!],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SCORE: $score',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                Row(
                  children: List.generate(
                    lives,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: const Icon(Icons.favorite,
                          color: Colors.red, size: 32),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (powerUpActive)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue,
              child: const Text(
                '⚡ POWER MODE ⚡',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          // Game board with gesture detector
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dx.abs() > details.delta.dy.abs()) {
                  // Horizontal swipe
                  if (details.delta.dx > 0) {
                    nextDirection = 'right';
                  } else {
                    nextDirection = 'left';
                  }
                } else {
                  // Vertical swipe
                  if (details.delta.dy > 0) {
                    nextDirection = 'down';
                  } else {
                    nextDirection = 'up';
                  }
                }
              },
              child: Center(
                child: AspectRatio(
                  aspectRatio: cols / rows,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[800]!, width: 3),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double cellSize = constraints.maxWidth / cols;
                        
                        return Stack(
                          children: [
                            // Maze
                            CustomPaint(
                              size: Size(constraints.maxWidth, constraints.maxHeight),
                              painter: MazePainter(maze: maze, cellSize: cellSize),
                            ),
                            
                            // Pacman
                            Positioned(
                              left: pacmanX * cellSize,
                              top: pacmanY * cellSize,
                              child: AnimatedBuilder(
                                animation: mouthController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: Size(cellSize, cellSize),
                                    painter: PacmanPainter(
                                      direction: direction,
                                      mouthOpen: mouthController.value,
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            // Ghosts
                            ...ghosts.map((ghost) => Positioned(
                              left: ghost.x * cellSize,
                              top: ghost.y * cellSize,
                              child: CustomPaint(
                                size: Size(cellSize, cellSize),
                                painter: GhostPainter(
                                  color: powerUpActive ? Colors.blue : ghost.color,
                                  isScared: powerUpActive,
                                ),
                              ),
                            )),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Swipe instruction
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '👆 Swipe to move Pacman',
              style: TextStyle(
                color: Colors.yellow[700],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Ghost {
  double x;
  double y;
  int gridX;
  int gridY;
  Color color;
  String name;
  
  Ghost({
    required this.x,
    required this.y,
    required this.gridX,
    required this.gridY,
    required this.color,
    required this.name,
  });
}

class MazePainter extends CustomPainter {
  final List<List<int>> maze;
  final double cellSize;
  
  MazePainter({required this.maze, required this.cellSize});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (int y = 0; y < maze.length; y++) {
      for (int x = 0; x < maze[y].length; x++) {
        final rect = Rect.fromLTWH(
          x * cellSize,
          y * cellSize,
          cellSize,
          cellSize,
        );
        
        switch (maze[y][x]) {
          case 0: // Wall
            final paint = Paint()
              ..color = Colors.blue[800]!
              ..style = PaintingStyle.fill;
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                rect.deflate(cellSize * 0.05),
                Radius.circular(cellSize * 0.1),
              ),
              paint,
            );
            break;
            
          case 1: // Pellet
            final pelletPaint = Paint()
              ..color = Colors.white
              ..style = PaintingStyle.fill;
            canvas.drawCircle(
              Offset(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2),
              cellSize * 0.12,
              pelletPaint,
            );
            break;
            
          case 2: // Power pellet
            final powerPaint = Paint()
              ..color = Colors.white
              ..style = PaintingStyle.fill;
            canvas.drawCircle(
              Offset(x * cellSize + cellSize / 2, y * cellSize + cellSize / 2),
              cellSize * 0.25,
              powerPaint,
            );
            break;
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PacmanPainter extends CustomPainter {
  final String direction;
  final double mouthOpen;
  
  PacmanPainter({required this.direction, required this.mouthOpen});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    
    double startAngle = 0;
    switch (direction) {
      case 'right':
        startAngle = 0.2 + (mouthOpen * 0.3);
        break;
      case 'down':
        startAngle = pi / 2 + 0.2 + (mouthOpen * 0.3);
        break;
      case 'left':
        startAngle = pi + 0.2 + (mouthOpen * 0.3);
        break;
      case 'up':
        startAngle = 3 * pi / 2 + 0.2 + (mouthOpen * 0.3);
        break;
    }
    
    double sweepAngle = 2 * pi - 0.4 - (mouthOpen * 0.6);
    
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.85,
        height: size.height * 0.85,
      ),
      startAngle,
      sweepAngle,
      true,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GhostPainter extends CustomPainter {
  final Color color;
  final bool isScared;
  
  GhostPainter({required this.color, this.isScared = false});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final width = size.width * 0.8;
    final height = size.height * 0.8;
    final left = (size.width - width) / 2;
    final top = (size.height - height) / 2;
    
    // Body
    final path = Path();
    path.moveTo(left, top + height * 0.4);
    path.quadraticBezierTo(
      left,
      top,
      left + width * 0.5,
      top,
    );
    path.quadraticBezierTo(
      left + width,
      top,
      left + width,
      top + height * 0.4,
    );
    path.lineTo(left + width, top + height * 0.85);
    
    // Bottom wave
    for (int i = 0; i < 3; i++) {
      double waveWidth = width / 3;
      double waveX = left + (i * waveWidth);
      path.quadraticBezierTo(
        waveX + waveWidth * 0.5,
        top + height,
        waveX + waveWidth,
        top + height * 0.85,
      );
    }
    
    path.lineTo(left, top + height * 0.85);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Eyes
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    double eyeY = isScared ? top + height * 0.4 : top + height * 0.3;
    
    canvas.drawCircle(
      Offset(left + width * 0.3, eyeY),
      width * 0.12,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(left + width * 0.7, eyeY),
      width * 0.12,
      eyePaint,
    );
    
    // Pupils
    final pupilPaint = Paint()
      ..color = isScared ? Colors.red : Colors.blue[900]!
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(left + width * 0.3, eyeY),
      width * 0.06,
      pupilPaint,
    );
    canvas.drawCircle(
      Offset(left + width * 0.7, eyeY),
      width * 0.06,
      pupilPaint,
    );
    
    // Scared mouth
    if (isScared) {
      final mouthPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.05;
      
      for (int i = 0; i < 4; i++) {
        double x = left + width * 0.2 + (i * width * 0.2);
        canvas.drawLine(
          Offset(x, top + height * 0.6),
          Offset(x, top + height * 0.7),
          mouthPaint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}