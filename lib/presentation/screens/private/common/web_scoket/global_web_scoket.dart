import 'dart:convert';
import 'dart:io';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

/// 🔥 GLOBAL SOCKET PROVIDER
class GlobalSocketProvider extends ChangeNotifier {
  // -----------------------------
  // WebSocket
  // -----------------------------
  WebSocketChannel? _channel;
  bool _connected = false;

  bool get isConnected => _connected;

  // -----------------------------
  // Data holders
  // -----------------------------
  Map<String, dynamic>? currentOrder;
  List<Map<String, dynamic>> nearbyDrivers = [];
  String? lastEvent;

  // -----------------------------
  // Notifications
  // -----------------------------
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  GlobalSocketProvider() {
    _initNotifications();
    init();
  }

  // =============================
  // INIT NOTIFICATIONS
  // =============================
  Future<void> _initNotifications() async {
  // 1. Android Settings
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

  // 2. iOS (Darwin) Settings
  const darwinInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // 3. Combine Settings
  const initSettings = InitializationSettings(
    android: androidInit,
    iOS: darwinInit,
  );

  // 4. Initialize
  await _notifications .initialize(
   settings:  initSettings,
    onDidReceiveNotificationResponse: (details) {
      // Handle what happens when the user taps the notification
      print("Notification tapped: ${details.payload}");
    },
  );

  // 5. Explicit Permission Check (for Android 13+ and iOS)
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
  LatLng? driverLocation;
  int? trackedDriverId;

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'order_updates',
      'Order Updates',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: 2,
      title:  title,
     body:  body,
    notificationDetails:   details,
    );
  }

  init() async {
    final prefs = await SharedPreferences.getInstance();
    connect(prefs.getString('authToken') ?? '');
  }

  // =============================
  // CONNECT SOCKET
  // =============================
  void connect(String token) {
    if (_connected) return;

    final uri = Uri.parse('ws://api.mtsoftserve.com/ws/customer/?token=$token');

    _channel = WebSocketChannel.connect(uri);
    _connected = true;
    debugPrint('WebSocket connect: $_connected');

    _channel!.stream.listen(
      (data) {
        final decoded = jsonDecode(data);
        _handleEvent(decoded);
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
        _connected = false;
      },
      onDone: () {
        debugPrint('WebSocket closed');
        _connected = false;
      },
    );
  }

  // =============================
  // HANDLE EVENTS
  // =============================
  void _handleEvent(Map<String, dynamic> data) {
    lastEvent = data['event'];
    print(lastEvent);

    switch (data['event']) {
      /// 🚕 Nearby drivers
      case 'nearby_drivers':
        nearbyDrivers = List<Map<String, dynamic>>.from(data['drivers'] ?? []);

        _showNotification(
          title: 'Drivers Nearby 🚕',
          body: '${nearbyDrivers.length} drivers found near you',
        );
        break;

      /// 🔍 Finding drivers
      case 'finding_drivers':
        currentOrder = data['order'];

        _showNotification(
          title: 'Finding Driver',
          body: 'Searching for available drivers...',
        );
        break;

      /// ✅ Drivers found
      case 'drivers_found':
        currentOrder = data['order'];

        _showNotification(
          title: 'Driver Found',
          body: 'Drivers found for your order',
        );
        break;

      /// 🚚 Order accepted
      case 'order_accepted':
        currentOrder = data['order'];

        _showNotification(
          title: 'Order Accepted 🚚',
          body: 'A driver has accepted your order',
        );
        break;
      case 'driver_location_update':
        final location = data['location'];
        if (location != null) {
          driverLocation = LatLng(location['latitude'], location['longitude']);
          trackedDriverId = data['driver_id'];
        }
        break;
    }

    notifyListeners();
  }

  // =============================
  // SEND EVENTS
  // =============================
  void findDrivers({
    required double latitude,
    required double longitude,
    required int radius,
  }) {
    if (!_connected) return;

    final payload = {
      "event": "find_drivers",
      "location": {"latitude": latitude, "longitude": longitude},
      "radius": radius,
    };

    _channel!.sink.add(jsonEncode(payload));
  }

  // =============================
  // DISCONNECT
  // =============================
  void disconnect() {
    _channel?.sink.close(status.goingAway);
    _connected = false;
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
