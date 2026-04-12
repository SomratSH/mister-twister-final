import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/common/widgets/bottom_navigation.dart';

class LandingPageDriver extends StatefulWidget {
  final Widget child;
  const LandingPageDriver({super.key, required this.child});

  @override
  State<LandingPageDriver> createState() => _LandingPageDriverState();
}

class _LandingPageDriverState extends State<LandingPageDriver> {
  int _currentIndex = 0;

  final List<String> _pages = [
    RoutePath.homeDriver,
    RoutePath.mapDriver,
    RoutePath.requestDriver,
    RoutePath.menuDriver,
    RoutePath.settingDriver,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final location = GoRouterState.of(context).uri.toString();
    final index = _pages.indexWhere((path) => location.startsWith(path));

    if (index != -1 && index != _currentIndex) {
      _currentIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(
        gradient: AppColors.blueGradient,
        shadow: AppColors.shadowBlue,
        currentIndex: _currentIndex,
        items: const [
          CustomNavBarItem(Icons.home_rounded, "Home"),
          CustomNavBarItem(Icons.location_on_rounded, "Map"),
          CustomNavBarItem(Icons.notifications_rounded, "Requests"),
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

class CustomNavBarItem {
  final IconData icon;
  final String title;

  const CustomNavBarItem(this.icon, this.title);
}
