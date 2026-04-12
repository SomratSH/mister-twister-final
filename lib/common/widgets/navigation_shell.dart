// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mister_twister/common/models/user_type.dart';
// import 'package:mister_twister/common/widgets/bottom_navigation.dart';

// import '../../app/routes/app_routes.dart';
// import '../styles/app_colors.dart';

// class UserNavigatorShellBinding extends Bindings {
//   @override
//   void dependencies() {
//     // No controller needed - navigation shell manages its own state
//   }
// }

// class UserNavigationShell extends StatelessWidget {
//   const UserNavigationShell({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Navigator(
//         key: Get.nestedKey(1),
//         initialRoute: AppRoutes.userNavigationRoutes.first.path,
//         onGenerateRoute: (settings) {
//           return GetPageRoute(
//             settings: settings,
//             page: () {
//               print("Generating route for ${settings.name}");
//               final routeInfo = AppRoutes.userNavigationRoutes.firstWhere(
//                 (route) => route.path == settings.name,
//                 orElse: () => AppRoutes.userNavigationRoutes.first,
//               );
//               return routeInfo.page();
//             },
//             binding: AppRoutes.userNavigationRoutes
//                 .firstWhere(
//                   (route) => route.path == settings.name,
//                   orElse: () => AppRoutes.userNavigationRoutes.first,
//                 )
//                 .binding(),
//           );
//         },
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         gradient: AppColors.pinkGradient,
//         shadow: AppColors.shadowPink,
//         items: [
//           NavBarItemData(
//             icon: Icons.home_rounded,
//             label: 'Home',
//             route: AppRoutes.userNavigatorShell.path,
//           ),
//           NavBarItemData(
//             icon: Icons.location_on_rounded,
//             label: 'Map',
//             route: AppRoutes.userNavigationRoutes[1].path,
//           ),
//           NavBarItemData(
//             icon: Icons.menu_book_rounded,
//             label: 'Menu',
//             route: AppRoutes.userNavigationRoutes[2].path,
//           ),
//           NavBarItemData(
//             icon: Icons.settings_rounded,
//             label: 'Settings',
//             route: AppRoutes.userNavigationRoutes[3].path,
//           ),
//         ],
//         onIndexChanged: (value) {
//           if (value == 0) {
//             Get.toNamed(AppRoutes.home.path);
//             return;
//           }
//           final route = AppRoutes.userNavigationRoutes[value];
//           Get.toNamed(route.path, id: 1);
//         },
//       ),
//     );
//   }
// }

// class DriverNavigatorShellBinding extends Bindings {
//   @override
//   void dependencies() {
//     // No controller needed - navigation shell manages its own state
//   }
// }

// class DriverNavigationShell extends StatelessWidget {
//   const DriverNavigationShell({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Navigator(
//         key: Get.nestedKey(2),
//         initialRoute: AppRoutes.driversNavigationRoutes.first.path,
//         onGenerateRoute: (settings) {
//           return GetPageRoute(
//             settings: settings,
//             page: () {
//               final routeInfo = AppRoutes.driversNavigationRoutes.firstWhere(
//                 (route) => route.path == settings.name,
//                 orElse: () => AppRoutes.driversNavigationRoutes.first,
//               );
//               return routeInfo.page();
//             },
//             binding: AppRoutes.driversNavigationRoutes
//                 .firstWhere(
//                   (route) => route.path == settings.name,
//                   orElse: () => AppRoutes.driversNavigationRoutes.first,
//                 )
//                 .binding(),
//           );
//         },
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         gradient: AppColors.blueGradient,
//         shadow: AppColors.shadowBlue,
//         items: [
//           NavBarItemData(
//             icon: Icons.home_rounded,
//             label: 'Home',
//             route: AppRoutes.driversNavigationRoutes[0].path,
//           ),
//           NavBarItemData(
//             icon: Icons.location_on_rounded,
//             label: 'Map',
//             route: AppRoutes.driversNavigationRoutes[1].path,
//           ),
//           NavBarItemData(
//             icon: Icons.notifications_rounded,
//             label: 'Requests',
//             route: AppRoutes.driversNavigationRoutes[2].path,
//           ),
//           NavBarItemData(
//             icon: Icons.menu_book_rounded,
//             label: 'Menu',
//             route: AppRoutes.driversNavigationRoutes[3].path,
//           ),
//           NavBarItemData(
//             icon: Icons.settings_rounded,
//             label: 'Settings',
//             route: AppRoutes.driversNavigationRoutes[4].path,
//           ),
//         ],
//         onIndexChanged: (value) {
//           if (value == 0) {
//             Get.toNamed(
//               AppRoutes.driverHome.path,
//               arguments: UserRole.driver,
//               id: 2,
//             );
//             return;
//           }
//           final route = AppRoutes.driversNavigationRoutes[value];
//           Get.toNamed(route.path, arguments: UserRole.driver, id: 2);
//         },
//       ),
//     );
//   }
// }
