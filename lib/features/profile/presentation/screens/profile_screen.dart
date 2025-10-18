import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/core/di/dependency_injection.dart';
import 'package:serenote/features/auth/presentation/screens/login_screen.dart';
import '../../domain/entities/profile_entity.dart';
import '../widgets/avatar_selection_grid.dart';
import '../widgets/display_name_editor.dart';
import 'package:serenote/features/mood/presentation/providers/mood_provider.dart';
class ProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBackPressed; // Add this callback

  const ProfileScreen({super.key, this.onBackPressed});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user == null) {
        setState(() {
          _error = 'User not authenticated. Please log in.';
          _isLoading = false;
        });
        return;
      }

      await ref.read(profileProvider.notifier).loadProfile(user.id);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load profile: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _goBackWithSidebar() {
    // Use the callback if provided, otherwise just pop
    if (widget.onBackPressed != null) {
      widget.onBackPressed!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final moodColor = ref
        .watch(moodColorProvider)
        .maybeWhen(
          data: (c) => c,
          orElse: () => const Color(0xFF477D9E), // fallback
        );
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sidebar_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with Circle Back Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: moodColor.withOpacity(0.8),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white,),
                        onPressed: _goBackWithSidebar, // Use the new method
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Profile Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                                const SizedBox(height: 16),
                                Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16, color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                // Login Button instead of Retry
                                ElevatedButton(
                                  onPressed: _navigateToLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 71, 134, 145),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : profile == null
                            ? const Center(child: Text('No profile data available'))
                            : SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    // Current Avatar Display
                                    _buildCurrentAvatarSection(profile),
                                    const SizedBox(height: 24),
                                    
                                    // Avatar Selection
                                    AvatarSelectionGrid(currentAvatar: profile.avatarPath),
                                    const SizedBox(height: 24),
                                    
                                    // Display Name Editor in a Card
                                    Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: DisplayNameEditor(
                                          currentName: profile.displayName,
                                          onNameUpdated: (newName) {
                                            final user = Supabase.instance.client.auth.currentUser;
                                            if (user != null) {
                                              ref.read(profileProvider.notifier).updateDisplayName(user.id, newName);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentAvatarSection(ProfileEntity profile) {
     final moodColor = ref
        .watch(moodColorProvider)
        .maybeWhen(
          data: (c) => c,
          orElse: () => const Color(0xFF477D9E), // fallback
        );
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: moodColor,
          child: (profile.avatarPath != null && profile.avatarPath!.isNotEmpty)
              ? ClipOval(
                  child: Image.asset(
                    profile.avatarPath!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(profile);
                    },
                  ),
                )
              : _buildDefaultAvatar(profile),
        ),
        const SizedBox(height: 16),
        Text(
          profile.displayName ?? 'User',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          profile.email,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(ProfileEntity profile) {
    return Text(
      profile.displayName?[0].toUpperCase() ?? 
      profile.email[0].toUpperCase(),
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}