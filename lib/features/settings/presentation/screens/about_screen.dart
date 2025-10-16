import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: const Text('About Serenote'),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'SereNote A mindful companion. '
                  'SereNote is designed to help users cultivate emotional awareness, track their moods and habits, and find calm through reflection and focus-enhancing mini-games. It blends journaling, micro-habit tracking, motivational quotes, and soft gamification — creating a space for gentle growth, balance, and insight.',
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