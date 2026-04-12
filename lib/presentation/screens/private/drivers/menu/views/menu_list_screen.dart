import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/domain/entities/product_model.dart';
import 'package:mister_twister/presentation/screens/private/common/product/product_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../../common/styles/app_colors.dart';
import '../controllers/menu_controller.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlue,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Menu Management',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Manage your ice cream menu',
              style: TextStyle(
                color: AppColors.textGray,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: GestureDetector(
                onTap: () => context.push(RoutePath.addMenu),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.blueGradient,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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
      body: controller.product.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: AppColors.primaryBlue.withAlpha(77),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Menu Items Yet',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first ice cream to get started',
                    style: TextStyle(color: AppColors.textGray, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => context.push(RoutePath.addMenu), // Cleaned up navigation
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        'Add First Item',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68, // MODIFIED: Lowered from 0.75 for more height
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.product.length,
              itemBuilder: (context, index) {
                final item = controller.product[index];
                return _buildMenuCard(item, controller);
              },
            ),
    );
  }

  Widget _buildMenuCard(ProductModel item, ProductProvider controller) {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
            // Image Section
            Expanded( // MODIFIED: Uses Expanded instead of fixed height to prevent overflow
              child: Container(
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withAlpha(25),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl[0] ?? "",
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.primaryBlue,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.primaryBlue.withAlpha(128),
                          size: 40,
                        ),
                      )
                    : Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.primaryBlue.withAlpha(128),
                        size: 40,
                      ),
              ),
            ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(12), // Uniform padding
              child: Column(
                mainAxisSize: MainAxisSize.min, // Keep content tight
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\$${item.price}',
                        style: item.price.isEmpty
                            ? TextStyle(
                                color: AppColors.textGray,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              )
                            : const TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          item.stock.isNotEmpty &&
                              int.tryParse(item.stock) != null &&
                              int.parse(item.stock) > 0
                          ? Colors.green.withAlpha(38)
                          : Colors.red.withAlpha(38),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'In Stock: ${item.stock}',
                      style: TextStyle(
                        color:
                            item.stock.isNotEmpty &&
                                int.tryParse(item.stock) != null &&
                                int.parse(item.stock) > 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
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
}