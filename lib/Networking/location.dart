import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location with ChangeNotifier {
  double? latitudeoflocation;
  double? longitudeoflocation;

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('locaation permission denied');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      print(position);
      latitudeoflocation = position.latitude;
      longitudeoflocation = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  Location() {
    getCurrentLocation();
  }
}
