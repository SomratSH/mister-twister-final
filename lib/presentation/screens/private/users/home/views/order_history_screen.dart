import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mister_twister/common/styles/app_colors.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data: list of groups, each with a date and a list of orders
    final List<OrderGroup> orderGroups = [
      OrderGroup(
        date: 'Today',
        orders: [
          OrderItem(
            title: 'Classic Vanilla Cone',
            description: 'Creamy vanilla soft serve in a crispy cone',
            price: '\$3.99',
            image:
                'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=300&h=300&fit=crop',
          ),
          OrderItem(
            title: 'Chocolate Dream',
            description: 'Rich chocolate ice cream with fudge swirl',
            price: '\$4.49',
            image:
                'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=300&h=300&fit=crop',
          ),
        ],
      ),
      OrderGroup(
        date: 'Yesterday',
        orders: [
          OrderItem(
            title: 'Strawberry Bliss',
            description: 'Fresh strawberry ice cream with real fruits',
            price: '\$4.99',
            image:
                'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=300&h=300&fit=crop',
          ),
        ],
      ),
      OrderGroup(
        date: 'Nov 28, 2025',
        orders: [
          OrderItem(
            title: 'Mint Chocolate Chip',
            description: 'Cool mint with chocolate chunks',
            price: '\$4.29',
            image:
                'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=300&h=300&fit=crop',
          ),
          OrderItem(
            title: 'Vanilla Sundae',
            description: 'Classic vanilla with toppings',
            price: '\$5.99',
            image:
                'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=300&h=300&fit=crop',
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPink,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textDark,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Previous Order Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryPink.withOpacity(0.25),
                        width: 1.5,
                      ),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.primaryPink,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Orders List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: orderGroups.length,
                itemBuilder: (context, groupIndex) {
                  final group = orderGroups[groupIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Header
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          group.date,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      // Order Cards for this date
                      ...List.generate(group.orders.length, (index) {
                        final order = group.orders[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildOrderCard(order),
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowPinkLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              order.image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  order.description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  order.price,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryPink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderGroup {
  final String date;
  final List<OrderItem> orders;
  OrderGroup({required this.date, required this.orders});
}

class OrderItem {
  final String title;
  final String description;
  final String price;
  final String image;

  OrderItem({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });
}
