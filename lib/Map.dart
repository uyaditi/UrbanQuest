import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'map2.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController _searchController = TextEditingController();
  bool isSearching = false; // Track search state
  String latitude = '';
  String longitude = '';
  late GeoCoordinates _initialCoordinates;
  late MapItemsExample _mapItemsExample;

  //late HereMapController _hereMapController;

  @override
  void initState() {
    super.initState();
    _getLocationFromSharedPreferences();

    double initialLatitude = 19.0760;
    double initialLongitude = 72.8777;
    _initialCoordinates = GeoCoordinates(initialLatitude, initialLongitude);
  }

  Future<void> _getLocationFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? storedLatitude = prefs.getDouble('latitude');
    double? storedLongitude = prefs.getDouble('longitude');

    if (storedLatitude != null && storedLongitude != null) {
      setState(() {
        latitude = storedLatitude.toString();
        longitude = storedLongitude.toString();
      });
    }
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      // Perform the API call with the search value
      _performApiSearch(value);
      print("api hit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            HereMap(onMapCreated: _onMapCreated),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius:1,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              color: Colors.white.withOpacity(0.2), // Adjust opacity here
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.black54),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: TextField(
                                      cursorColor: Colors.black54,
                                      controller: _searchController,
                                      onSubmitted: (value) {
                                        setState(() {
                                          isSearching = true;
                                        });
                                      },
                                      onChanged: (value1){
                                        if(value1.isEmpty){
                                          setState(() {
                                            isSearching = false;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Find Location",
                                        hintStyle: TextStyle(color: Colors.black54, fontFamily: "crete"),
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(color: Colors.black54, fontSize: 18.0,fontFamily: "crete"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    // Display additional UI based on search state
                    // isSearching ? _buildSearchResults() : _buildInterestContainers(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 13,
              child: FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  ZoomDrawer.of(context)!.toggle();
                },
                child: Icon(Icons.menu,color: Color(0xFF83aabc),),
                backgroundColor: Color(0xFFeaf3ff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
            (MapError? error) {
          if (error != null) {
            print('Map scene not loaded. MapError: ${error.toString()}');
            return;
          }

          const double distanceToEarthInMeters = 8000;
          MapMeasure mapMeasureZoom =
          MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);

          // can be set to users current location
          hereMapController.camera.lookAtPointWithMeasure(
              _initialCoordinates, mapMeasureZoom); // Set initial coordinates
        });
  }

  Future<void> _performApiSearch(String search) async {
    String apiKey = 'eLrKTK9d6Tm8OtM-0ee2-Gd1TQjuA0fm-yc7HM2GNpo';
    String apiUrl = 'https://discover.search.hereapi.com/v1/discover';
    String radius = '8000';

    String url =
        '$apiUrl?apikey=$apiKey&in=circle:$latitude,$longitude;r=$radius&q=$search';

    print(url);

    final response = await http.get(Uri.parse(url));
    print('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> items = data['items'];

      for (var index = 0; index < items.length; index++) {
        var item = items[index];
        double latitude = item['position']['lat'];
        double longitude = item['position']['lng'];
        String title = item['title'].toString();

        print('Title: $title, Latitude: $latitude, Longitude: $longitude');

        // Create GeoCoordinates for the fetched location.
        GeoCoordinates locationCoordinates =
        GeoCoordinates(latitude, longitude);

        _mapItemsExample.showAnchoredMapMarkers(locationCoordinates);
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch data');
    }
  }
}