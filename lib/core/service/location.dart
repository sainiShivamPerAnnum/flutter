import 'dart:async';

import 'package:geolocator/geolocator.dart';

// THIS CLASS GETS ALL THE LOCATION SERVICES
class Location {
  double latitude;
  double longitude;
  bool serviceEnabled;
  LocationPermission permission;

  var geoLocator = Geolocator();

  LocationOptions locationOptions;

  Future<Map<dynamic, dynamic>> getCurrentLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium);

        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        print(e);
      }
    }
  }
}
