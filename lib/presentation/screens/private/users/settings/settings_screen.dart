import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/presentation/screens/private/users/settings/setting_customer_controller.dart';
import 'package:provider/provider.dart'; // Added Provider
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/models/user_type.dart';
import '../../../../../core/routes/app_routes.dart';
// Import your controller


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingCustomerController>().getCustomerProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Watch the controller for data changes
    final customerProvider = context.watch<SettingCustomerController>();
    final customer = customerProvider.customerProfile;
    
    // Get role from arguments (default to 'user')
    final UserRole role = Get.arguments ?? UserRole.customer;
    final bool isDriver = role == UserRole.driver;

    final Color primaryColor = isDriver ? AppColors.primaryBlue : AppColors.primaryPink;
    final Color bgColor = isDriver ? Colors.blue.shade50 : AppColors.bgPink;
    final LinearGradient gradient = isDriver ? AppColors.blueGradient : AppColors.pinkGradient;

    // Show loading state
    if (customerProvider.isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(child: CircularProgressIndicator(color: AppColors.primaryPink)),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => customerProvider.getCustomerProfile(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Profile Settings', primaryColor),
                const SizedBox(height: 12),
                
                // 2. Pass the dynamic customer data to the profile card
                _buildProfileCard(primaryColor, isDriver, context, customer),
                
                const SizedBox(height: 24),

                if (isDriver) ...[
                  _buildSectionHeader('Shift & Availability', primaryColor),
                  const SizedBox(height: 12),
                  _buildShiftAvailabilityCard(primaryColor),
                  const SizedBox(height: 24),
                ],

                _buildSectionHeader('Help & Support', primaryColor),
                const SizedBox(height: 12),
                _buildHelpSupportCard(primaryColor),
                const SizedBox(height: 24),

                // Logout button
                GestureDetector(
                  onTap: () async{
                    showLogoutDialog(context, gradient, isDriver);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      isDriver ? 'End Shift & Logout' : 'Logout',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    Color primaryColor,
    bool isDriver,
    BuildContext context,
    dynamic customer, // Added customer data parameter
  ) {
    final user = customer.user;
    final String displayName = user?.name ?? 'No Name';
    final String displayEmail = user?.email ?? 'No Email';
    final String displayPhone = user?.phoneNumber ?? 'No Phone';
    // Use first address if available
    final String displayAddress = (customer.addresses != null && customer.addresses!.isNotEmpty) 
        ? customer.addresses![0].label ?? 'N/A' 
        : 'No address saved';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Dynamic Avatar (Network Image or Initials)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                ),
                child: ClipOval(
                  child: customer.image != null && customer.image!.isNotEmpty
                      ? Image.network(customer.image!, fit: BoxFit.cover)
                      : Center(
                          child: Text(
                            displayName.substring(0, 1).toUpperCase(),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primaryColor),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDriver ? 'vendorID: #${customer.id}' : 'User Account',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push(RoutePath.editDriverProfile), // Adjust path as needed
                icon: Icon(Icons.edit_rounded, color: primaryColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.textGrayLight, height: 1),
          const SizedBox(height: 12),
          _buildInfoRow('Name', displayName),
          const SizedBox(height: 12),
          _buildInfoRow(isDriver ? 'Role' : 'Email', isDriver ? (user?.userType ?? 'Vendor') : displayEmail),
          const SizedBox(height: 12),
          _buildInfoRow('Phone', displayPhone),
          const SizedBox(height: 12),
          _buildInfoRow('Address', displayAddress),
          const SizedBox(height: 12),
          
          InkWell(
            onTap: () => context.push(RoutePath.changePassword),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods (_buildSectionHeader, _buildInfoRow, etc.) stay largely the same...
  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textGray)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }
  
  // Include your help support, shift card, and other UI helpers here as previously defined.
  Widget _buildHelpSupportCard(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoTile('Terms & Conditions', primaryColor, onTap: () => context.push(RoutePath.termsCondition)),
          const SizedBox(height: 24),
          _buildInfoTile('Privacy Policy', primaryColor, onTap: () => context.push(RoutePath.privacyPolicy)),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, Color primaryColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          Icon(Icons.chevron_right_rounded, size: 20, color: primaryColor),
        ],
      ),
    );
  }

  Widget _buildShiftAvailabilityCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text("Shift info here..."),
    );
  }
}
void showLogoutDialog(BuildContext context, Gradient gradient, bool isDriver) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 50,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),

              Text(
                isDriver ? "End Shift?" : "Logout?",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                isDriver
                    ? "Are you sure you want to end your shift and logout?"
                    : "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Confirm Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();

                        Navigator.pop(context); // close dialog
                        context.go(RoutePath.login);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: gradient, // 👈 your same gradient
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Yes, Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}