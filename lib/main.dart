import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings
  await dotenv.load(); // Load environment variables

  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseKey = dotenv.env['SUPABASE_KEY']!;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

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
      home: const DashboardScreen(),
    );
  }
}
