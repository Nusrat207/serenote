import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:serenote/l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

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
import 'core/localization/locale_notifier.dart';

// Import reset password screen
import 'features/auth/presentation/screens/reset_password_screen.dart';

/// Convert the existing ChangeNotifier providers into Riverpod providers
final settingsProvider = ChangeNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider();
});

final gameStatsProvider = ChangeNotifierProvider<GameStatsProvider>((ref) {
  return GameStatsProvider();
});

// Global navigator key for navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    await Supabase.initialize(
      url: supabaseUrl!,
      anonKey: supabaseKey!,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      // This helps handle deep links automatically
      debug: true,
    );

    // Listen to auth state changes for password recovery
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      print('🔥 Auth State Change: ${data.event}');
      print('🔥 Session: ${data.session?.user.email}');
      
      final event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        print('🔥 Password recovery detected!');
        // Small delay to ensure navigator is ready
        Future.delayed(const Duration(milliseconds: 500), () {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            ),
            (route) => false,
          );
        });
      }
    });
  } else {
    print('Supabase keys missing; skipping Supabase.initialize');
  }

  runApp(const ProviderScope(child: SerenoteApp()));
}

class SerenoteApp extends ConsumerWidget {
  const SerenoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
        provider.ChangeNotifierProvider<GameStatsProvider>(
          create: (_) => GameStatsProvider(),
        ),
      ],
      child: Consumer(builder: (context, ref, _) {
        final appLocale = ref.watch(localeProvider);
        return MaterialApp(
          navigatorKey: navigatorKey, // Add global navigator key
          onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? 'SereNote',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          locale: appLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('bn'),
          ],
          home: const SplashScreen(),
          routes: {
            '/home': (context) => const DashboardScreen(),
            '/newGame': (context) => const NewGameScreen(),
            '/stats': (context) => const StatsScreen(),
            '/game': (context) => const GameScreen(),
            '/games_list': (context) => const GamesMenuScreen(),
            '/reset-password': (context) => const ResetPasswordScreen(),
          },
        );
      }),
    );
  }
}