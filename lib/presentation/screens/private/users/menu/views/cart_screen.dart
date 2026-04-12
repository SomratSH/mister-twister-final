import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/domain/entities/cart_model.dart';
import 'package:mister_twister/domain/entities/product_model.dart';
import 'package:mister_twister/presentation/screens/private/common/product/product_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/models/menu_item.dart';
import '../controllers/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _showPaymentCard = true;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1))
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final currentPosition = notification.metrics.pixels;

      if (currentPosition > _lastScrollPosition && _showPaymentCard) {
        // Scrolling down and card is visible - hide it
        setState(() {
          _showPaymentCard = false;
          _animationController.forward();
        });
      } else if (currentPosition < _lastScrollPosition && !_showPaymentCard) {
        // Scrolling up and card is hidden - show it
        setState(() {
          _showPaymentCard = true;
          _animationController.reverse();
        });
      }

      _lastScrollPosition = currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<ProductProvider>();
    final controller = context.watch<CartController>();

    return Scaffold(
      backgroundColor: AppColors.bgPink,
      body: SafeArea(
        child: controller.cartItems.isEmpty
            ? Column(
                children: [
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
                          'My Cart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 60,
                            color: AppColors.textGray.withOpacity(0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGray.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  // Scrollable content
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      _handleScroll(notification);
                      return false;
                    },
                    child: CustomScrollView(
                      slivers: [
                        // Header
                        SliverAppBar(
                          backgroundColor: AppColors.bgPink,
                          elevation: 0,
                          pinned: true,
                          floating: false,
                          automaticallyImplyLeading: false,
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
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
                                        'My Cart',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Swipe Hint
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPink.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryPink.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 16,
                                    color: AppColors.primaryPink,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Swipe left on items to remove',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryPink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Cart Items
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = controller.cartItems[index];
                            final quantity =
                                controller.cartItems[index].quantity;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ).copyWith(bottom: 12),
                              child: Dismissible(
                                key: ValueKey(index), // ✅ better than name
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (_) async {
                                  final result = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: const Text('Remove Item?'),
                                      content: Text(
                                        'Are you sure you want to remove ${cartController.getProductName(item.productId)} from your cart?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (result == true) {
                                    // removeItem(item); // 🔥 setState called
                                  }

                                  return result;
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                child: _CartItemCard(
                                  item: item,
                                  quantity: quantity,
                                  onQuantityChanged: (newQty) {
                                    controller.updateQuantity(
                                      index,
                                      controller.cartItems[index].cardId
                                          .toString(),
                                      newQty,
                                    );
                                  },
                                ),
                              ),
                            );
                          }, childCount: controller.cartItems.length),
                        ),

                        // Spacing to prevent content overlap with floating card
                        const SliverToBoxAdapter(child: SizedBox(height: 380)),
                      ],
                    ),
                  ),
                  // Floating Payment Card (Stack on top)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        color: AppColors.bgPink,
                        padding: const EdgeInsets.all(0).copyWith(top: 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowPinkLight,
                                blurRadius: 8,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Payment Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _PriceRow(
                                label: 'Subtotal',
                                price: controller.calculateSubtotal(),
                              ),
                              const SizedBox(height: 8),
                              _PriceRow(
                                label: 'Tax (8%)',
                                price: controller.calculateTax(),
                              ),
                              const Divider(
                                color: AppColors.textGrayLight,
                                height: 24,
                                thickness: 0.8,
                              ),
                              _PriceRow(
                                label: 'Total',
                                price: controller.calculateTotal(),
                                isBold: true,
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  // Get.toNamed('/checkout');
                                  context.push(RoutePath.checkout);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.pinkGradient,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryPink
                                            .withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Proceed to Checkout',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartModel item;
  final int quantity;
  final Function(int) onQuantityChanged;

  const _CartItemCard({
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductProvider>();
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
              // item.imageUrl.isEmpty ? "" : item.imageUrl[0],
              controller.getProductImage(item.productId),
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                color: AppColors.bgPink,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image,
                  color: AppColors.textGray,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.unitPrice,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryPink,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (quantity > 1) {
                              onQuantityChanged(quantity - 1);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryPink,
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: AppColors.primaryPink,
                              size: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => onQuantityChanged(quantity + 1),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryPink,
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColors.primaryPink,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String price;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.price,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? AppColors.textDark : AppColors.textGray,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? AppColors.primaryPink : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
