import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/l10n/app_localizations.dart';
import 'package:serenote/core/localization/locale_notifier.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: Text(loc?.languageSettings ?? 'Language Settings'),
        backgroundColor: const Color.fromARGB(255, 71, 134, 145),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sidebar_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc?.selectLanguage ?? 'Select Language',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLanguageOption(
                        context,
                        ref,
                        label: 'English',
                        locale: const Locale('en'),
                        isSelected: (currentLocale?.languageCode ?? 'en') == 'en',
                      ),
                      _buildLanguageOption(
                        context,
                        ref,
                        label: 'বাংলা',
                        locale: const Locale('bn'),
                        isSelected: (currentLocale?.languageCode ?? 'en') == 'bn',
                      ),
                      const SizedBox(height: 8),
                      _buildSystemDefault(context, ref, isSelected: currentLocale == null),
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

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required Locale locale,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).setLocale(locale),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected
                      ? const Color.fromARGB(255, 71, 134, 145)
                      : Colors.black87,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 71, 134, 145),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemDefault(
    BuildContext context,
    WidgetRef ref, {
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => ref.read(localeProvider.notifier).setLocale(null),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Use device language',
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected
                      ? const Color.fromARGB(255, 71, 134, 145)
                      : Colors.black87,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 71, 134, 145),
              ),
          ],
        ),
      ),
    );
  }
}
