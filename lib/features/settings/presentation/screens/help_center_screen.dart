import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart'; // Add this import

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context); // Add this line

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
  title: Text(
    l10n.help_center_title,
    style: const TextStyle(
      color: Colors.white, // Explicitly set text color
    ),
  ),
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
                l10n.getting_started, // Updated
                l10n.getting_started_desc, // Updated
                Icons.play_arrow,
                () {
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
                l10n.faq, // Updated
                l10n.faq_desc, // Updated
                Icons.question_answer,
                () {
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
                l10n.contact_support, // Updated
                l10n.contact_support_desc, // Updated
                Icons.contact_support,
                () {
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
                l10n.privacy_policy, // Updated
                l10n.privacy_policy_desc, // Updated
                Icons.privacy_tip,
                () {
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
    final l10n = AppLocalizations.of(context); // Add this line

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: Text(l10n.getting_started,
        style: TextStyle(color: Colors.white),), // Updated
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
            children: [
              _GuideStep(
                step: '1',
                title: l10n.guide_step_1, // Updated
                description: l10n.guide_step_1_desc, // Updated
              ),
              _GuideStep(
                step: '2',
                title: l10n.guide_step_2, // Updated
                description: l10n.guide_step_2_desc, // Updated
              ),
              _GuideStep(
                step: '3',
                title: l10n.guide_step_3, // Updated
                description: l10n.guide_step_3_desc, // Updated
              ),
              _GuideStep(
                step: '4',
                title: l10n.guide_step_4, // Updated
                description: l10n.guide_step_4_desc, // Updated
              ),
              _GuideStep(
                step: '5',
                title: l10n.guide_step_5, // Updated
                description: l10n.guide_step_5_desc, // Updated
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
    final l10n = AppLocalizations.of(context); // Add this line

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: Text(l10n.faq,
        style: TextStyle(color: Colors.white),), // Updated
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
            children: [
              _FAQItem(
                question: l10n.faq_question_1, // Updated
                answer: l10n.faq_answer_1, // Updated
              ),
              _FAQItem(
                question: l10n.faq_question_2, // Updated
                answer: l10n.faq_answer_2, // Updated
              ),
              _FAQItem(
                question: l10n.faq_question_3, // Updated
                answer: l10n.faq_answer_3, // Updated
              ),
              _FAQItem(
                question: l10n.faq_question_4, // Updated
                answer: l10n.faq_answer_4, // Updated
              ),
              _FAQItem(
                question: l10n.faq_question_5, // Updated
                answer: l10n.faq_answer_5, // Updated
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
    final l10n = AppLocalizations.of(context); // Add this line

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
  title: Text(
    l10n.contact_support,
    style: TextStyle(color: Colors.white), // Add text color here
  ),
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
              Text(
                l10n.contact_get_in_touch, // Updated
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(221, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.contact_help_desc, // Updated
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              _buildContactOption(
                context,
                icon: Icons.email,
                title: l10n.contact_email_support, // Updated
                subtitle: l10n.contact_email, // Updated
                onTap: () {
                  // Implement email functionality
                },
              ),
              _buildContactOption(
                context,
                icon: Icons.chat,
                title: l10n.contact_live_chat, // Updated
                subtitle: l10n.contact_chat_hours, // Updated
                onTap: () {
                  // Implement chat functionality
                },
              ),
              
              const SizedBox(height: 32),
              Text(
                l10n.contact_send_message, // Updated
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: l10n.contact_your_email, // Updated
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.contact_message, // Updated
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.contact_message_sent), // Updated
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 71, 134, 145),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    l10n.contact_send_button, // Updated
                    style: const TextStyle(
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

  Widget _buildContactOption(
    BuildContext context, // Add context parameter
    {
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
    final l10n = AppLocalizations.of(context); // Add this line

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        title: Text(l10n.privacy_policy,
        style: TextStyle(color: Colors.white),), // Updated
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
            children: [
              _PolicySection(
                title: l10n.privacy_info_collected, // Updated
                content: l10n.privacy_info_collected_desc, // Updated
              ),
              _PolicySection(
                title: l10n.privacy_info_usage, // Updated
                content: l10n.privacy_info_usage_desc, // Updated
              ),
              _PolicySection(
                title: l10n.privacy_info_sharing, // Updated
                content: l10n.privacy_info_sharing_desc, // Updated
              ),
              _PolicySection(
                title: l10n.privacy_data_security, // Updated
                content: l10n.privacy_data_security_desc, // Updated
              ),
              _PolicySection(
                title: l10n.privacy_your_rights, // Updated
                content: l10n.privacy_your_rights_desc, // Updated
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