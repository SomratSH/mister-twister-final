import 'package:flutter/material.dart';
import 'package:mister_twister/common/models/user_type.dart';

import '../../../../../../common/styles/app_colors.dart';

class ProfileInfoWidget extends StatefulWidget {
  final UserRole userRole;
  final String? initialName;
  final String? initialImageUrl;
  final VoidCallback onNext;

  const ProfileInfoWidget({
    super.key,
    this.initialName,
    this.initialImageUrl,
    required this.userRole,
    required this.onNext,
  });

  @override
  State<ProfileInfoWidget> createState() => _ProfileInfoWidgetState();
}

class _ProfileInfoWidgetState extends State<ProfileInfoWidget> {
  late TextEditingController _nameController;
  String? _selectedImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedImageUrl = widget.initialImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _pickImage() {
    // Placeholder for image picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedImageUrl = 'https://i.pravatar.cc/300?img=48';
                });
              },
            ),
            ListTile(
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedImageUrl = 'https://i.pravatar.cc/300?img=49';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (_nameController.text.isNotEmpty) {
      widget.onNext();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Title
          const Text(
            'Update Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          const Text(
            'Add your name and profile picture',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 40),

          // Profile Picture
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryPink.withOpacity(0.3),
                      width: 2,
                    ),
                    gradient: AppColors.pinkGradient,
                  ),
                  child: _selectedImageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            _selectedImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person_outline_rounded,
                                size: 60,
                                color: Colors.white,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.person_outline_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.pinkGradient,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowPinkDark,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Name Input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Full Name',
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
                  border: Border.all(
                    color: AppColors.primaryPink.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrayLight,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primaryPink,
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Next Button
          GestureDetector(
            onTap: _handleNext,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                  'Continue',
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
        ],
      ),
    );
  }
}
