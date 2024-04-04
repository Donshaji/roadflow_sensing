import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }
}
