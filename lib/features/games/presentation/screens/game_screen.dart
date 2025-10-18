import 'package:flutter/material.dart';
import 'package:serenote/features/games/sudoku/sudoku_game_screen.dart';
import '../../snake/snake_game_screen.dart';
import '../../word_search/word_search_screen.dart';
import '../../puzzle_2048/puzzle_2048_screen.dart';
import 'package:serenote/features/games/wordle/wordle_screen.dart';
import 'package:serenote/features/games/pacman/pacman_game.dart';
import '../../slide_puzzle/screens/slide_puzzle_screen.dart';
import '../../slide_puzzle/screens/difficulty_selection_screen.dart';
import '../../tetris/screens/tetris_difficulty_screen.dart';



import '../../bubble_breather/bubble_breather_screen.dart';
import '../../concentration/screens/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class GamesMenuScreen extends StatefulWidget {
  const GamesMenuScreen({super.key});

  @override
  State<GamesMenuScreen> createState() => _GamesMenuScreenState();
}

class _GamesMenuScreenState extends State<GamesMenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<GameItem> _allGames = [];
  List<GameItem> _filteredGames = [];

  // Card customization properties
  final double _cardHeight = 200; // Customize card height
  final double _cardWidth = double.infinity; // Customize card width (infinity for auto)
  final double _cardBorderRadius = 10; // Customize border radius
  final double _cardElevation = 6; // Customize shadow intensity
final Color _cardBackgroundColor = Colors.transparent;  final bool _showShadow = false; // Toggle shadow on/off
  final double _imageBorderRadius = 18; // Customize image border radius (slightly less than card)
  final Color _imageBorderColor = const Color.fromARGB(255, 255, 255, 255); // Customize image border color
  final double _imageBorderWidth = 4.0; // Customize image border width
  final bool _showImageBorder = true; // Toggle image border on/off

  final Color _cardBorderColor = const Color.fromARGB(255, 255, 255, 255); // Card border color
  final double _cardBorderWidth = 3.0; // Card border thickness
  final bool _showCardBorder = true; // Toggle card border on/off
  
  @override
  void initState() {
    super.initState();
    _initializeGames();
    _filteredGames = _allGames;
  }

  void _initializeGames() {
    _allGames = [
      GameItem(
        name: 'Snake Game',
        imageAsset: 'assets/images/snake.png',
        route: const SnakeGameScreen(),
        color: Colors.green,
      ),
      GameItem(
        name: 'Number Slide',
        imageAsset: 'assets/images/number_slide.jpg',
        route: const Puzzle2048Screen(),
        color: Colors.deepPurple,
      ),
      GameItem(
        name: 'Wordzee',
        imageAsset: 'assets/images/Wordzee.jpeg',
        route: const WordSearchScreen(),
        color: Colors.orange,
      ),
      
      GameItem(
        name: 'Wordle',
        imageAsset: 'assets/images/wordle.jpeg',
        route: const WordleScreen(),
        color: const Color.fromARGB(255, 13, 109, 38),
      ),
      GameItem(
        name: 'Concentration',
        imageAsset: 'assets/images/concentration.jpg',
        route: const HomeScreen(),
        color: Colors.blue,
      ),
      
      GameItem(
        name: 'Sudoku',
        imageAsset: 'assets/images/Sudoku.jpeg',
        route: const SudokuGameScreen(),
        color: Colors.green,
      ),
      GameItem(
        name: 'Slide Puzzle',
        imageAsset: 'assets/images/slide_puzzle.png',
        route: const DifficultySelectionScreen(),
        color: Colors.purple,
      ),
      GameItem(
        name: 'Tetris',
        imageAsset: 'assets/images/tetris.png',
        route: const TetrisDifficultyScreen(),
        color: Colors.lightGreen,
      ),
    ];
  }

  void _filterGames(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredGames = _allGames;
      } else {
        _filteredGames = _allGames
            .where((game) =>
                game.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/game_bg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Back Button and Title
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color.fromARGB(255, 71, 134, 145).withOpacity(0.8),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DashboardScreen()),
                          );
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Games',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search games...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _filterGames('');
                        },
                      ),
                    ),
                    onChanged: _filterGames,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Games Grid (2 cards per row)
                Expanded(
                  child: _filteredGames.isEmpty
                      ? const Center(
                          child: Text(
                            'No games found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 24, // Increased for better text spacing
                            childAspectRatio: _calculateChildAspectRatio(), // Dynamic aspect ratio
                          ),
                          itemCount: _filteredGames.length,
                          itemBuilder: (context, index) {
                            return _buildGameCard(_filteredGames[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Calculate dynamic aspect ratio based on card height and text
  double _calculateChildAspectRatio() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2; // 16*3 padding = 48
    return cardWidth / (_cardHeight + 30); // 30 for text and spacing
  }

  Widget _buildGameCard(GameItem game) {
    return Column(
      children: [
        // Game Image Card with Border
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => game.route),
            );
          },
          child: Container(
            height: _cardHeight,
            width: _cardWidth,
            decoration: BoxDecoration(
              color: _cardBackgroundColor,
              borderRadius: BorderRadius.circular(_cardBorderRadius),
              border: _showCardBorder
                  ? Border.all(
                      color: _cardBorderColor,
                      width: _cardBorderWidth,
                    )
                  : null,
              boxShadow: _showShadow
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_cardBorderRadius - (_showCardBorder ? 1 : 0)),
              child: Stack(
                children: [
                  // Game Image
                  Image.asset(
                    game.imageAsset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: game.color.withOpacity(0.2),
                        child: Center(
                          child: Icon(
                            Icons.sports_esports,
                            color: game.color,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  
                  // Play button overlay
                  
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Game Name below the card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            game.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(221, 255, 255, 255),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class GameItem {
  final String name;
  final String imageAsset;
  final Widget route;
  final Color color;

  GameItem({
    required this.name,
    required this.imageAsset,
    required this.route,
    required this.color,
  });
}