import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'package:provider/provider.dart' as provider;
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'splash_screen/screens/splash_screen.dart';

// Concentration game imports
import 'features/games/concentration/screens/new_game_screen.dart';
import 'features/games/concentration/screens/stats_screen.dart';
import 'features/games/concentration/screens/game_screen.dart';
import 'features/games/presentation/screens/game_screen.dart';

// Import the original game providers
import 'features/games/concentration/providers/settings_provider.dart';
import 'features/games/concentration/providers/game_stats_provider.dart';

/// Convert the existing ChangeNotifier providers into Riverpod providers
final settingsProvider = ChangeNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider();
});

final gameStatsProvider = ChangeNotifierProvider<GameStatsProvider>((ref) {
  return GameStatsProvider();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: 'assets/.env');
  } catch (_) {
    try {
      await dotenv.load();
    } catch (e) {
      print('dotenv not found in assets or project root: $e');
    }
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_KEY'];

  if ((supabaseUrl ?? '').isNotEmpty && (supabaseKey ?? '').isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl!, anonKey: supabaseKey!);
  } else {
    print('Supabase keys missing; skipping Supabase.initialize');
  }

  runApp(const ProviderScope(child: SerenoteApp()));
}

class SerenoteApp extends ConsumerWidget {
  const SerenoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If you ever need to access game providers globally, do it via:
    // final settings = ref.watch(settingsProvider);
    // final stats = ref.watch(gameStatsProvider);
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
        provider.ChangeNotifierProvider<GameStatsProvider>(create: (_) => GameStatsProvider()),
      ],
      child: MaterialApp(
        title: 'SereNote',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const DashboardScreen(),
          '/newGame': (context) => const NewGameScreen(),
          '/stats': (context) => const StatsScreen(),
          '/game': (context) => const GameScreen(),
          '/games_list': (context) => const GamesScreen(),
        },
      ),
    );
  }
}
