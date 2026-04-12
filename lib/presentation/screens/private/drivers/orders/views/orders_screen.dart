import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/retry.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:mister_twister/utils/utlis.dart';
import 'package:provider/provider.dart';
import '../../../../../../../common/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:mister_twister/utils/utlis.dart';
import 'package:provider/provider.dart';
import '../../../../../../../common/styles/app_colors.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrdersController>();

    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlue,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Requests',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${controller.orders.length} total requests',
              style: TextStyle(
                color: AppColors.textGray,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: controller.getOrder,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// FILTER
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'Pending (${controller.getPendingOrdersCount()})',
                        'driver_request_sent',
                        controller,
                      ),
                      const SizedBox(width: 10),
                      _buildFilterChip(
                        'Active (${controller.getActiveOrdersCount()})',
                        'out_for_delivery',
                        controller,
                      ),
                      const SizedBox(width: 10),
                      _buildFilterChip(
                        'Completed (${controller.getCompletedOrdersCount()})',
                        'delivered',
                        controller,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// LIST
                Column(
                  children: controller.orders.map((order) {

                    if (controller.selectedFilter == 'driver_request_sent' &&
                        order.status == 'driver_request_sent') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _buildPendingOrderCard(
                          context: context,
                          controller: controller,
                          id: order.orderId,
                          name: order.userName ?? 'John Doe',
                          address: order.address ?? 'Unknown address',
                          distance: order.phone ?? '0.0 mi away',
                          time: timeAgo(order.createdAt) ?? 'Just now',
                          lat: order.userLat,
                          lng: order.userLng,
                        ),
                      );
                    }

                    else if (controller.selectedFilter == 'out_for_delivery' &&
                        order.status == 'out_for_delivery') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _buildActiveOrderCard(

                          lat: order.userLat,
                          lng: order.userLng,
                          controller: controller,
                          id: order.orderId,
                          name: order.userName ?? 'John Doe',
                          address: order.address ?? 'Unknown address',
                          distance: '0.8 mi away',
                          time: timeAgo(order.createdAt),
                          context: context
                        ),
                      );
                    }

                    else if (controller.selectedFilter == 'delivered' &&
                        order.status == 'delivered') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _buildCompletedOrderCard(
                          context: context,
                          name: order.userName ?? 'John Doe',
                          address: order.address ?? "n/a",
                          amount: '\$24.50',
                        ),
                      );
                    }

                    return const SizedBox.shrink();

                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filterValue, OrdersController controller) {
    final isSelected = controller.selectedFilter == filterValue;

    return GestureDetector(
      onTap: () async {
        controller.setSelectedFilter(filterValue);
        await controller.getOrder();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.blueGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: isSelected
              ? null
              : Border.all(color: AppColors.textGrayLight, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.shadowBlack,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textGray,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ✅ KEEP ALL YOUR EXISTING CARD METHODS SAME (NO CHANGE)


  // Pending Order Card with Location, Decline, and Accept buttons
  Widget _buildPendingOrderCard({
    required int id,
    required String name,
    required String address,
    required String distance,
    required String time,
    required double lat,
    required double lng,
    required OrdersController controller,
    required BuildContext context
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Header with name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withOpacity(0.15),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Distance and time
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.textGray,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                distance,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time_outlined,
                color: AppColors.textGray,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action buttons: Location, Decline, Accept
          Column(
            children: [
              // Location button (full width)
              GestureDetector(
                onTap: () async {
                  // Navigate to user location
                  await openMap(lat, lng);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                    ),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primaryBlue,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'View Location',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Decline and Accept buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          'Declined',
                          'Order declined',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.textGrayLight.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            'Decline',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final response = await controller.acceptOrder(id);
                        await controller.getOrder();
                        CustomSnackbar.show(
                          context,
                          message: "$response",
                          backgroundColor: Colors.green,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: AppColors.blueGradient,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Active Order Card with Location and Complete buttons
  Widget _buildActiveOrderCard({
    required double lat,
    required double lng,
    required int id,
    required String name,
    required String address,
    required String distance,
    required String time,
    required OrdersController controller,
    required BuildContext context
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Header with name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.15),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Distance and time
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.textGray,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                distance,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time_outlined,
                color: AppColors.textGray,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action buttons: Location and Complete
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Navigate to user location
                    await openMap(lat, lng);
                    // Get.snackbar(
                    //   'Navigate',
                    //   'Opening location for $name',
                    //   snackPosition: SnackPosition.BOTTOM,
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                      ),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primaryBlue,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Location',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await controller.markAsDelivered(id);
                    final response = await controller.completeOrder(id);
                    await controller.getOrder();
                    CustomSnackbar.show(
                      context,
                      message: "$response",
                      backgroundColor: Colors.green,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.green.shade700],
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Completed Order Card with Detail button only
  Widget _buildCompletedOrderCard({
    required String name,
    required String address,
    required String amount,
    required BuildContext context
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Header with name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.15),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Completed',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Detail button (full width)
          GestureDetector(
            onTap: () {
              // Get.snackbar(
              //   'Details',
              //   'Showing order details for $name',
              //   snackPosition: SnackPosition.BOTTOM,
              // );
              context.push(RoutePath.orderDetails);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAcceptConfirmationDialog(String customerName) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryBlue,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Accept Order?',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'You are about to accept an order from $customerName. You will start your delivery once confirmed.',
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Buttons
              Column(
                children: [
                  // Accept Button
                  GestureDetector(
                    onTap: () {
                      Get.back(); // Close dialog
                      Get.snackbar(
                        'Success',
                        'Order accepted! Head to the location.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'Yes, Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel Button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
