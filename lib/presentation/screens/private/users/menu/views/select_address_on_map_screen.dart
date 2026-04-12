import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/styles/app_colors.dart';

class SelectAddressOnMapScreen extends StatefulWidget {
  const SelectAddressOnMapScreen({super.key});

  @override
  State<SelectAddressOnMapScreen> createState() =>
      _SelectAddressOnMapScreenState();
}

class _SelectAddressOnMapScreenState extends State<SelectAddressOnMapScreen> {
  late Offset _pinPosition;
  late Size _mapSize;
  late bool _isDragging;

  // Mock coordinates
  double _latitude = 40.7128;
  double _longitude = -74.0060;

  @override
  void initState() {
    super.initState();
    _isDragging = false;
    _pinPosition = Offset.zero;
  }

  // Convert screen coordinates to lat/lng (mock)
  void _updateCoordinates(Offset position) {
    // Mock calculation for lat/lng based on position
    _latitude = 40.7128 + (position.dy / _mapSize.height) * 0.1;
    _longitude = -74.0060 + (position.dx / _mapSize.width) * 0.1;
  }

  // Get address from coordinates (mock)
  String _getAddressFromCoordinates() {
    return '${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)}';
  }

  @override
  Widget build(BuildContext context) {
    _mapSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dummy Map Background
          _DummyMapView(
            pinPosition: _pinPosition,
            onMapTap: (position) {
              setState(() {
                _pinPosition = position;
                _updateCoordinates(position);
              });
            },
            onPinDragUpdate: (position) {
              setState(() {
                _pinPosition = position;
                _updateCoordinates(position);
              });
            },
            onPinDragEnd: () {
              setState(() {
                _isDragging = false;
              });
            },
            onPinDragStart: () {
              setState(() {
                _isDragging = true;
              });
            },
          ),

          // Center Pin Indicator
          Positioned(
            left: _mapSize.width / 2 - 24,
            top: _mapSize.height / 2 - 24,
            child: IgnorePointer(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryPink, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primaryPink,
                  size: 24,
                ),
              ),
            ),
          ),

          // Floating Draggable Pin
          Positioned(
            left: _pinPosition.dx,
            top: _pinPosition.dy,
            child: GestureDetector(
              onPanStart: (_) {
                setState(() {
                  _isDragging = true;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _pinPosition = Offset(
                    (_pinPosition.dx + details.delta.dx).clamp(
                      0,
                      _mapSize.width - 40,
                    ),
                    (_pinPosition.dy + details.delta.dy).clamp(
                      0,
                      _mapSize.height - 300,
                    ),
                  );
                  _updateCoordinates(_pinPosition);
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _isDragging = false;
                });
              },
              child: AnimatedScale(
                scale: _isDragging ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPink,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPink.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // Top Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textDark,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Location Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag indicator
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.textGrayLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Location Info
                      Row(
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
                                  'Selected Location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getAddressFromCoordinates(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Coordinates Display
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.bgPink,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primaryPink.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Latitude',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _latitude.toStringAsFixed(6),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: AppColors.primaryPink.withOpacity(0.2),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Longitude',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _longitude.toStringAsFixed(6),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Set Location Button
                      GestureDetector(
                        onTap: () {
                          // Get.back(result: {
                          //   'address': _getAddressFromCoordinates(),
                          //   'latitude': _latitude,
                          //   'longitude': _longitude,
                          // });
                          context.pop();
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
                            'Set Location',
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
    );
  }
}

class _DummyMapView extends StatefulWidget {
  final Offset pinPosition;
  final Function(Offset) onMapTap;
  final Function(Offset) onPinDragUpdate;
  final Function() onPinDragEnd;
  final Function() onPinDragStart;

  const _DummyMapView({
    required this.pinPosition,
    required this.onMapTap,
    required this.onPinDragUpdate,
    required this.onPinDragEnd,
    required this.onPinDragStart,
  });

  @override
  State<_DummyMapView> createState() => _DummyMapViewState();
}

class _DummyMapViewState extends State<_DummyMapView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        widget.onMapTap(details.globalPosition);
      },
      child: Container(
        color: Colors.grey[200],
        child: Stack(
          children: [
            // Map Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade100, Colors.green.shade100],
                ),
              ),
            ),

            // Grid Pattern
            CustomPaint(painter: GridPainter(), size: Size.infinite),

            // Mock Streets
            CustomPaint(painter: StreetPainter(), size: Size.infinite),

            // Mock Buildings
            Positioned(
              left: 30,
              top: 40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border.all(color: Colors.grey[600]!, width: 1),
                ),
                child: const Center(
                  child: Text(
                    'Building',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 40,
              bottom: 60,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  border: Border.all(color: Colors.green[700]!, width: 1),
                ),
                child: const Center(
                  child: Text(
                    'Park',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              bottom: 100,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.amber[300],
                  border: Border.all(color: Colors.amber[700]!, width: 1),
                ),
                child: const Center(
                  child: Text(
                    'Store',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}

class StreetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 3;

    // Horizontal streets
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.6),
      Offset(size.width, size.height * 0.6),
      paint,
    );

    // Vertical streets
    canvas.drawLine(
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.25, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, 0),
      Offset(size.width * 0.75, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(StreetPainter oldDelegate) => false;
}
