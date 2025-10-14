import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart'; // unused here
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'splash_screen/screens/splash_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings

  // Try to load packaged .env from assets first. This prevents a FileNotFound
  // exception on devices when a developer doesn't have a local .env file.
  try {
    // Load .env from assets packaged with the app
    await dotenv.load(fileName: 'assets/.env');
  } catch (_) {
    // Fallback to normal behavior which will try to load a top-level .env if
    // present in the project. We catch errors to avoid crashing on devices.
    try {
      await dotenv.load();
    } catch (e) {
      // ignore: avoid_print
      print('dotenv not found in assets or project root: $e');
    }
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_KEY'];

  if ((supabaseUrl ?? '').isNotEmpty && (supabaseKey ?? '').isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl!, anonKey: supabaseKey!);
  } else {
    // If keys are missing, continue without initializing Supabase. The app
    // will still run (use mocks or local DB), but features that rely on
    // Supabase will be disabled until valid keys are provided.
    // ignore: avoid_print
    print('Supabase keys missing; skipping Supabase.initialize');
  }

  runApp(const ProviderScope(child: SerenoteApp()));
}

class SerenoteApp extends StatelessWidget {
  const SerenoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SereNote',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const DashboardScreen(),
      },
    );
  }
}
