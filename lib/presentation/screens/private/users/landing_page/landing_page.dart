import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/presentation/screens/private/drivers/landing_page/landing_page.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/common/widgets/bottom_navigation.dart';

class LandingPageUser extends StatefulWidget {
  final Widget? child;
  const LandingPageUser({super.key, this.child});

  @override
  State<LandingPageUser> createState() => _LandingPageUserState();
}

class _LandingPageUserState extends State<LandingPageUser>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<String> _pages = [
    RoutePath.home,
    RoutePath.map,
    RoutePath.menu,
    RoutePath.setting,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(
        gradient: AppColors.pinkGradient,
        shadow: AppColors.shadowPink,
        currentIndex: _currentIndex,
        items: [
          CustomNavBarItem(Icons.home_rounded, "Home"),
          CustomNavBarItem(Icons.location_on_rounded, "Map"),
          CustomNavBarItem(Icons.menu_book_rounded, "Menu"),
          CustomNavBarItem(Icons.settings_rounded, "Settings"),
        ],
        onIndexChanged: (index) {
          if (index == _currentIndex) return;

          setState(() => _currentIndex = index);
          context.go(_pages[index]);
        },
      ),
    );
  }
}
