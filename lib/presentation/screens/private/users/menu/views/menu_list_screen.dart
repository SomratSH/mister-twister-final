import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/domain/entities/product_model.dart';
import 'package:mister_twister/presentation/screens/private/common/product/product_provider.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/controllers/cart_controller.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/models/menu_item.dart';
import '../controllers/menu_list_controller.dart';

class MenuListScreenUser extends StatelessWidget {
  const MenuListScreenUser({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductProvider>();
    final cartController = context.watch<CartController>();
    final filteredMenu = controller.product;
    final cart = cartController.cart;
    final itemCount = controller.categories.length;
    final cartCount = cartController.cartItems.length;
    return Scaffold(
      backgroundColor: AppColors.bgPink,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.bgPink,
              elevation: 0,
              pinned: false,
              floating: true,
              snap: true,

              title: const Text(
                'Menu',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    // // Navigate to cart screen
                    // Get.toNamed('/cart'); // Update with your cart route
                    cartController.getCartItemList();
                    context.push(RoutePath.cart);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          color: AppColors.primaryPink,
                          size: 20,
                        ),
                        if (cartCount > 0)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryPink,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                cartCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Sticky category chips
            SliverPersistentHeader(
              pinned: true,
              delegate: _ChipsHeaderDelegate(
                child: Container(
                  color: AppColors.bgPink,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: itemCount,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final cat = controller.categories[index];
                        final selected =
                            controller.selectedCategory == cat.name;
                        return GestureDetector(
                          onTap: () =>
                              controller.selectCategory(cat.name.toString()),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primaryPink
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primaryPink
                                    : AppColors.textGrayLight.withOpacity(0.2),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cat.name!,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Menu grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: filteredMenu.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.restaurant_menu_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No menu data available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = filteredMenu[index];
                        return _MenuCard(
                          item: item,
                          onAdd: () async {
                            await cartController.addToCart(item);
                          },
                          isAdded: cart.contains(item),
                        );
                      }, childCount: filteredMenu.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _ChipsHeaderDelegate({required this.child});
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;
  @override
  double get maxExtent => 54;
  @override
  double get minExtent => 54;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _MenuCard extends StatefulWidget {
  final ProductModel item;
  final VoidCallback onAdd;
  final bool isAdded;
  const _MenuCard({
    required this.item,
    required this.onAdd,
    required this.isAdded,
  });

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnim = Tween<double>(
      begin: 1,
      end: 1.25,
    ).chain(CurveTween(curve: Curves.easeOutBack)).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant _MenuCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAdded && !oldWidget.isAdded) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: Image.network(
              widget.item.imageUrl.isEmpty ? "" : widget.item.imageUrl[0],
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 110,
                color: AppColors.bgPink,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image,
                  color: AppColors.textGray,
                  size: 36,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.item.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.item.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.primaryPink,
                      ),
                    ),
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: InkWell(
                        onTap: widget.onAdd,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: widget.isAdded
                                ? AppColors.primaryPink
                                : Colors.white,
                            border: Border.all(
                              color: AppColors.primaryPink,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isAdded
                                ? Icons.check
                                : Icons.shopping_cart_outlined,
                            color: widget.isAdded
                                ? Colors.white
                                : AppColors.primaryPink,
                            size: 22,
                          ),
                        ),
                      ),
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
