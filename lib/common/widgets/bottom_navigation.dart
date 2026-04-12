import 'package:flutter/material.dart';
import 'package:mister_twister/presentation/screens/private/drivers/landing_page/landing_page.dart';
import 'package:mister_twister/common/styles/app_colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<CustomNavBarItem> items;
  final int currentIndex;
  final LinearGradient? gradient;
  final Color? shadow;
  final ValueChanged<int> onIndexChanged;

  const CustomBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onIndexChanged,
    this.gradient,
    this.shadow,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  LinearGradient get gradient => widget.gradient ?? AppColors.pinkGradient;
  Color get shadow => widget.shadow ?? AppColors.shadowPinkDark;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.items.length;

    return Container(
      height: kBottomNavigationBarHeight + 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final itemWidth = width / itemCount;
            final indicatorHeight = 48.0;
            final indicatorTop = (height - indicatorHeight) / 2;

            return Stack(
              children: [
                /// Indicator
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: widget.currentIndex * itemWidth + 2,
                  top: indicatorTop,
                  child: Container(
                    width: itemWidth - 4,
                    height: indicatorHeight,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Items
                Row(
                  children: List.generate(itemCount, (index) {
                    final item = widget.items[index];
                    final selected = index == widget.currentIndex;

                    return SizedBox(
                      width: itemWidth,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: () => widget.onIndexChanged(index),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                color: selected
                                    ? Colors.white
                                    : Colors.grey[400],
                                size: 22,
                              ),
                              if (!selected)
                                Text(
                                  item.title!,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
