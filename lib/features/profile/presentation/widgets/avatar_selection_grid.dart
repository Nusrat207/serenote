import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/core/di/dependency_injection.dart';

class AvatarSelectionGrid extends ConsumerWidget {
  final String? currentAvatar;
  
  const AvatarSelectionGrid({super.key, this.currentAvatar});

  // List of available avatars from local assets
  final List<String> avatars = const [
    'assets/avatars/avatar1.jpeg',
    'assets/avatars/avatar2.jpeg',
    'assets/avatars/avatar3.jpeg',
    'assets/avatars/avatar4.jpeg',
    'assets/avatars/avatar5.jpeg',
    'assets/avatars/avatar6.jpeg',
    'assets/avatars/avatar7.jpeg',
    'assets/avatars/avatar8.jpeg',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Avatar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            final isSelected = currentAvatar == avatars[index];
            return GestureDetector(
              onTap: () {
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null) {
                  ref.read(profileProvider.notifier).updateAvatar(
                    user.id, 
                    avatars[index]
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in to update avatar')),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color.fromARGB(255, 71, 134, 145): Colors.grey,
                    width: isSelected ? 3 : 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    avatars[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}