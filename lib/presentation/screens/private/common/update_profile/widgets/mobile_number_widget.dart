import 'package:flutter/material.dart';

import '../../../../../../common/models/user_type.dart';
import '../../../../../../common/styles/app_colors.dart';
import '../../../../../../common/widgets/otp_modal.dart';

class MobileNumberWidget extends StatefulWidget {
  final UserRole userRole;
  final String? initialMobile;
  final VoidCallback onPrevious;
  final VoidCallback onComplete;

  const MobileNumberWidget({
    super.key,
    this.initialMobile,
    required this.userRole,
    required this.onPrevious,
    required this.onComplete,
  });

  @override
  State<MobileNumberWidget> createState() => _MobileNumberWidgetState();
}

class _MobileNumberWidgetState extends State<MobileNumberWidget> {
  late TextEditingController _mobileController;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(text: widget.initialMobile ?? '');
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _handleVerifyMobile() {
    if (_mobileController.text.length >= 10) {
      // Show OTP modal
      OtpVerificationModal.show(
        context,
        email: _mobileController.text,
        onVerified: () {
          setState(() {
            _isVerified = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mobile number verified successfully'),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid mobile number')),
      );
    }
  }

  void _handleComplete() {
    if (_isVerified) {
      widget.onComplete();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify your mobile number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.userRole == UserRole.customer
        ? AppColors.primaryPink
        : AppColors.primaryBlue;
    final gradient = widget.userRole == UserRole.customer
        ? AppColors.pinkGradient
        : AppColors.blueGradient;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Title
          const Text(
            'Update Phone Number',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          const Text(
            'Add or update your mobile number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 40),

          // Mobile Icon
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowPinkDark,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.phone_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),

          // Mobile Number Input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mobile Number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: color.withOpacity(0.4), width: 2),
                ),
                child: TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  enabled: !_isVerified,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your mobile number',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrayLight,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.phone_rounded, color: color, size: 20),
                    ),
                    suffixIcon: _isVerified
                        ? const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Verify Status
          if (_isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Mobile number verified',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: _handleVerifyMobile,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: color, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tap to verify your mobile number with OTP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 40),

          // Buttons Row
          Row(
            children: [
              // Back Button
              Expanded(
                child: GestureDetector(
                  onTap: widget.onPrevious,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: color, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Complete Button
              Expanded(
                child: GestureDetector(
                  onTap: _handleComplete,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: _isVerified
                          ? gradient
                          : LinearGradient(
                              colors: [
                                color.withOpacity(0.5),
                                AppColors.primaryBlueDark.withOpacity(0.5),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        if (_isVerified)
                          BoxShadow(
                            color: AppColors.shadowPinkDark,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Complete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
