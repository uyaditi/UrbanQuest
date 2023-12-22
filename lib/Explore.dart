import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Cards.dart';
import 'Image_constant.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore>{

  String? Name;

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? '';

    setState(() {
      Name = name;
    });
  }

  TextEditingController _searchController = TextEditingController();
  List<String> selectedChips = [];
  String latitude = '';
  String longitude = '';
  bool isSearching = false;
  bool isLoading = false;

  late String firstSelectedChip = '';

  @override
  void initState() {
    super.initState();
    _fetchSelectedChips();
    _getLocationFromSharedPreferences();
    _fetchUserData();
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

    if (chips != null && chips.isNotEmpty) {
      setState(() {
        selectedChips = chips;
        firstSelectedChip = selectedChips.first;
        updateFilterChips();
        selectedChipIndex = filterChips.indexOf(firstSelectedChip);
        selectedChipName = filterChips[selectedChipIndex];
      });
    } else {
      setState(() {
        firstSelectedChip = filterChips.isNotEmpty ? filterChips.first : '';
        updateFilterChips();
        selectedChipIndex = filterChips.indexOf(firstSelectedChip);
        selectedChipName = filterChips[selectedChipIndex];
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

  void updateFilterChips() {
    List<String> updatedFilterChips = List.of(filterChips);
    selectedChips.forEach((chip) {
      updatedFilterChips.remove(chip);
    });
    updatedFilterChips.insertAll(0, selectedChips);
    setState(() {
      filterChips = updatedFilterChips;
    });
  }

  List<String> filterChips = [
    'Restaurants',
    'Bars',
    'Cafes',
    'Theaters',
    'Spa',
    'Gyms',
    'Malls',
    'Bookstores',
    'Art Galleries',
    'Museums'
  ];

  int selectedChipIndex = 0;
  String selectedChipName = '';

  Widget _buildCategoryText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Text(
        'Categories',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: "crete"
        ),
      ),
    );
  }


  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 5, bottom: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filterChips.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedChipIndex = index;
                  selectedChipName = filterChips[index];
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      filterChips[index],
                      style: TextStyle(
                        color: selectedChipIndex == index ? Color(0xFF83aabc) : Colors.black,
                        fontSize: 18,
                        fontFamily: "crete",
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: selectedChipIndex == index ? Color(0xFF83aabc) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
  

  Widget _buildInterestContainer() {
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
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> item = data[index];
                        int randomDiscount1 = 5 + (index * 7) % 16;
                        double randomRating1 = 3 + (index * 11) % 3;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Cards(
                            imagePath: images1.isNotEmpty ? images1[data.indexOf(item) % images1.length] : 'assets/default1/d1',
                            cafeName: item['title'],
                            location: item['location'],
                            address: item['address'],
                            discount: "$randomDiscount1%",
                            rating: randomRating1,
                            distance: double.parse(item['distance']),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 90,)
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildCategoryContainer(String Category) {
    List<String> images = [];

    if (Category == 'Restaurants') {
      images = ImageConstants.restaurant;
    }
    else if (Category == 'Bars') {
      images = ImageConstants.bar;
    }
    else if (Category == 'Gyms') {
      images = ImageConstants.gym;
    }
    else if (Category == 'Cafes') {
      images = ImageConstants.cafe;
    }
    else if (Category == 'Theaters') {
      images = ImageConstants.theaters;
    }
    else if (Category == 'Spa') {
      images = ImageConstants.spa;
    }
    else if (Category == 'Malls') {
      images = ImageConstants.mall;
    }
    else if (Category == 'Bookstores') {
      images = ImageConstants.bs;
    }
    else if (Category == 'Art Galleries') {
      images = ImageConstants.ag;
    }
    else if (Category == 'Museums') {
      images = ImageConstants.museum;
    }
    else{
      images = ImageConstants.default1;
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchDataForInterest(Category),
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
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> item = data[index];
                        int randomDiscount = 5 + (index * 7) % 16;
                        double randomRating = 3 + (index * 11) % 3;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Cards(
                            imagePath: images.isNotEmpty ? images[data.indexOf(item) % images.length] : 'assets/default1/d1',
                            cafeName: item['title'],
                            location: item['location'],
                            address: item['address'],
                            discount: "$randomDiscount%",
                            rating: randomRating,
                            distance: double.parse(item['distance']),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 220,)
              ],
            ),
          );
        }
      },
    );
  }

  String _getAvatarText(String? name) {
    if (name != null && name.isNotEmpty) {
      List<String> nameParts = name.split(' ');
      if (nameParts.length >= 2) {
        return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
      } else {
        return nameParts[0][0].toUpperCase() + 'U';
      }
    } else {
      return 'WU';
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
    _fetchSelectedChips(),
    _getLocationFromSharedPreferences(),
    _fetchUserData(),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String avatarText = _getAvatarText(Name);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await _refreshData();
        },
        child: Stack(
          children: [
            // Background image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/bbg7.jpg",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      ZoomDrawer.of(context)!.toggle();
                    },
                    child: CircleAvatar(
                      radius: 35.0,
                      backgroundColor: Color(0xFFeaf3ff),
                      child: Text(
                        "AS",
                        style: TextStyle(fontSize: 24.0, color: Color(0xFF86b8fe)),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi,',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: "crete",
                        ),
                      ),
                      Text(
                          Name?.isNotEmpty == true ? Name! : 'User',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontFamily: "crete",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 180,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius:5,
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
                          Icon(Icons.search, color: Colors.white70),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextField(
                              cursorColor: Colors.white70,
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
                                hintStyle: TextStyle(color: Colors.white70, fontFamily: "crete"),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white, fontSize: 18.0,fontFamily: "crete"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 250, // Adjust the top position of the container
              left: 0,
              right: 0,
              child: Container(
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: isSearching ? _buildInterestContainer() : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryText(),
                    _buildFilterChips(),
                    _buildCategoryContainer(selectedChipName),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
