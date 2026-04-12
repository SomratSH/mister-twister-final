import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // Added package
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/core/api_service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../../common/styles/app_colors.dart';
import '../controllers/settings_controller.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late String _userEmail;

  // Variables to hold new image data
  File? _pickedImage;
  bool _isUploadingNewImage = false;
  String? _currentNetworkImageUrl;

  @override
  void initState() {
    super.initState();
    final driver = context.read<DriverSettingsProvider>().driverProfileModel;

    _nameController = TextEditingController(text: driver.user?.name ?? "");
    _phoneController = TextEditingController(
      text: driver.user?.phoneNumber?.toString() ?? "",
    );
    _userEmail = driver.user?.email ?? "No Email Found";

    // Set current image from model if exists
    _currentNetworkImageUrl = driver.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- Photo Picker Logic ---

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512, // Resize for faster upload
        imageQuality: 75, // Compress slightly
      );

      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
          _currentNetworkImageUrl =
              null; // Clear network image to show local preview
        });
      }
    } catch (e) {
      Get.snackbar(
        "Permission Denied",
        "We need permission to access ${source == ImageSource.camera ? 'Camera' : 'Photos'}. Please enable in iOS Settings.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption(Icons.camera_alt_rounded, 'Camera', () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  }),
                  _buildPickerOption(
                    Icons.photo_library_rounded,
                    'Gallery',
                    () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // --- Build UI ---

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DriverSettingsProvider>();
    final driver = provider.driverProfileModel;

    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- NEW Profile Picture Section ---
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          color: AppColors.primaryBlue.withOpacity(0.05),
                        ),
                        child: ClipOval(
                          child: _pickedImage != null
                              ? Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.cover,
                                ) // Local Preview
                              : (_currentNetworkImageUrl != null &&
                                    _currentNetworkImageUrl!.isNotEmpty)
                              ? Image.network(
                                  // Network Image
                                  _currentNetworkImageUrl!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildFallbackAvatar(driver.user?.name),
                                )
                              : _buildFallbackAvatar(
                                  driver.user?.name,
                                ), // Fallback Initial
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImagePickerOptions,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ------------------------------------
                const SizedBox(height: 32),

                _buildDisabledField(
                  label: 'Email Address',
                  value: _userEmail,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),

                _buildEditableField(
                  label: 'Full Name',
                  controller: _nameController,
                  icon: Icons.person_outline_rounded,
                  hint: 'Enter your full name',
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildEditableField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  icon: Icons.phone_android_rounded,
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Phone number is required';
                    return null;
                  },
                ),

                const SizedBox(height: 48),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (provider.isLoading || _isUploadingNewImage)
                        ? null
                        : _handleUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: (provider.isLoading || _isUploadingNewImage)
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
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

  // --- Helpers ---

  Widget _buildFallbackAvatar(String? name) {
    return Center(
      child: Text(
        name?.substring(0, 1).toUpperCase() ?? "D",
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w700,
          fontSize: 40,
        ),
      ),
    );
  }

  Widget _buildPickerOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // Original Widget Helpers (Unchanged)
  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textGrayLight,
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisabledField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGray,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textGray, size: 20),
              const SizedBox(width: 12),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.textGrayLight,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

void _handleUpdate() async {
    // Basic form validation
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DriverSettingsProvider>();
    final driver = provider.driverProfileModel;
    final ApiService apiService = ApiService();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("authToken");

    // 1. Identify what changed
    final String newName = _nameController.text.trim();
    final String newPhone = _phoneController.text.trim();
    
    final bool isNameChanged = newName != (driver.user?.name ?? "");
    final bool isPhoneChanged = newPhone != (driver.user?.phoneNumber?.toString() ?? "");
    final bool isPhotoChanged = _pickedImage != null;

    // 2. If nothing changed, just go back
    if (!isNameChanged && !isPhoneChanged && !isPhotoChanged) {
      context.pop();
      return;
    }

    setState(() => _isUploadingNewImage = true);

    try {
      // 3. Build the dynamic User payload
      Map<String, dynamic> userPayload = {};
      if (isNameChanged) userPayload["name"] = newName;
      if (isPhoneChanged) userPayload["phone_number"] = newPhone;

      // 4. Build the final body
      Map<String, dynamic> finalBody = {};
      if (userPayload.isNotEmpty) {
        finalBody["user"] = userPayload;
      }

      // 5. Send the request
      // Note: We pass the image only if isPhotoChanged is true
      final response = await apiService.patchData(
        "/drivers/me/",
        finalBody,
        authToken: token,
        image: isPhotoChanged ? _pickedImage : null,
      );

      if (response.isNotEmpty) {
        // Refresh the profile in the provider so the UI updates globally
        await provider.getDriverProfile();


         CustomSnackbar.show(context, message: "Profile updated successfully", backgroundColor: Colors.green);

     
        
        if (mounted) context.pop();
      }
    } catch (e) {
            CustomSnackbar.show(context, message: "Could not update profile. Please try again.", backgroundColor: Colors.red);
      
    } finally {
      if (mounted) setState(() => _isUploadingNewImage = false);
    }
  }
}
