import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iitb/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home1.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  late double _latitude;
  late double _longitude;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitude', _latitude);
      await prefs.setDouble('longitude', _longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        _latitude,
        _longitude,
      );

      String locationName = placemarks[0].name ?? 'Unknown Location';

      await prefs.setString('locationName', locationName);

      _printSharedPrefs(); // Call print after setting latitude and longitude
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  Future<void> _printSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    String? locationName = prefs.getString('locationName');

    print('Location Name: $locationName');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
  }

  void checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Fetch user's additional data (name and number) from Shared Preferences
      String? name = prefs.getString('name');
      String? number = prefs.getString('number');

      // Navigate to the home screen with user data as arguments
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home1(),
        ),
      );
    } else {
      // If the user is not logged in, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF572b78),
          child: SingleChildScrollView(
            child: Column(
              children: [
            Image(image: AssetImage("assets/intro.jpg"),width: double.infinity,),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover Your\nLocal Gems",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontFamily: 'crete',
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.only(right: 70),
                child: Text("UrbanQuest is your go-to app for effortless urban exploration, offering real-time insights into local hotspots, businesses, and exclusive offers.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'crete'
                  ),),
              ),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed: () {
                    checkUserLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffbb2f4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    minimumSize: Size(50.0, 50.0),  // Set the width and height to the same value
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 62,
              )
            ],
    ),
      ),
              ],
            ),
          ),
        ),
      //),
    );
  }
}
