import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/features/timer/presentation/screens/timer_screen.dart';
import 'package:serenote/core/services/auth_service.dart';
import 'package:serenote/features/auth/presentation/screens/login_screen.dart';
import 'package:serenote/features/auth/presentation/screens/register_screen.dart';
import 'package:serenote/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:serenote/features/todo/presentation/screens/todo_screen.dart';
import 'package:serenote/features/journal/presentation/screens/journal_screen.dart';
import 'package:serenote/features/games/presentation/screens/game_screen.dart';
import 'package:serenote/features/profile/presentation/screens/profile_screen.dart';
import 'package:serenote/core/di/dependency_injection.dart';
import 'package:serenote/features/profile/domain/entities/profile_entity.dart';
import 'package:serenote/features/settings/presentation/widgets/settings_panel.dart';
import 'package:serenote/features/settings/presentation/screens/language_screen.dart';
import 'package:serenote/features/settings/presentation/screens/about_screen.dart';
import 'package:serenote/features/settings/presentation/screens/help_center_screen.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SettingsPanel(
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = AuthService().currentUser;
    final isLoggedIn = currentUser != null;

    // Watch the profile provider to get real-time updates
    final profile = isLoggedIn ? ref.watch(profileProvider) : null;

    return Drawer(
      width: 300,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sidebar_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Login Card Section (Shows when not logged in)
              if (!isLoggedIn) _buildLoginCard(context),

              // Enhanced User Info Section (Shows when logged in)
              if (isLoggedIn)
                _buildEnhancedUserInfoSection(currentUser!, profile, context),

              // Features Section with Image Bars
              _buildFeaturesSectionWithImages(context),

              // Common Tools Section with circle buttons
              _buildCommonToolsSection(context, isLoggedIn),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedUserInfoSection(
    User user,
    ProfileEntity? profile,
    BuildContext context,
  ) {
    // Use profile data if available, otherwise fall back to user metadata
    final displayName =
        profile?.displayName ??
        user.userMetadata?['full_name'] ??
        user.userMetadata?['name'] ??
        user.email?.split('@').first ??
        'User';
    final avatarPath = profile?.avatarPath;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar and info
          Row(
            children: [
              // Avatar using the same logic as profile screen
              _buildUserAvatar(avatarPath, displayName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(221, 8, 6, 6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.email ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Removed the Edit Profile button as requested
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String? avatarPath, String displayName) {
    if (avatarPath != null && avatarPath.isNotEmpty) {
      // Load avatar from local assets (same as profile screen)
      return CircleAvatar(
        radius: 24,
        backgroundColor: const Color.fromARGB(255, 71, 134, 145),
        child: ClipOval(
          child: Image.asset(
            avatarPath,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to initials if image fails to load
              return _buildAvatarInitials(displayName);
            },
          ),
        ),
      );
    } else {
      // Fallback to colored circle with initials
      return CircleAvatar(
        radius: 24,
        backgroundColor: _getAvatarColor(displayName),
        child: _buildAvatarInitials(displayName),
      );
    }
  }

  Widget _buildAvatarInitials(String displayName) {
    return Text(
      displayName[0].toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Color _getAvatarColor(String displayName) {
    // Generate consistent color based on display name
    final colors = [
      Colors.purpleAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.tealAccent,
      Color.fromARGB(255, 71, 134, 145), // Added your profile screen color
    ];
    final index = displayName.hashCode % colors.length;
    return colors[index];
  }

  Widget _buildFeaturesSectionWithImages(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageBarItem(context, 'assets/images/todo.png', () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RoutineScreen()),
          );
        }),
        // Image Bar for Journal
        //  _buildImageBarItem(
        //    context,
        //    'assets/images/journal.png',
        //    () {
        //      Navigator.of(context).pop();
        //      Navigator.push(
        //        context,
        //        MaterialPageRoute(builder: (context) => JournalScreen()),
        //      );
        //    },
        //   ),
        // Image Bar for Timer (added as image bar like journal)
        _buildImageBarItem(context, 'assets/images/timer.png', () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TimerScreen()),
          );
        }),
        _buildImageBarItem(context, 'assets/images/games.png', () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GamesMenuScreen()),
          );
        }),
      ],
    );
  }

  Widget _buildImageBarItem(
    BuildContext context,
    String imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        height: 105,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
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
            style: TextStyle(fontSize: 14, color: Colors.grey),
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
                    backgroundColor: const Color.fromARGB(255, 71, 134, 145),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                    foregroundColor: const Color.fromARGB(255, 71, 134, 145),
                    side: const BorderSide(
                      color: const Color.fromARGB(255, 71, 134, 145),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommonToolsSection(BuildContext context, bool isLoggedIn) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          const SizedBox(height: 1),
          _buildCircleButtonsSection(context, isLoggedIn),
        ],
      ),
    );
  }

  Widget _buildCircleButtonsSection(BuildContext context, bool isLoggedIn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color.fromARGB(255, 38, 27, 70),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the sidebar
              // Show settings panel
              _showSettingsBottomSheet(context);
            },
            icon: const Icon(
              Icons.settings_outlined,
              size: 22,
              color: Color.fromARGB(221, 255, 255, 255),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        if (isLoggedIn) // Only show logout button when logged in
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
              icon: const Icon(Icons.logout, size: 22, color: Colors.red),
              padding: EdgeInsets.zero,
            ),
          ),
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color.fromARGB(255, 37, 41, 82),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the sidebar
              if (isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      onBackPressed: () {
                        // When back is pressed in ProfileScreen, return to dashboard and open sidebar
                        Navigator.of(context).pop(); // Close ProfileScreen
                        // Open the sidebar immediately
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Scaffold.of(context).openDrawer();
                        });
                      },
                    ),
                  ),
                );
              } else {
                // If not logged in, navigate to login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            icon: Icon(
              isLoggedIn ? Icons.person_outline : Icons.login,
              size: 22,
              color: const Color.fromARGB(221, 255, 255, 255),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
