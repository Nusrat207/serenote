import '../global/global.dart';
import '../widgets/main_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'new_game_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // optional, make it match your design
        elevation: 0, // removes shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // change color if needed
          onPressed: () {
            Navigator.pop(context); // go back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27.0),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Concentration',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Global.colors.darkIconColor),
                ),
                Text(
                  'a game of memory',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Global.colors.darkIconColor),
                ),
                const SizedBox(height: 127),
                MainButton(
                  title: 'New Game',
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, '/newGame');
                  },
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: !kIsWeb,
                  child: MainButton(
                    title: 'Stats',
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pushNamed(context, '/stats');
                    },
                  ),
                ),
                const SizedBox(height: 20),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
