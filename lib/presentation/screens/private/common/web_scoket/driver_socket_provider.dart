import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:permission_handler/permission_handler.dart';

class DriverSocketProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  StreamSubscription<Position>? _locationSubscription;

  bool _connected = false;
  bool get connected => _connected;

  Map<String, dynamic>? latestOrder;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// 🔗 CHANGE THIS
  final String socketUrl = 'ws://api.mtsoftserve.com/ws/driver/?token=';

  // ---------------- INIT ----------------

  Future<void> init() async {
    await _initNotifications();
    await _connectSocket();
    await _startLocationTracking();
    print("init done");
  }

  // ---------------- NOTIFICATIONS ----------------

  Future<void> _initNotifications() async {
  // 1. Android settings
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');

  // 2. iOS (Darwin) settings
  // Setting these to true ensures the plugin handles permissions correctly
  const darwin = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // 3. Combine both into initialization settings
  const settings = InitializationSettings(
    android: android,
    iOS: darwin,
  );

  // 4. Initialize the plugin
  await _notifications.initialize(
    settings:  settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap here
    },
  );

  // 5. Handle Permissions specifically for each platform
  if (Platform.isIOS) {
    await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (Platform.isAndroid) {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}
  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'driver_channel',
      'Driver Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: 1,
      
    title:   title,
     body:  body,
      notificationDetails:  notificationDetails,
    );
  }

  // ---------------- SOCKET ----------------

  Future<void> _connectSocket() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(socketUrl + prefs.getString('authToken')!),
      );
      _connected = true;
      notifyListeners();

      print("driver socket connected");

      _channel!.stream.listen(
        _onMessage,
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _connected = false;
        },
        onDone: () {
          debugPrint('WebSocket closed');
          _connected = false;
        },
      );
    } catch (e) {
      debugPrint('Socket error: $e');
    }
  }

  

  void _onMessage(dynamic message) {
    final data = jsonDecode(message);
    final event = data['event'];
    debugPrint('WS Event received: $event');
    debugPrint('WS Data: $data');

    switch (event) {
      case 'order_request':
        latestOrder = data['order'];
        _showNotification(
          'New Order Request 🚚',
          'You have a new delivery request',
        );
        notifyListeners();
        break;

      case 'order_accepted':
        _showNotification('Order Accepted ✅', 'You accepted an order');
        break;

      case 'order_cancelled':
        _showNotification('Order Cancelled ❌', 'Order has been cancelled');
        break;

      default:
        debugPrint('Unknown event: $event');
    }
  }

  void _onError(error) {
    debugPrint('Socket error: $error');
    _connected = false;
    notifyListeners();
  }

  void _onDisconnected() {
    debugPrint('Socket disconnected');
    _connected = false;
    notifyListeners();
  }

  // ---------------- LOCATION ----------------

  Future<void> _startLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // 🔁 update every 10 meters
          ),
        ).listen((position) {
          sendLocation(
            latitude: position.latitude,
            longitude: position.longitude,
          );
        });
  }

  // ---------------- SEND LOCATION ----------------

  void sendLocation({required double latitude, required double longitude}) {
    print("send location");
    if (!_connected || _channel == null) return;

    print(_channel);
    final payload = {
      "event": "location_update",
      "location": {"latitude": latitude, "longitude": longitude},
    };

    _channel!.sink.add(jsonEncode(payload));
  }

  // ---------------- CLEANUP ----------------

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }
}
