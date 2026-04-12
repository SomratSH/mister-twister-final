import 'package:flutter/material.dart';
import 'package:mister_twister/presentation/screens/private/common/settings/controllers/settings_controller.dart';
import 'package:mister_twister/presentation/screens/private/common/web_scoket/driver_socket_provider.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:mister_twister/presentation/screens/private/drivers/settings/controllers/settings_controller.dart';
import 'package:provider/provider.dart';
import '../../../../../../../common/styles/app_colors.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   // Load the profile data when the screen initializes
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<DriverSettingsProvider>().getDriverProfile();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<DriverSettingsProvider>();
    final orderController = context.watch<OrdersController>();
    final driver = profileProvider.driverProfileModel;

    // Loading State
    if (profileProvider.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgBlue,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => profileProvider.getDriverProfile(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.blueGradient,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.local_convenience_store_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driver.user == null
                                        ? "N/A"
                                        : driver.user!.name ?? "N/A",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    driver.user?.userType ?? 'Vendor Dashboard',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Driver Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child:
                                  driver.image != null &&
                                      driver.image!.isNotEmpty
                                  ? Image.network(
                                      driver.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => Image.network(
                                            "https://static.vecteezy.com/system/resources/thumbnails/004/511/281/small/default-avatar-photo-placeholder-profile-picture-vector.jpg",
                                          ),
                                    )
                                  : Center(
                                      child: Text(
                                        driver.user?.name
                                                ?.substring(0, 1)
                                                .toUpperCase() ??
                                            'M',
                                        style: const TextStyle(
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
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
                                    driver.user?.name ?? 'Loading...',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ID: #${driver.id ?? "0"}\n${driver.user?.email ?? ""}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Online status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: (driver.isOnline ?? false)
                                    ? Colors.green
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                (driver.isOnline ?? false)
                                    ? '● Online'
                                    : '● Offline',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Online Status Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (driver.isOnline ?? false)
                          ? Colors.green
                          : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          (driver.isOnline ?? false)
                              ? Icons.check_circle_rounded
                              : Icons.offline_bolt_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (driver.isOnline ?? false)
                                    ? 'You\'re Online!'
                                    : 'You\'re Offline',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (driver.isOnline ?? false)
                                    ? 'Customers can see your location'
                                    : 'Enable shift to receive requests',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: driver.isOnline ?? false,
                          onChanged: (value) async {
                            await profileProvider.updateStatus(value, context);
                            // implement toggleStatus(value) in your Provider
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.green.shade900,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildStatCard(
                            icon: Icons.shopping_bag_rounded,
                            iconColor: AppColors.primaryBlue,
                            title: '${driver.summary?.ordersToday ?? 0}',
                            subtitle: 'Orders Today',
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            icon: Icons.attach_money_rounded,
                            iconColor: Colors.green,
                            title:
                                '\$${driver.summary?.totalRevenueToday ?? 0}',
                            subtitle: 'Total Revenue',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildStatCard(
                            icon: Icons.people_rounded,
                            iconColor: Colors.amber,
                            title: '${driver.summary?.totalCustomers ?? 0}',
                            subtitle: 'Customers',
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            icon: Icons.timer_rounded,
                            iconColor: Colors.purple,
                            title: '${driver.summary?.onlineTime ?? 0}h',
                            subtitle: 'Online Time',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Active Requests
                _buildSectionHeader(
                  'Active Requests',
                  '${orderController.orders.where((o) => o.status == 'driver_request_sent').length} customers waiting',
                ),

                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(orderController.orders.length, (
                      index,
                    ) {
                      if (orderController.orders[index].status == "pending") {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildRequestItem(
                            'John Johnson',
                            '0.8 mi • 5 min',
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Completed
                _buildSectionHeader(
                  'Recent Completed Orders',
                  'Success history',
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(
                      orderController.orders.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: _buildOrderItem(
                          orderController.orders[index].userName,
                          '\$24.50',
                          '12h ago',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       title,
          //       style: const TextStyle(
          //         color: AppColors.textDark,
          //         fontWeight: FontWeight.w700,
          //         fontSize: 16,
          //       ),
          //     ),
          //     Container(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 12,
          //         vertical: 6,
          //       ),
          //       decoration: BoxDecoration(
          //         gradient: AppColors.blueGradient,
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: const Text(
          //         'View all',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.w600,
          //           fontSize: 12,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textGray,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 24)),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textGray,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItem(String name, String distance) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
              ),
            ),
            child: const Center(
              child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  distance,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textGrayLight,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String amount, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_bag_rounded,
                color: Colors.green,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
