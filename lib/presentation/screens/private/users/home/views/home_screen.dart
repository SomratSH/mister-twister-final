import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/core/routes/app_routes.dart';
import 'package:mister_twister/data/model/order_json.dart';
import 'package:mister_twister/domain/entities/order_model.dart';
import 'package:mister_twister/presentation/screens/private/common/web_scoket/global_web_scoket.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:mister_twister/presentation/screens/private/users/settings/setting_customer_controller.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';

import '../../../../../../common/styles/app_colors.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch both providers
    final orderController = context.watch<OrdersController>();
    final customerProvider = context.watch<SettingCustomerController>();

    // Get customer data
    final user = customerProvider.customerProfile.user;
    final String profileImage = customerProvider.customerProfile.image ?? '';
    final String userName = user?.name ?? 'Guest User';

    const Color bgColor = AppColors.bgPink;
    const LinearGradient pinkGradient = AppColors.pinkGradient;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Refresh both profile and orders
                  await customerProvider.getCustomerProfile();
                  return orderController.getOrder();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section with dynamic data
                      _buildHeaderSection(userName, profileImage),
                      const SizedBox(height: 32),
                      // Nearest Truck Card
                      // _buildNearestTruckCard(
                      //   pinkGradient,
                      //   orderController,
                      //   context,
                      // ),
                      // const SizedBox(height: 24),

                      // Only show running order card if onProgressOrder is not null
                      (orderController.onProgressOrder != null &&
                              orderController.onProgressOrder!.items != null &&
                              orderController
                                  .onProgressOrder!
                                  .items!
                                  .isNotEmpty)
                          ? _buildRunningOrderCard(
                              onTap: () {
                                // Action logic
                              },
                              orderModel: orderController.onProgressOrder!,
                              controller: orderController,
                            )
                          : Center(
                            child: Text(
                                "No Ruuning Order Found",
                                style: TextStyle(color: Colors.black),
                              ),
                          ),
                      const SizedBox(height: 16),
                      _buildOptionTile(
                        'Previous Order Details',
                        onTap: () {
                          context.push(RoutePath.previousOrders);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Floating Action Button
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Center(
                child: _buildFloatingPillButton(
                  pinkGradient,
                  Icons.receipt_long,
                  'Ice Cream ASAP!',
                  () {
                    // Get.snackbar(
                    //   "Alert!",
                    //   'You will receive your ice cream soon.',
                    //   snackPosition: SnackPosition.TOP,
                    //   backgroundColor: AppColors.primaryPink,
                    // );

                    
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String name, String imageUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryPink.withOpacity(0.3),
                  width: 2,
                ),
                gradient: AppColors.pinkGradient,
              ),
              child: Center(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgPink,
                  ),
                  child: Center(
                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              // Fallback if network image fails
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildInitialAvatar(name),
                            )
                          : _buildInitialAvatar(name),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name, // Dynamic Name
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryPink.withOpacity(0.25),
              width: 1.5,
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primaryPink,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  // Helper for Initials if image is missing
  Widget _buildInitialAvatar(String name) {
    return Container(
      color: AppColors.primaryPink.withOpacity(0.1),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: const TextStyle(
            color: AppColors.primaryPink,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // ... (Keep all other _build methods exactly as they were in your code)

  Widget _buildNearestTruckCard(
    LinearGradient gradient,
    OrdersController controller,
    BuildContext context,
  ) {
    final data = controller.getActiveOrder();
    return InkWell(
      onTap: () {
        if (data != null) {
          context.push(RoutePath.orderTracking, extra: data.orderId.toString());
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowPinkLight,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: controller.getActiveOrder() == null
            ? Center(
                child: Text(
                  "No Order Found",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGray,
                  ),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?.driverName ?? 'Ice cream Truck',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Manhattan, New York',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGray,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Text(
                              '0.8 mi',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'away',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textGray,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              '• 5 min',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowPinkDark,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.navigation_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildOptionTile(String title, {required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowPinkLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryPinkDark,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingPillButton(
    LinearGradient gradient,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowPinkDark,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunningOrderCard({
    required VoidCallback onTap,
    required OrderJson orderModel,
    required OrdersController controller,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowPinkLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Order',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGray,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '#ORD-${orderModel.id == null ? orderModel.id : ""}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgPink,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryPink, width: 1),
                  ),
                  child: const Text(
                    'In Progress',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.textGrayLight, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOrderDetailItem(
                  icon: Icons.location_on_rounded,
                  label: 'Location',
                  value: orderModel.address.toString() ?? "N/A",
                ),
                _buildOrderDetailItem(
                  icon: Icons.timer_rounded,
                  label: 'ETA',
                  value: "10",
                ),
                _buildOrderDetailItem(
                  icon: Icons.payments_rounded,
                  label: 'Total',
                  value: '\$${controller.getOnProgressOrderTotal()}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.track_changes_rounded,
                    size: 16,
                    color: AppColors.primaryPink,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Track Order',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryPink,
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

  Widget _buildOrderDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryPink),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
