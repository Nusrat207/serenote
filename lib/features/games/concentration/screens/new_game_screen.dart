import '../enums/difficulty.dart';
import '../enums/gametheme.dart';
import '../enums/mapsize.dart';
import '../global/global.dart';
import '../providers/settings_provider.dart';
import '../widgets/difficulty_card.dart';
import '../widgets/main_button.dart';
import '../widgets/map_card.dart';
import '../widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/difficulty_slider.dart';

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({Key? key}) : super(key: key);

  @override
  _NewGameScreenState createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("How to Play"),
        content: const Text(
          "🧠 Concentration is a memory matching game.\n\n"
          "1️⃣ Choose your map size, difficulty, and theme.\n"
          "2️⃣ Press Play to start.\n"
          "3️⃣ Tap cards to flip them.\n"
          "4️⃣ Match pairs of identical cards.\n"
          "5️⃣ Try to clear all pairs before time runs out!\n\n"
          "The fewer flips you use, the better your score!",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it!"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Concentration",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Global.colors.darkIconColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Colors.white),
            tooltip: "How to Play",
            onPressed: () => _showHowToPlayDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              _buildSectionTitle("Map"),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MapCard(
                    mapSize: MapSize.fourxfour,
                    selected: settings.mapSize == MapSize.fourxfour,
                    mapCallback: settings.setMapSize,
                  ),
                  MapCard(
                    mapSize: MapSize.fivexsix,
                    selected: settings.mapSize == MapSize.fivexsix,
                    mapCallback: settings.setMapSize,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildSectionTitle("Difficulty"),
              const SizedBox(height: 5),
              DifficultySlider(
                    difficulty: settings.difficulty,
                    onChanged: settings.setDifficulty,
                  ),
              const SizedBox(height: 10),
              _buildSectionTitle("Theme"),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ThemeCard(
                    selected: settings.gameTheme == GameTheme.concentration,
                    gameTheme: GameTheme.concentration,
                    gameThemeCallback: settings.setGameTheme,
                  ),
                  ThemeCard(
                    selected: settings.gameTheme == GameTheme.retro,
                    gameTheme: GameTheme.retro,
                    gameThemeCallback: settings.setGameTheme,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Centered Play Button
              SizedBox(
                width: 160, // Adjust size as needed
                height: 70,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/game');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/play.png', // Make sure your image is in this path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Global.colors.darkIconColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
