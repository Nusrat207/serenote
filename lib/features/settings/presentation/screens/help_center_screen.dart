import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: const Text('Help Center'),
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
            children: [
              _buildHelpCard(
                context,
                'Getting Started',
                'Learn how to use Serenote features',
                Icons.play_arrow,
                () {
                  // Navigate to Getting Started screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GettingStartedScreen(),
                    ),
                  );
                },
              ),
              _buildHelpCard(
                context,
                'FAQ',
                'Frequently asked questions',
                Icons.question_answer,
                () {
                  // Navigate to FAQ screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FAQScreen(),
                    ),
                  );
                },
              ),
              _buildHelpCard(
                context,
                'Contact Support',
                'Get in touch with our team',
                Icons.contact_support,
                () {
                  // Navigate to Contact Support screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactSupportScreen(),
                    ),
                  );
                },
              ),
              _buildHelpCard(
                context,
                'Privacy Policy',
                'Learn about our privacy practices',
                Icons.privacy_tip,
                () {
                  // Navigate to Privacy Policy screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
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
      ),
    );
  }
}

// Getting Started Screen
class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: const Text('Getting Started'),
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
          child: ListView(
            children: const [
              _GuideStep(
                step: '1',
                title: 'Create Your Account',
                description: 'Sign up or log in to start using Serenote. Your data will be synced across all your devices.',
              ),
              _GuideStep(
                step: '2',
                title: 'Set Up Your Profile',
                description: 'Add a display name and avatar to personalize your experience.',
              ),
              _GuideStep(
                step: '3',
                title: 'Explore Features',
                description: 'Try out Todo, Journal, Timer, and Games to discover what works best for you.',
              ),
              _GuideStep(
                step: '4',
                title: 'Create Your First Todo',
                description: 'Start by adding tasks to your todo list to stay organized.',
              ),
              _GuideStep(
                step: '5',
                title: 'Write Your First Journal',
                description: 'Express your thoughts and reflections in your personal journal.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final String step;
  final String title;
  final String description;

  const _GuideStep({
    required this.step,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 71, 134, 145),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  step,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FAQ Screen
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
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
          child: ListView(
            children: const [
              _FAQItem(
                question: 'How do I reset my password?',
                answer: 'Go to Login screen, click "Forgot Password" and follow the instructions sent to your email.',
              ),
              _FAQItem(
                question: 'Is my data secure?',
                answer: 'Yes, all your data is encrypted and stored securely. We use industry-standard security practices.',
              ),
              _FAQItem(
                question: 'Can I use Serenote offline?',
                answer: 'Yes, most features work offline. Your data will sync when you reconnect to the internet.',
              ),
              _FAQItem(
                question: 'How do I delete my account?',
                answer: 'Contact support from the Help Center to request account deletion.',
              ),
              _FAQItem(
                question: 'Are there any subscription fees?',
                answer: 'Serenote is currently free to use. We may introduce premium features in the future.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Contact Support Screen
class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: const Text('Contact Support'),
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
              const Text(
                'Get in Touch',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We\'re here to help you with any issues or questions.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              _buildContactOption(
                icon: Icons.email,
                title: 'Email Support',
                subtitle: 'support@serenote.com',
                onTap: () {
                  // Implement email functionality
                },
              ),
              _buildContactOption(
                icon: Icons.chat,
                title: 'Live Chat',
                subtitle: 'Available 9AM-6PM Mon-Fri',
                onTap: () {
                  // Implement chat functionality
                },
              ),
              
              const SizedBox(height: 32),
              const Text(
                'Send us a Message',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement send message functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message sent to support team!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 71, 134, 145),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 71, 134, 145)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
          child: ListView(
            children: const [
              _PolicySection(
                title: 'Information We Collect',
                content: 'We collect information you provide directly to us, such as when you create an account, use our features, or contact us for support.',
              ),
              _PolicySection(
                title: 'How We Use Your Information',
                content: 'We use the information we collect to provide, maintain, and improve our services, to develop new ones, and to protect Serenote and our users.',
              ),
              _PolicySection(
                title: 'Information Sharing',
                content: 'We do not share your personal information with companies, organizations, or individuals outside of Serenote except in the following cases: with your consent, for legal reasons, or with domain administrators.',
              ),
              _PolicySection(
                title: 'Data Security',
                content: 'We work hard to protect our users from unauthorized access to or unauthorized alteration, disclosure, or destruction of information we hold.',
              ),
              _PolicySection(
                title: 'Your Rights',
                content: 'You have the right to access, correct, or delete your personal information. You can also object to our processing of your personal information.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}