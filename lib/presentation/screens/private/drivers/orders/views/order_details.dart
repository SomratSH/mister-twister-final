import 'package:flutter/material.dart';

class OrderDetailsDemoScreen extends StatelessWidget {
  const OrderDetailsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Demo data
    const orderNumber = '#ORD-2026-00123';
    const orderStatus = 'Out for Delivery';
    const orderCost = 420.50;
    const orderDate = '20 Jan 2026, 08:56 AM';
    const deliveryAddress = 'Banani, Dhaka, Bangladesh';

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔖 Order Number Card
            _InfoCard(
              title: 'Order Number',
              value: orderNumber,
              icon: Icons.receipt_long,
            ),

            const SizedBox(height: 12),

            /// 📦 Status + Cost
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    title: 'Status',
                    value: orderStatus,
                    icon: Icons.local_shipping,
                    valueColor: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    title: 'Total Cost',
                    value: '৳ ${orderCost.toStringAsFixed(2)}',
                    icon: Icons.payments,
                    valueColor: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🕒 Order Date
            _InfoCard(
              title: 'Order Date',
              value: orderDate,
              icon: Icons.access_time,
            ),

            const SizedBox(height: 12),

            /// 📍 Address
            _InfoCard(
              title: 'Delivery Address',
              value: deliveryAddress,
              icon: Icons.location_on,
            ),

            const Spacer(),

            /// 🔘 Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Track Order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🧱 Reusable Info Card
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? Colors.black,
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
