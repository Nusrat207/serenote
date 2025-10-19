import 'package:flutter/material.dart';
import 'package:serenote/features/settings/presentation/screens/language_screen.dart';
import 'package:serenote/features/settings/presentation/screens/about_screen.dart';
import 'package:serenote/features/settings/presentation/screens/help_center_screen.dart';
import 'package:serenote/l10n/app_localizations.dart'; // Add this import

class SettingsPanel extends StatelessWidget {
  final VoidCallback onClose;

  const SettingsPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context); // Add this line

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  l10n.settings_title, // Updated
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Settings Options
          _buildSettingsOption(
            context, // Add context parameter
            icon: Icons.language,
            title: l10n.settings_language, // Updated
            subtitle: l10n.settings_language_desc, // Updated
            onTap: () {
              onClose();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguageScreen()),
              );
            },
          ),
          
          _buildSettingsOption(
            context, // Add context parameter
            icon: Icons.info_outline,
            title: l10n.settings_about, // Updated
            subtitle: l10n.settings_about_desc, // Updated
            onTap: () {
              onClose();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          
          _buildSettingsOption(
            context, // Add context parameter
            icon: Icons.help_outline,
            title: l10n.settings_help, // Updated
            subtitle: l10n.settings_help_desc, // Updated
            onTap: () {
              onClose();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
              );
            },
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, // Add context parameter
    {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 71, 134, 145).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color.fromARGB(255, 71, 134, 145),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}