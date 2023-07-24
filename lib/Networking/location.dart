import 'package:geolocator/geolocator.dart';

class Location {
  double? latitudeoflocation;
  double? longitudeoflocation;

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitudeoflocation = position.latitude;
      longitudeoflocation = position.longitude;
      if (permission == LocationPermission.denied) {
        print('locaation permission denied');
      }
    } catch (e) {
      print(e);
    }
  }
}
