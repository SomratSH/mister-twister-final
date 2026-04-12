import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MapVController extends ChangeNotifier {
  MapVController() {
    _init();
  }

  WebSocketChannel? _channel;
  LatLng? userLocation;

  final List<NearbyDriver> _drivers = [];
  List<NearbyDriver> get drivers => _drivers;

  bool _isConnected = false;
  bool _hasSearchedDrivers = false;

  /// ================= INIT =================
  Future<void> _init() async {
    await _getUserLocation();
    await _connectSocket();
  }

  /// ================= SOCKET =================
  Future<void> _connectSocket() async {
    if (_isConnected) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    final uri =
        Uri.parse('ws://api.mtsoftserve.com/ws/customer/?token=$token');

    _channel = WebSocketChannel.connect(uri);
    _isConnected = true;

    _channel!.stream.listen(
      (data) {
        final decoded = jsonDecode(data);
        _handleEvent(decoded);
      },
      onError: (_) => _isConnected = false,
      onDone: () => _isConnected = false,
    );
  }

  /// ================= FIND DRIVERS =================
  void findDrivers({int radius = 5}) {
    if (!_isConnected || userLocation == null || _hasSearchedDrivers) return;

    _hasSearchedDrivers = true;

    final payload = {
      "event": "find_drivers",
      "location": {
        "latitude": userLocation!.latitude,
        "longitude": userLocation!.longitude,
      },
      "radius": radius,
    };

    _channel!.sink.add(jsonEncode(payload));
    debugPrint("📡 find_drivers sent");
  }

  /// ================= EVENTS =================
  void _handleEvent(Map<String, dynamic> data) {
    final event = data['event'];

    if (event == 'nearby_drivers') {
      final List list = data['drivers'];

      _drivers
        ..clear()
        ..addAll(list.map((e) => NearbyDriver.fromJson(e)));

      notifyListeners();
    }
  }

  /// ================= LOCATION =================
 Future<void> _getUserLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return;

  LocationPermission permission = await Geolocator.checkPermission();
  
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
  }

  // iOS Specific: If denied forever, we MUST send them to Settings
  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openAppSettings(); // This opens the iOS Settings app
    return;
  }

  // Using LocationSettings for better control on iOS 26
  final pos = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Only update if they move 10 meters
    ),
  );

  userLocation = LatLng(pos.latitude, pos.longitude);
  notifyListeners();
}

  /// ================= CLEANUP =================
  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}

class NearbyDriver {
  final String id;
  final double distance;
  final double latitude;
  final double longitude;

  NearbyDriver({
    required this.id,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  factory NearbyDriver.fromJson(Map<String, dynamic> json) {
    return NearbyDriver(
      id: json['driver_id'].toString(),
      distance: (json['distance'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  LatLng get latLng => LatLng(latitude, longitude);
}
