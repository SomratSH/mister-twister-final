import 'package:flutter/material.dart';
import 'dart:async';
import '../styles/app_colors.dart';

class OtpVerificationModal extends StatefulWidget {
  final String email;
  final VoidCallback? onVerified;

  const OtpVerificationModal({super.key, this.email = '', this.onVerified});

  @override
  State<OtpVerificationModal> createState() => _OtpVerificationModalState();

  // Helper method to show the modal
  static void show(
    BuildContext context, {
    String email = '',
    VoidCallback? onVerified,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          OtpVerificationModal(email: email, onVerified: onVerified),
    );
  }
}

class _OtpVerificationModalState extends State<OtpVerificationModal> {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;
  int _resendTimer = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(4, (_) => TextEditingController());
    _otpFocusNodes = List.generate(4, (_) => FocusNode());
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _handleOtpInput(String value, int index) {
    if (value.length == 1) {
      if (index < 3) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  String _getOtpCode() {
    return _otpControllers.map((c) => c.text).join();
  }

  void _onVerifyOtp() {
    final otp = _getOtpCode();
    debugPrint('Verifying OTP: $otp');
    if (otp.length == 4) {
      // Verify OTP logic here
      Navigator.pop(context);
      widget.onVerified?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 4 digits')),
      );
    }
  }

  void _onResendOtp() {
    if (_resendTimer == 0) {
      // Resend OTP logic here
      _startResendTimer();
      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP resent successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle with email
              Text(
                'Enter the 4-digit code sent to\n${widget.email.isNotEmpty ? widget.email : 'your email'}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpField(index)),
              ),
              const SizedBox(height: 32),

              // Verify Button
              GestureDetector(
                onTap: _onVerifyOtp,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.pinkGradient,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowPinkDark,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Resend OTP Section
              Column(
                children: [
                  const Text(
                    "Didn't receive the code?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _onResendOtp,
                    child: Text(
                      _resendTimer > 0
                          ? 'Resend OTP in ${_resendTimer}s'
                          : 'Resend OTP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _resendTimer > 0
                            ? AppColors.textGrayLight
                            : AppColors.primaryPink,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 60,
      height: 40,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        onChanged: (value) => _handleOtpInput(value, index),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: '',
          hintText: '-',
          hintStyle: const TextStyle(
            color: AppColors.textGrayLight,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.primaryPink,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: AppColors.primaryPink.withOpacity(0.3),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.primaryPink,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ), // Centers content vertically within 60x60 box
        ),
      ),
    );
  }
}
