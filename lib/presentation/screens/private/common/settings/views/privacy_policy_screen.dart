import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/styles/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Switched to Blue Background
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
            fontWeight: FontWeight.w700, // Slightly bolder for Blue theme
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  // Switched to Blue Shadow
                  color: AppColors.shadowBlue.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header (Optional addition for better UI)
                const Row(
                  children: [
                    Icon(Icons.security_rounded, color: AppColors.primaryBlue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Data Protection Policy',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32, thickness: 1, color: AppColors.bgBlue),
                
                const Text(
                  '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent tincidunt tincidunt nulla, vitae consequat purus tempor vitae. Maecenas sem eros, suscipit sed pharetra bibendum, congue non nisl. Duis blandit dui quis tortor iaculis, eget rhoncus turpis semper. Ut faucibus ut elit rhoncus volutpat. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque convallis sapien sit amet diam tristique posuere. Vivamus sollicitudin dui sit amet dui hendrerit, imperdiet finibus nulla condimentum. Maecenas at blandit turpis. Fusce augue nisi, mollis nec elementum a, tincidunt ut sem. Nullam finibus laoreet ullamcorper. Sed facilisis, mi euismod sodales pellentesque, mi enim mollis orci, sed dapibus neque magna rutrum leo. Sed viverra feugiat turpis. Aliquam feugiat libero et pharetra convallis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent tincidunt tincidunt nulla, vitae consequat purus tempor vitae. Maecenas sem eros, suscipit sed pharetra bibendum, congue non nisl. Duis blandit dui quis tortor iaculis, eget rhoncus turpis semper. Ut faucibus ut elit rhoncus volutpat. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque convallis sapien sit amet diam tristique posuere. Vivamus sollicitudin dui sit amet dui hendrerit, imperdiet finibus nulla condimentum. Maecenas at blandit turpis. Fusce augue nisi, mollis nec elementum a, tincidunt ut sem. Nullam finibus laoreet ullamcorper. Sed facilisis, mi euismod sodales pellentesque, mi enim mollis orci, sed dapibus neque magna rutrum leo. Sed viverra feugiat turpis. Aliquam feugiat libero et pharetra convallis.''',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 14, // Standard legal text size
                    height: 1.7,  // Increased line height for blue theme readability
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.justify,
                ),
                
                const SizedBox(height: 20),
                
                // Professional Footer
                const Center(
                  child: Text(
                    '© 2026 Mister Twister. All rights reserved.',
                    style: TextStyle(
                      color: AppColors.textGray,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
