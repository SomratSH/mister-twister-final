import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/domain/entities/order_model.dart';
import 'package:mister_twister/presentation/screens/private/common/web_scoket/global_web_scoket.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/controllers/cart_controller.dart';
import 'package:mister_twister/utils/utlis.dart';
import 'package:provider/provider.dart';

class SearchingForOrderConfirm extends StatefulWidget {
  const SearchingForOrderConfirm({super.key});

  @override
  State<SearchingForOrderConfirm> createState() =>
      _SearchingForOrderConfirmState();
}

class _SearchingForOrderConfirmState extends State<SearchingForOrderConfirm>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _searchController;
  late AnimationController _driverApproachController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _searchAnimation;

  // Simulation state
  bool _driverConfirmed = false;
  int _timeElapsed = 0;

  // Order details (can be passed via Get.arguments)
  final String orderId = '#ORD-2024-0001';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _searchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _driverApproachController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _searchAnimation = Tween<double>(
      begin: 0,
      end: 360,
    ).animate(CurvedAnimation(parent: _searchController, curve: Curves.linear));

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<GlobalSocketProvider>().addListener(_socketListener);
    // });

    //   if (Provider.of<GlobalSocketProvider>(context, listen: false).lastEvent ==
    //       "order_accepted") {
    //     setState(() {
    //       _driverConfirmed = true;
    //     });
    //     _driverApproachController.forward();
    //   }

    // Simulate time elapsedu
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _timeElapsed < 12) {
        setState(() {
          _timeElapsed++;
        });
      }
      return _timeElapsed < 12;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    _driverApproachController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartController>();
    final socket = context.watch<GlobalSocketProvider>();
    if (socket.lastEvent == 'order_accepted' && !_driverConfirmed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        setState(() {
          _driverConfirmed = true;
        });

        _driverApproachController.forward();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.bgPink,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          _driverConfirmed
                              ? 'Order Confirmed'
                              : 'Searching for Driver',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _driverConfirmed
                              ? 'Your order has been confirmed. Driver is on the way!'
                              : 'Finding the best driver for your order...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Animated Center Animation
                  if (!_driverConfirmed)
                    _SearchingAnimation(
                      pulseAnimation: _pulseAnimation,
                      searchAnimation: _searchAnimation,
                    )
                  else
                    _DriverApproachingAnimation(timeElapsed: _timeElapsed),

                  const SizedBox(height: 40),

                  // Order Details Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowPinkLight,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Order ID',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    orderId,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryPink,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _driverConfirmed
                                      ? AppColors.bgPink
                                      : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _driverConfirmed
                                        ? AppColors.primaryPink
                                        : Colors.orange.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _driverConfirmed ? 'Confirmed' : 'Searching',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _driverConfirmed
                                        ? AppColors.primaryPink
                                        : Colors.orange.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(
                            color: AppColors.textGrayLight,
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoBox(
                                label: 'Time Elapsed',
                                value: '${_timeElapsed}s',
                                icon: Icons.timer_rounded,
                              ),
                              _InfoBox(
                                label: 'Status',
                                value: _driverConfirmed
                                    ? 'Confirmed'
                                    : 'Searching',
                                icon: Icons.info_outline_rounded,
                              ),
                              _InfoBox(
                                label: 'Distance',
                                value: 'N/A',
                                icon: Icons.location_on_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Driver Info (shows when confirmed)
                  if (_driverConfirmed)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _DriverInfoCard(timeRemaining: 12 - _timeElapsed),
                    ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (!_driverConfirmed)
                          SizedBox()
                        else
                          Row(
                            children: [
                              // Home button - Circular
                              GestureDetector(
                                onTap: () {
                                  context.go(RoutePath.home);
                                },
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryPink
                                            .withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.home_rounded,
                                    color: AppColors.primaryPink,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Received Order button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // if (_timeElapsed >= 12) {
                                    //   // Get.snackbar(
                                    //   //   'Order Delivered',
                                    //   //   'Your order has arrived!',
                                    //   //   backgroundColor: AppColors.primaryPink,
                                    //   //   colorText: Colors.white,
                                    //   //   duration: const Duration(seconds: 2),
                                    //   // );
                                    //   // Future.delayed(
                                    //   //   const Duration(seconds: 1),
                                    //   //   () {
                                    //   //     Get.offNamed('/home');
                                    //   //   },
                                    //   // );
                                    // }
                                    context.go(RoutePath.payment);
                                  },
                                  child: Container(
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
                                    child: Text(
                                      _timeElapsed >= 12
                                          ? 'Received Order'
                                          : 'Driver Arriving in ${12 - _timeElapsed}m',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchingAnimation extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final Animation<double> searchAnimation;

  const _SearchingAnimation({
    required this.pulseAnimation,
    required this.searchAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulsing ring
            AnimatedBuilder(
              animation: pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 200 + (pulseAnimation.value * 50),
                  height: 200 + (pulseAnimation.value * 50),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryPink.withOpacity(
                        1 - pulseAnimation.value,
                      ),
                      width: 2,
                    ),
                  ),
                );
              },
            ),

            // Middle rotating ring
            AnimatedBuilder(
              animation: searchAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (searchAnimation.value * 3.14159 * 2) / 360,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryPink.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Inner circle with icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.pinkGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPink.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverApproachingAnimation extends StatelessWidget {
  final int timeElapsed;

  const _DriverApproachingAnimation({required this.timeElapsed});

  @override
  Widget build(BuildContext context) {
    // Calculate progress based on time elapsed
    final progress = (timeElapsed / 12).clamp(0, 1);

    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Progress circle background
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bgPink,
                  border: Border.all(
                    color: AppColors.primaryPink.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),

              // Progress circle fill
              CustomPaint(
                size: const Size(200, 200),
                painter: CircleProgressPainter(progress: progress.toDouble()),
              ),

              // Distance display
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.two_wheeler_rounded,
                    size: 56,
                    color: AppColors.primaryPink,
                  ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   '${(12 - timeElapsed).clamp(0, 12)} km',
                  //   style: const TextStyle(
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.w700,
                  //     color: AppColors.primaryPink,
                  //   ),
                  // ),
                  const SizedBox(height: 4),
                  Text(
                    'Away',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Driver is coming',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Estimated ${(12 - timeElapsed).clamp(0, 12)} minutes away',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryPink),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DriverInfoCard extends StatelessWidget {
  final int timeRemaining;

  const _DriverInfoCard({required this.timeRemaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowPinkLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.pinkGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ahmed Hassan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(142 deliveries)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Arriving in ~$timeRemaining min',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    'Calling Driver',
                    'Connecting to Ahmed Hassan...',
                    backgroundColor: AppColors.primaryPink,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgPink,
                    border: Border.all(
                      color: AppColors.primaryPink,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    size: 18,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bgPink,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryPink.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.primaryPink,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Driver is currently 12 km away and approaching your location.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                    ),
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

class CircleProgressPainter extends CustomPainter {
  final double progress;

  CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw progress arc
    final paint = Paint()
      ..color = AppColors.primaryPink
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCircle(center: center, radius: radius - 2);
    canvas.drawArc(rect, -3.14159 / 2, (3.14159 * 2 * progress), false, paint);
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
