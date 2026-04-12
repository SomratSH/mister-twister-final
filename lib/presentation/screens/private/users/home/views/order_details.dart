import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:provider/provider.dart';

class PreviousOrdersScreen extends StatelessWidget {
  const PreviousOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrdersController>();
    final deliveredOrders = controller.orders
        .where((o) => o.status == 'delivered')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bgPink,
      appBar: AppBar(
        title: const Text('Previous Orders'),
        backgroundColor: AppColors.bgPink,
      ),
      body: deliveredOrders.isEmpty
          ? const Center(child: Text('No previous orders found',style: TextStyle(color: Colors.black),))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: deliveredOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = deliveredOrders[index];
                // final total = calculateOrderTotal(order['items']);
                final date = DateFormat(
                  'dd MMM yyyy, hh:mm a',
                ).format(DateTime.parse(order.createdAt));

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Order ID + Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.orderId}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Delivered',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // /// Items
                      // Text(
                      //   order['items']
                      //       .map(
                      //         (e) =>
                      //             '${e['product']['name']} x${e['quantity']}',
                      //       )
                      //       .join(', '),
                      //   style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      // ),
                      const SizedBox(height: 10),

                      /// Price + Date
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       '\$${total.toStringAsFixed(2)}',
                      //       style: const TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     Text(
                      //       date,
                      //       style: TextStyle(
                      //         color: Colors.grey[600],
                      //         fontSize: 12,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Text(
                        date,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
