import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location with ChangeNotifier {
  double? latitudeoflocation;
  double? longitudeoflocation;
  // Future<void> getPermission() async {
  //   try {

  //     print(permission);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      print('lma0');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print('location');
      print(position.latitude);
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
