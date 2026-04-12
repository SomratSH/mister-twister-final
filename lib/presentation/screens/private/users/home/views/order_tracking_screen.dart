import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geolocator/geolocator.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:mister_twister/common/styles/app_colors.dart';
import 'package:mister_twister/presentation/screens/private/common/web_scoket/global_web_scoket.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  gmaps.LatLng? _userLocation;
  gmaps.LatLng? _driverLocation;
  gmaps.GoogleMapController? _mapController;

  gmaps.BitmapDescriptor? _userIcon;
  gmaps.BitmapDescriptor? _driverIcon;
  Set<gmaps.Polyline> _polylines = {};

  final String directionsApiKey = 'AIzaSyCX1bkX2BMHv8QF_mvKaLiFYr4ZiKwV9j8';

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _loadMarkers();
  }

  /// 📍 User location
  Future<void> _loadUserLocation() async {
    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _userLocation = gmaps.LatLng(pos.latitude, pos.longitude);
    });

    // Call findDrivers once location is ready
    final socket = Provider.of<GlobalSocketProvider>(context, listen: false);
    socket.findDrivers(
      latitude: pos.latitude,
      longitude: pos.longitude,
      radius: 5000,
    );
  }

  /// 🖼️ Marker icons
  Future<void> _loadMarkers() async {
    _userIcon = await gmaps.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/user_marker.png',
    );

    _driverIcon = await gmaps.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/driver_marker.png',
    );

    setState(() {});
  }

  /// 🛣️ Route polyline
  Future<void> _updateRoute() async {
    if (_userLocation == null || _driverLocation == null) return;

    final url =
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${_driverLocation!.latitude},${_driverLocation!.longitude}'
        '&destination=${_userLocation!.latitude},${_userLocation!.longitude}'
        '&key=$directionsApiKey';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return;

    final data = jsonDecode(res.body);
    if (data['routes'].isEmpty) return;

    final points = data['routes'][0]['overview_polyline']['points'];
    final decoded = _decodePolyline(points);

    setState(() {
      _polylines = {
        gmaps.Polyline(
          polylineId: const gmaps.PolylineId('route'),
          points: decoded,
          color: Colors.blueAccent,
          width: 5,
        ),
      };
    });
  }

  List<gmaps.LatLng> _decodePolyline(String encoded) {
    List<gmaps.LatLng> poly = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      poly.add(gmaps.LatLng(lat / 1e5, lng / 1e5));
    }
    return poly;
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrdersController>();
    return Scaffold(
      backgroundColor: AppColors.bgPink,
      body: SafeArea(
        child: Consumer<GlobalSocketProvider>(
          builder: (context, socket, _) {
            if (socket.driverLocation != null) {
              _driverLocation = gmaps.LatLng(
                socket.driverLocation!.latitude,
                socket.driverLocation!.longitude,
              );
              _updateRoute();
            }
            final data =  orderController.getActiveOrder();
            return Column(
              children: [
                /// 🗺️ TOP MAP (45%)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: _userLocation == null
                      ? const Center(child: CircularProgressIndicator())
                      : gmaps.GoogleMap(
                          initialCameraPosition: gmaps.CameraPosition(
                            target: _userLocation!,
                            zoom: 15,
                          ),
                          markers: {
                            gmaps.Marker(
                              markerId: const gmaps.MarkerId('user'),
                              position: _userLocation!,
                              icon:
                                  _userIcon ??
                                  gmaps.BitmapDescriptor.defaultMarker,
                            ),
                            if (_driverLocation != null)
                              gmaps.Marker(
                                markerId: const gmaps.MarkerId('driver'),
                                position: _driverLocation!,
                                icon:
                                    _driverIcon ??
                                    gmaps.BitmapDescriptor.defaultMarker,
                              ),
                          },
                          polylines: _polylines,
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          onMapCreated: (c) => _mapController = c,
                        ),
                ),

                /// 📦 BOTTOM DETAILS (55%)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Order ID + Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ${widget.orderId}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bgPink,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primaryPink,
                                ),
                              ),
                              child: const Text(
                                'Confirmed',
                                style: TextStyle(
                                  color: AppColors.primaryPink,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// Driver info
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryPink,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            data!.driverName!,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text('Driver • ⭐ 4.8'),
                          trailing: Icon(
                            Icons.phone,
                            color: AppColors.primaryPink,
                          ),
                        ),

                        /// Actions
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => context.go(RoutePath.home),
                              icon: const Icon(Icons.home),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryPink,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () => context.go(RoutePath.payment),
                                child: const Text(
                                  'Proceed to Payment',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
