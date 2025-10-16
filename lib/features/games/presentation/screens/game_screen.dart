import 'package:flutter/material.dart';
import 'package:serenote/features/games/sudoku/sudoku_game_screen.dart';
import '../../snake/snake_game_screen.dart';
import '../../word_search/word_search_screen.dart';
import '../../puzzle_2048/puzzle_2048_screen.dart';
import 'package:serenote/features/games/wordle/wordle_screen.dart';
import '../../bubble_breather/bubble_breather_screen.dart';
import '../../concentration/screens/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          },
        ),
        title: const Text(
          'Games',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search games...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: () {
                    // Add filter functionality
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Games List
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Games',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Game List
                    _buildGameList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameList(BuildContext context) {
    return Column(
      children: [
        _buildGameItem(
          context,
          'Snake Game',
          Icons.extension,
          Colors.green,
          const SnakeGameScreen(),
        ),
        _buildGameItem(
          context,
          '2048 Puzzle',
          Icons.grid_4x4,
          Colors.deepPurple,
          const Puzzle2048Screen(),
        ),
        _buildGameItem(
          context,
          'Word Search',
          Icons.search,
          Colors.orange,
          const WordSearchScreen(),
        ),
        _buildGameItem(
          context,
          'Bubble Breather',
          Icons.bubble_chart,
          Colors.blue,
          const BubbleBreatherScreen(),
        ),
        _buildGameItem(
          context,
          'Wordle',
          Icons.abc,
          const Color.fromARGB(255, 13, 109, 38),
          const WordleScreen(),
        ),
        _buildGameItem(
          context,
          'Concentration',
          FontAwesomeIcons.brain,
          Colors.blue,
          const HomeScreen(),
        ),
        _buildGameItem(
          context,
          'Sudoku',
          FontAwesomeIcons.one,
          Colors.blue,
          const SudokuGameScreen(),
        ),
        _buildStaticGameItem('Cali of Duty', Icons.sports_esports, Colors.blue),
        _buildStaticGameItem(
          'Public Mobile',
          Icons.phone_android,
          Colors.green,
        ),
        _buildStaticGameItem(
          'Magic Awakened',
          Icons.auto_awesome,
          Colors.purple,
        ),
        _buildStaticGameItem(
          'Magic Awakened Stardew Valley',
          Icons.landscape,
          Colors.green,
        ),
        _buildStaticGameItem(
          'My Dear Farm',
          Icons.agriculture,
          Colors.lightGreen,
        ),
        _buildStaticGameItem('Adorable Home', Icons.house, Colors.orange),
        _buildStaticGameItem('Campliro Cafe', Icons.coffee, Colors.brown),
        _buildStaticGameItem('Tudi Odyssey', Icons.travel_explore, Colors.teal),
        _buildStaticGameItem('Cats & Soup', Icons.soup_kitchen, Colors.amber),
        _buildStaticGameItem(
          'Harvest Town Cookies Must Do',
          Icons.cookie,
          Colors.orange,
        ),
        _buildStaticGameItem('Window Garden', Icons.spa, Colors.lightGreen),
        _buildStaticGameItem('Oilies Dance', Icons.music_note, Colors.pink),
        _buildStaticGameItem('Anemos', Icons.air, Colors.cyan),
      ],
    );
  }

  Widget _buildGameItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
      ),
    );
  }

  Widget _buildStaticGameItem(String title, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        // Handle static or unimplemented games
        debugPrint('$title tapped');
      },
    );
  }
}
