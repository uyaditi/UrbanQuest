import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iitb/Home.dart';
import 'package:iitb/Menu.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home1 extends StatefulWidget {
  const Home1({super.key});

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
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
        menuScreen: Menu(),
        mainScreen: Home(),
        borderRadius: 24,
        angle: 0,
        showShadow: true,
        mainScreenScale: 0.1,
        menuBackgroundColor: Color(0xFF83aabc),
    );
  }
}
