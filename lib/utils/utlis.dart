import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

String timeAgo(String dateTimeString) {
  try {
    // Parse the ISO8601 string to DateTime
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final now = DateTime.now();

    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // Return full date for older times
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  } catch (e) {
    return ''; // fallback if parsing fails
  }
}

Future<void> openMap(double latitude, double longitude) async {
  final googleMapUrl = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
  );

  if (await canLaunchUrl(googleMapUrl)) {
    await launchUrl(googleMapUrl);
  } else {
    throw 'Could not open the map at $latitude,$longitude';
  }
}

double calculateDistanceKm({required LatLng from, required LatLng to}) {
  final distance = Distance();
  return distance.as(LengthUnit.Kilometer, from, to);
}
