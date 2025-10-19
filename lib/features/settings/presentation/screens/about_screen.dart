import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart'; 


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
  title: Text(
    l10n.about_title,
    style: const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
    ),
  ),
  backgroundColor: const Color.fromARGB(255, 71, 134, 145),
  foregroundColor: Colors.white,
),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/about.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                child: Image.asset(
                  'assets/images/app_logo.png', // Add your app icon
                  width: 120,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.note_alt_outlined,
                      size: 40,
                      color: Colors.white,
                    );
                  },
                ),
              ),
               const SizedBox(height: 40),
              
              // Removed the Card widget and kept only the text
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  l10n.about_description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}