import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/features/timer/presentation/screens/timer_screen.dart';
import 'package:serenote/core/services/auth_service.dart';
import 'package:serenote/features/auth/presentation/screens/login_screen.dart';
import 'package:serenote/features/auth/presentation/screens/register_screen.dart';
import 'package:serenote/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:serenote/features/todo/presentation/screens/todo_screen.dart';
import 'package:serenote/features/journal/presentation/screens/journal_screen.dart';
import 'package:serenote/features/games/presentation/screens/game_screen.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    final isLoggedIn = currentUser != null;

    return Drawer(
      width: 300,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sidebar_bg.png'), // Add your background image
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Login Card Section (Shows when not logged in) - At the top
              if (!isLoggedIn) _buildLoginCard(context),
              
              // User Info Section (Shows when logged in)
              if (isLoggedIn) _buildUserInfoSection(currentUser!),
              
              // Features Section with Image Bars (no divider)
              _buildFeaturesSectionWithImages(context),
              
              // Common Tools Section with circle buttons
              _buildCommonToolsSection(context),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar and email
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purpleAccent,
                child: Text(
                  user.email?[0].toUpperCase() ?? 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.email ?? 'User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(221, 8, 6, 6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Removed "Premium User" text
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSectionWithImages(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Bar for Task Management
        _buildImageBarItem(
          context,
          'assets/images/todo.png',
          () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RoutineScreen()),
            );
          },
        ),
        // Image Bar for Journal
        _buildImageBarItem(
          context,
          'assets/images/journal.png',
          () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JournalScreen()),
            );
          },
        ),
        // Image Bar for Timer (added as image bar like journal)
        _buildImageBarItem(
          context,
          'assets/images/timer.png', // Make sure you have timer.png in assets
          () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TimerScreen()),
            );
          },
        ),
        // Image Bar for Games
        _buildImageBarItem(
          context,
          'assets/images/games.png',
          () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GamesScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildImageBarItem(BuildContext context, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320, // Custom width (less than sidebar width)
        height: 105,
        margin: const EdgeInsets.symmetric(horizontal: 10), // Center it with margin
        padding: const EdgeInsets.all(8), // Padding on all sides
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7), // More rounded corners
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.error_outline,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 32,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sign up or log in',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You are currently on guest mode',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purpleAccent,
                    side: const BorderSide(color: Colors.purpleAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommonToolsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          // Removed the old timer list item since it's now an image bar
          
          // Add the three circle buttons
          const SizedBox(height: 1),
          _buildCircleButtonsSection(context),
        ],
      ),
    );
  }

  Widget _buildCircleButtonsSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Settings Icon
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color.fromARGB(255, 38, 27, 70),
          child: IconButton(
            onPressed: () {
              // Handle settings navigation
            },
            icon: const Icon(
              Icons.settings_outlined,
              size: 22,
              color: Color.fromARGB(221, 255, 255, 255),
            ),
            padding: EdgeInsets.zero,
          ),
        ),

        // Logout Icon
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color.fromARGB(255, 39, 46, 77),
          child: IconButton(
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(
              Icons.logout,
              size: 22,
              color: Colors.red,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        
        // Update Profile Icon
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color.fromARGB(255, 37, 41, 82),
          child: IconButton(
            onPressed: () {
              // Handle update profile navigation
            },
            icon: const Icon(
              Icons.person_outline,
              size: 22,
              color: Color.fromARGB(221, 255, 255, 255),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  // Removed _buildToolItem method since timer is now an image bar
}