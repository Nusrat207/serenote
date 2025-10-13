import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/features/timer/presentation/screens/timer_screen.dart';
import 'package:serenote/core/services/auth_service.dart';
import 'package:serenote/features/auth/presentation/screens/login_screen.dart';
import 'package:serenote/features/auth/presentation/screens/register_screen.dart';
import 'package:serenote/features/dashboard/presentation/screens/dashboard_screen.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    final isLoggedIn = currentUser != null;

    return Drawer(
      width: 300,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // User Info Section (Shows when logged in)
            if (isLoggedIn) _buildUserInfoSection(currentUser!),
            
            // Login Card Section (Shows when not logged in)
            if (!isLoggedIn) _buildLoginCard(context),
            
            const Divider(height: 1),
            
            // Features Section
            _buildFeaturesSection(),
            
            const Divider(height: 1),
            
            // Common Tools Section
            _buildCommonToolsSection(context),
            
            const Spacer(),
            
            // Logout Button (when logged in)
            if (isLoggedIn) _buildLogoutSection(context),
            
            // Bottom Section
            _buildBottomSection(context),
          ],
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
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Premium User',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Quick stats or user actions
          Row(
            children: [
              _buildUserStat('Tasks', '12'),
              const SizedBox(width: 16),
              _buildUserStat('Streak', '7d'),
              const SizedBox(width: 16),
              _buildUserStat('Level', '2'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.purpleAccent,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
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

  Widget _buildLogoutSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () async {
            await AuthService().signOut();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => DashboardScreen()),
                (route) => false,
              );
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Features',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureItem('Task Management', Icons.task_alt),
          _buildFeatureItem('Habit Stats', Icons.insights),
          _buildFeatureItem('Daily Journal', Icons.book),
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
          const Text(
            'Common Tools',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildToolItem(context, 'Timer', Icons.timer_outlined),
          _buildToolItem(context, 'Hydration tracker', Icons.water_drop_outlined),
          _buildToolItem(context, 'Reflection', Icons.psychology_outlined),
          _buildToolItem(context, 'Meditation', Icons.self_improvement_outlined),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildBottomItem('Help center', Icons.help_outline),
          _buildBottomItem('Feedback', Icons.feedback_outlined),
          _buildBottomItem('Settings', Icons.settings_outlined),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        size: 20,
        color: Colors.purpleAccent,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        // Handle feature navigation
      },
    );
  }

  Widget _buildToolItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        size: 20,
        color: Colors.purpleAccent,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        // Close the drawer first
        Navigator.of(context).pop();
        
        // Handle tool navigation
        if (title == 'Timer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TimerScreen()),
          );
        } else if (title == 'Hydration tracker') {
          // Add hydration tracker navigation here
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HydrationTrackerScreen()));
        } else if (title == 'Reflection') {
          // Add reflection navigation here
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ReflectionScreen()));
        } else if (title == 'Meditation') {
          // Add meditation navigation here
          // Navigator.push(context, MaterialPageRoute(builder: (context) => MeditationScreen()));
        }
      },
    );
  }

  Widget _buildBottomItem(String title, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        size: 20,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      onTap: () {
        // Handle bottom item navigation
      },
    );
  }
}