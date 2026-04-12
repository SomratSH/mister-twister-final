import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../common/styles/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Effective Date: March 2026',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Your privacy is important to us. This policy explains how we collect, use, and protect your personal data.',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            _buildSection(
              '1. Information We Collect',
              'We collect information you provide directly to us, such as your name, email address, phone number, and profile picture. We also collect vehicle details and insurance documentation required for your role as a driver.',
            ),
            
            _buildSection(
              '2. Location Data',
              'To provide efficient routing and service tracking, we collect precise location data from your mobile device while the app is running in the foreground or background. You can disable this in your device settings, but it may limit app functionality.',
            ),

            _buildSection(
              '3. How We Use Information',
              'We use the collected data to: \n• Process your registration and verify your identity.\n• Facilitate communication between you and the service platform.\n• Monitor and improve the performance of our application.\n• Comply with legal obligations.',
            ),

            _buildSection(
              '4. Data Sharing',
              'We do not sell your personal data to third parties. We may share information with service providers who perform services on our behalf, or when required by law to comply with legal processes.',
            ),

            _buildSection(
              '5. Data Security',
              'We implement industry-standard security measures to protect your data. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
            ),

            _buildSection(
              '6. Your Rights',
              'You have the right to access, correct, or delete your personal information at any time through the "Edit Profile" section of the application or by contacting our support team.',
            ),

            const SizedBox(height: 40),
            
            // Footer Contact Note
            Center(
              child: Column(
                children: [
                  const Text(
                    'Questions about our policy?',
                    style: TextStyle(color: AppColors.textGray, fontSize: 13),
                  ),
                  TextButton(
                    onPressed: () {
                      // Logic to open mail or support chat
                    },
                    child: const Text(
                      'Contact Privacy Support',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textGray,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}