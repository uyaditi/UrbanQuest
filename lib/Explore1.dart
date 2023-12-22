import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Cards.dart';
import 'Image_constant.dart';

class explore1 extends StatefulWidget {
  const explore1({Key? key}) : super(key: key);

  @override
  State<explore1> createState() => _explore1State();
}

class _explore1State extends State<explore1> {
  TextEditingController _searchController = TextEditingController();
  List<String> selectedChips = [];
  String latitude = '';
  String longitude = '';
  bool isSearching = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSelectedChips();
    _getLocationFromSharedPreferences();
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

  Future<void> _fetchSelectedChips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chips = prefs.getStringList('selectedChips');

    if (chips != null) {
      setState(() {
        selectedChips = chips;
      });
    }
  }



  Future<List<Map<String, dynamic>>> _fetchDataForInterest(String interest) async {
    String apiKey = 'eLrKTK9d6Tm8OtM-0ee2-Gd1TQjuA0fm-yc7HM2GNpo';
    String apiUrl = 'https://discover.search.hereapi.com/v1/discover';
    String radius = '8000';

    String url = '$apiUrl?apikey=$apiKey&in=circle:$latitude,$longitude;r=$radius&q=$interest';

    final response = await http.get(Uri.parse(url));
    print('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> items = data['items'];

      List<Map<String, dynamic>> parsedData = items.take(10).map((item) {
        String title = item['title'].toString();
        String address = item['address']['label'].toString();
        String district = item['address']['district'].toString();
        String subDistrict = item['address']['subdistrict'].toString();
        String distance = item['distance'].toString();

        return {
          'title': title,
          'location': '$district',
          'address': '$subDistrict',
          'distance': distance,
        };
      }).toList();

      return parsedData;
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch data');
    }
  }

  Widget _buildSearchResults() {
    List<String> images1 = [];

    if (_searchController.text.toLowerCase().contains('restaurant')) {
      images1 = ImageConstants.restaurant;
    } else if (_searchController.text.toLowerCase().contains('bar')) {
      images1 = ImageConstants.bar;
    } else if (_searchController.text.toLowerCase().contains('gym')) {
      images1 = ImageConstants.gym;
    } else if (_searchController.text.toLowerCase().contains('cafe')) {
      images1 = ImageConstants.cafe;
    } else if (_searchController.text.toLowerCase().contains('theater')) {
      images1 = ImageConstants.theaters;
    } else if (_searchController.text.toLowerCase().contains('spa')) {
      images1 = ImageConstants.spa;
    } else if (_searchController.text.toLowerCase().contains('mall')) {
      images1 = ImageConstants.mall;
    } else if (_searchController.text.toLowerCase().contains('bookstore')) {
      images1 = ImageConstants.bs;
    } else if (_searchController.text.toLowerCase().contains('art gallery')) {
      images1 = ImageConstants.ag;
    } else if (_searchController.text.toLowerCase().contains('museum')) {
      images1 = ImageConstants.museum;
    } else {
      images1 = ImageConstants.default1;
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchDataForInterest(_searchController.text),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (_searchController.text.isEmpty) {
          return _buildInterestContainers(); // Display default containers
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No search results available');
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _searchController.text.toUpperCase(),
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF83aabc),
                  fontWeight: FontWeight.bold,
                  fontFamily: "crete",
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: data.map((item) => Cards(
                    imagePath: images1.isNotEmpty ? images1[data.indexOf(item) % images1.length] : 'assets/default1/d1',
                    cafeName: item['title'],
                    location: item['location'],
                    address: item['address'],
                    discount: "10%", // Change as needed
                    rating: 4.5, // Change as needed
                    distance: double.parse(item['distance']), // Convert distance to double
                  )).toList(),
                ),
              ),
              SizedBox(height: 20,)
            ],
          );
        }
      },
    );
  }


  // Inside the _buildInterestContainers() method
  Widget _buildInterestContainers() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: selectedChips.length,
        itemBuilder: (BuildContext context, int index) {
          String currentInterest = selectedChips[index];
          List<String> images = [];

          if (currentInterest == 'Restaurants') {
            images = ImageConstants.restaurant;
          }
          else if (currentInterest == 'Bars') {
            images = ImageConstants.bar;
          }
          else if (currentInterest == 'Gyms') {
            images = ImageConstants.gym;
          }
          else if (currentInterest == 'Cafes') {
            images = ImageConstants.cafe;
          }
          else if (currentInterest == 'Theaters') {
            images = ImageConstants.theaters;
          }
          else if (currentInterest == 'Spa') {
            images = ImageConstants.spa;
          }
          else if (currentInterest == 'Malls') {
            images = ImageConstants.mall;
          }
          else if (currentInterest == 'Bookstores') {
            images = ImageConstants.bs;
          }
          else if (currentInterest == 'Art Galleries') {
            images = ImageConstants.ag;
          }
          else if (currentInterest == 'Museums') {
            images = ImageConstants.museum;
          }
          else{
            images = ImageConstants.default1;
          }


          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchDataForInterest(currentInterest),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data available');
              } else {
                List<Map<String, dynamic>> data = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentInterest,
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF83aabc),
                        fontWeight: FontWeight.bold,
                        fontFamily: "crete",
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: data.asMap().entries.map((entry) {
                          int dataIndex = entry.key;
                          Map<String, dynamic> item = entry.value;
                          return Cards(
                            imagePath: images[dataIndex % images.length],
                            cafeName: item['title'],
                            location: item['location'],
                            address: item['address'],
                            discount: "10%",
                            rating: 4.5,
                            distance: double.parse(item['distance']),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    setState(() {
      isLoading = true;
    });
    await _fetchSelectedChips();
    await _getLocationFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFf9f9f9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                  hintText: 'Find Location',
                                  hintStyle: TextStyle(color: Colors.black54,fontFamily: "crete"),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(color: Colors.black, fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  isSearching ? _buildSearchResults() : _buildInterestContainers(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
