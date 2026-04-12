// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mister_twister/core/routes/app_route_path.dart';
// import 'package:mister_twister/presentation/screens/private/common/product/product_provider.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../../common/styles/app_colors.dart';
// import '../controllers/menu_controller.dart';

// class ViewMenuScreenDriver extends StatefulWidget {
//   String? id;
//   ViewMenuScreenDriver({super.key, required this.id});

//   @override
//   State<ViewMenuScreenDriver> createState() => _ViewMenuScreenDriverState();
// }

// class _ViewMenuScreenDriverState extends State<ViewMenuScreenDriver> {
//   @override
//   Widget build(BuildContext context) {
//     final controller = context.watch<ProductProvider>();
//     if (controller.product.isEmpty) {
//       return Scaffold(
//         backgroundColor: AppColors.bgBlue,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 64,
//                 color: AppColors.primaryBlue.withOpacity(0.3),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Menu Item Not Found',
//                 style: TextStyle(
//                   color: AppColors.textDark,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: AppColors.bgBlue,
//       appBar: AppBar(
//         backgroundColor: AppColors.bgBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Menu Details',
//           style: TextStyle(
//             color: AppColors.textDark,
//             fontWeight: FontWeight.w700,
//             fontSize: 18,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: Center(
//               child: GestureDetector(
//                 onTap: () {
//                   context.push(RoutePath.editMenuDriver);
//                 },

//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: AppColors.blueGradient,
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: const Row(
//                     children: [
//                       Icon(Icons.edit, color: Colors.white, size: 14),
//                       SizedBox(width: 4),
//                       Text(
//                         'Edit',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image Carousel
//               _buildImageCarousel(controller),
//               const SizedBox(height: 24),

//               // Name
//               Text(
//                 controller.!.name,
//                 style: const TextStyle(
//                   color: AppColors.textDark,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Price Section
//               _buildPriceSection(controller),
//               const SizedBox(height: 20),

//               // Description
//               Text(
//                 'Description',
//                 style: TextStyle(
//                   color: AppColors.textDark,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 controller.menuItem!.description,
//                 style: const TextStyle(
//                   color: AppColors.textGray,
//                   fontSize: 13,
//                   height: 1.6,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Info Cards
//               _buildInfoCard(
//                 icon: Icons.inventory_2_outlined,
//                 label: 'Stock Quantity',
//                 value: '${controller.menuItem!.quantity} items',
//                 color: Colors.orange,
//               ),
//               const SizedBox(height: 12),

//               // Delete Button
//               GestureDetector(
//                 onTap: () => _showDeleteConfirmation(controller),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(50),
//                     border: Border.all(color: Colors.red.withOpacity(0.3)),
//                   ),
//                   child: const Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.delete_outline, color: Colors.red, size: 18),
//                         SizedBox(width: 8),
//                         Text(
//                           'Delete Item',
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImageCarousel(ProductProvider controller) {
//     if (controller!.selectedImages.isEmpty) {
//       return Container(
//         height: 220,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: AppColors.primaryBlue.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Icon(
//           Icons.image_not_supported_outlined,
//           color: AppColors.primaryBlue.withOpacity(0.5),
//           size: 48,
//         ),
//       );
//     }

//     return SizedBox(
//       height: 220,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: controller.product!.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.only(
//               right: index == controller.product!.length - 1
//                   ? 0
//                   : 12,
//             ),
//             child: Container(
//               width: 220,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: AppColors.primaryBlue.withOpacity(0.1),
//               ),
//               child: Image.network(
//                 controller.!.imagePaths[index],
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                           : null,
//                       color: AppColors.primaryBlue,
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) => Icon(
//                   Icons.image_not_supported_outlined,
//                   color: AppColors.primaryBlue.withOpacity(0.5),
//                   size: 48,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildPriceSection(DriverMenuProvider controller) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowBlack,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Regular Price',
//                 style: TextStyle(
//                   color: AppColors.textGray,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 12,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 '\$${controller.menuItem!.price.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   color: AppColors.primaryBlue,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//           if (controller.menuItem!.discountPrice != null)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Discount Price',
//                   style: TextStyle(
//                     color: AppColors.textGray,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '\$${controller.menuItem!.discountPrice!.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     color: Colors.green,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowBlack,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: AppColors.textGray,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 12,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: AppColors.textDark,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteConfirmation(DriverMenuProvider controller) {
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Icon
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.warning_rounded,
//                   color: Colors.red,
//                   size: 32,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Title
//               const Text(
//                 'Delete Item?',
//                 style: TextStyle(
//                   color: AppColors.textDark,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),

//               // Description
//               Text(
//                 'Are you sure you want to delete "${controller.menuItem!.name}"? This action cannot be undone.',
//                 style: const TextStyle(
//                   color: AppColors.textGray,
//                   fontSize: 14,
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),

//               // Buttons
//               Column(
//                 children: [
//                   // Delete Button
//                   GestureDetector(
//                     onTap: () {
//                       // Get.back();
//                       // controller.deleteMenuItem(controller.menuItem!.id);
//                       // Get.back();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Yes, Delete',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Cancel Button
//                   GestureDetector(
//                     onTap: () => Get.back(),
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: AppColors.primaryBlue,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(
//                             color: AppColors.primaryBlue,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: true,
//     );
//   }
// }
