import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mister_twister/presentation/screens/private/common/map/controllers/map_controller.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _driverIcon;

  @override
  void initState() {
    super.initState();
    _loadDriverIcon();
  }

  /// 🖼 Load custom driver icon
  Future<void> _loadDriverIcon() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(96, 96)),
      'assets/images/driver_marker.png',
    );
    if (mounted) {
      setState(() => _driverIcon = icon);
    }
  }

  /// 📍 Build markers
  Set<Marker> _buildMarkers(MapVController controller) {
    final markers = <Marker>{};

    /// 👤 User marker
    if (controller.userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(
            controller.userLocation!.latitude,
            controller.userLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    /// 🚗 Driver markers
    for (int i = 0; i < controller.drivers.length; i++) {
      final driver = controller.drivers[i];
      markers.add(
        Marker(
          markerId: MarkerId('driver_$i'),
          position: LatLng(driver.latitude, driver.longitude),
          icon: _driverIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Driver ${i + 1}'),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MapVController>(
        builder: (context, controller, _) {
          /// ⏳ Wait for location
          if (controller.userLocation == null) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ✅ Trigger findDrivers ONCE
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.findDrivers(); // no params needed
          });

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                controller.userLocation!.latitude,
                controller.userLocation!.longitude,
              ),
              zoom: 14,
            ),
            onMapCreated: (mapController) {
              _mapController = mapController;
            },
            markers: _buildMarkers(controller),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
          );
        },
      ),
    );
  }
}
