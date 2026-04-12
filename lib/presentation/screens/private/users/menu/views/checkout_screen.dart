import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/controllers/cart_controller.dart';
import 'package:provider/provider.dart';

import '../controllers/checkout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartController>();
    final orderController = context.read<OrdersController>();
    return Scaffold(
      backgroundColor: AppColors.bgPink,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textDark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Section
                    _SectionHeader(title: 'Delivery Address'),
                    const SizedBox(height: 12),
                    _DeliveryLocationCard(controller: controller),
                    const SizedBox(height: 32),

                    // Contact Information Section
                    _SectionHeader(title: 'Contact Information'),
                    const SizedBox(height: 12),
                    _ContactInformationCard(controller: controller),
                    const SizedBox(height: 32),

                    // Additional Instructions Section
                    _SectionHeader(title: 'Additional Instructions (Optional)'),
                    const SizedBox(height: 12),
                    _DeliveryInstructionsCard(controller: controller),
                    const SizedBox(height: 32),

                    // Order Notes Section
                    _SectionHeader(title: 'Order Notes (Optional)'),
                    const SizedBox(height: 12),
                    _OrderNotesCard(controller: controller),
                    const SizedBox(height: 32),

                    // Proceed Button
                    GestureDetector(
                      onTap: () async {
                        if (controller.validateCheckout()) {
                          final data = await controller.placeOrder();

                          if (data) {
                            CustomSnackbar.show(
                              context,
                              message: "Order placed successfully!",
                            );

                            context.push(
                              RoutePath.searchConfirmOrder,
                              // extra: orderController.getActiveOrder(),
                            );
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppColors.pinkGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryPink.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Search For Truck',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

class _DeliveryLocationCard extends StatelessWidget {
  final CartController controller;

  const _DeliveryLocationCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateLocationPicker(context, controller),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.latitude != null
                ? AppColors.primaryPink
                : AppColors.textGrayLight,
            width: 1.2,
          ),
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgPink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: AppColors.primaryPink,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Location',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.deliveryAddress ?? "Tap to select location",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: controller.latitude != null
                          ? AppColors.textDark
                          : AppColors.textGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textGray.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateLocationPicker(
    BuildContext context,
    CartController controller,
  ) {
    context.push(RoutePath.selectAddress).then((result) {
      if (result != null && result is Map) {
        controller.updateDeliveryLocation(
          result['address'] ?? '',
          result['latitude'] ?? 0.0,
          result['longitude'] ?? 0.0,
        );
      }
    });
  }
}

class _ContactInformationCard extends StatefulWidget {
  final CartController controller;

  const _ContactInformationCard({required this.controller});

  @override
  State<_ContactInformationCard> createState() =>
      _ContactInformationCardState();
}

class _ContactInformationCardState extends State<_ContactInformationCard> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.controller.fullName);
    phoneController = TextEditingController(
      text: widget.controller.phoneNumber,
    );
    emailController = TextEditingController(text: widget.controller.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          // Full Name
          _CustomTextField(
            label: 'Full Name',
            controller: nameController,
            icon: Icons.person_rounded,
            onChanged: (value) {
              widget.controller.updateContactInfo(
                name: value,
                phone: phoneController.text,
                emailAddress: emailController.text,
              );
            },
          ),
          const SizedBox(height: 16),
          // Phone Number
          _CustomTextField(
            label: 'Phone Number',
            controller: phoneController,
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              widget.controller.updateContactInfo(
                name: nameController.text,
                phone: value,
                emailAddress: emailController.text,
              );
            },
          ),
          const SizedBox(height: 16),
          // Email
          _CustomTextField(
            label: 'Email Address',
            controller: emailController,
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              widget.controller.updateContactInfo(
                name: nameController.text,
                phone: phoneController.text,
                emailAddress: value,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DeliveryInstructionsCard extends StatefulWidget {
  final CartController controller;

  const _DeliveryInstructionsCard({required this.controller});

  @override
  State<_DeliveryInstructionsCard> createState() =>
      _DeliveryInstructionsCardState();
}

class _DeliveryInstructionsCardState extends State<_DeliveryInstructionsCard> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.controller.deliveryInstructions,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: TextField(
        controller: controller,
        maxLines: 3,
        onChanged: (value) {
          widget.controller.updateDeliveryInstructions(value);
        },

        decoration: InputDecoration(
          hintText: 'e.g., Leave at door, Ring doorbell twice, etc.',
          hintStyle: TextStyle(
            color: AppColors.textGray.withOpacity(0.5),
            fontSize: 14,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

class _OrderNotesCard extends StatefulWidget {
  final CartController controller;

  const _OrderNotesCard({required this.controller});

  @override
  State<_OrderNotesCard> createState() => _OrderNotesCardState();
}

class _OrderNotesCardState extends State<_OrderNotesCard> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.controller.orderNotes);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: TextField(
        controller: controller,
        maxLines: 3,
        onChanged: (value) {
          widget.controller.updateOrderNotes(value);
        },
        decoration: InputDecoration(
          hintText: 'e.g., Extra sprinkles, no nuts, etc.',
          hintStyle: TextStyle(
            color: AppColors.textGray.withOpacity(0.5),
            fontSize: 14,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

class _CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final Function(String) onChanged;

  const _CustomTextField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: _focusNode.hasFocus ? AppColors.bgPink : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? AppColors.primaryPink
                  : AppColors.textGrayLight,
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                widget.icon,
                color: _focusNode.hasFocus
                    ? AppColors.primaryPink
                    : AppColors.textGray,
                size: 20,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
