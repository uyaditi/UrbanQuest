import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iitb/home.dart';
import 'package:iitb/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';


class home1 extends StatefulWidget {
  const home1({super.key});

  @override
  State<home1> createState() => _home1State();
}

class _home1State extends State<home1> {
  // late double _latitude;
  // late double _longitude;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _getUserLocation();
  // }

  // Future<void> _getUserLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //
  //     setState(() {
  //       _latitude = position.latitude;
  //       _longitude = position.longitude;
  //     });
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setDouble('latitude', _latitude);
  //     await prefs.setDouble('longitude', _longitude);
  //
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       _latitude,
  //       _longitude,
  //     );
  //
  //     String locationName = placemarks[0].name ?? 'Unknown Location';
  //
  //     await prefs.setString('locationName', locationName);
  //
  //     _printSharedPrefs(); // Call print after setting latitude and longitude
  //   } catch (e) {
  //     print('Error getting user location: $e');
  //   }
  // }
  //
  // Future<void> _printSharedPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? selectedChips = prefs.getStringList('selectedChips');
  //   double? latitude = prefs.getDouble('latitude');
  //   double? longitude = prefs.getDouble('longitude');
  //   String? locationName = prefs.getString('locationName');
  //
  //   print('Location Name: $locationName');
  //   print('Selected Chips: $selectedChips');
  //   print('Latitude: $latitude');
  //   print('Longitude: $longitude');
  // }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        menuScreen: menu(),
        mainScreen: home(),
        borderRadius: 24,
        angle: 0,
        showShadow: true,
        mainScreenScale: 0.1,
        menuBackgroundColor: Color(0xFF83aabc),
    );
  }
}
