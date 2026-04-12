import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../common/styles/app_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
          'Terms & Conditions',
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
            // Last Updated Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Last Updated: March 2026',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Please read these terms and conditions carefully before using our service.',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. In addition, when using these particular services, you shall be subject to any posted guidelines or rules applicable to such services.',
            ),
            
            _buildSection(
              '2. Driver Responsibilities',
              'As a registered driver, you agree to maintain a valid driving license and insurance at all times. You are responsible for the safety of your vehicle and compliance with all local traffic laws and regulations.',
            ),

            _buildSection(
              '3. Account Security',
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password.',
            ),

            _buildSection(
              '4. Privacy Policy',
              'Your use of the service is also subject to our Privacy Policy. Please review our Privacy Policy, which also governs the application and informs users of our data collection practices.',
            ),

            _buildSection(
              '5. Limitation of Liability',
              'The service is provided on an "as is" and "as available" basis. We shall not be liable for any direct, indirect, incidental, special, or consequential damages resulting from the use or the inability to use the service.',
            ),

            const SizedBox(height: 40),
            
            // Accept Button (Optional, if this is a first-time setup)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'I Understand',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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