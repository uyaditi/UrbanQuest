import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'explore.dart';
import 'map.dart';
import 'save.dart';
import 'setting.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  // Future<void> printLikedCards() async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   List<String>? likedCards = _prefs.getStringList('likedCards');
  //
  //   print(likedCards);
  //
  //   if (likedCards != null && likedCards.isNotEmpty) {
  //     print('Liked Cards:');
  //     likedCards.forEach((card) {
  //       print(card);
  //     });
  //   } else {
  //     print('No liked cards found.');
  //   }
  // }

  int _currentIndex = 0;

  List<Widget> _screens = [
    explore(),
    MapScreen(),
    Save(),
    setting(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 0,
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          Positioned(
            top: 65, // Adjust this value for positioning the FAB
            left: 15, // Adjust this value for positioning the FAB
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
               ZoomDrawer.of(context)!.toggle();
               //printLikedCards();
              },
              child: Icon(Icons.menu,color: Color(0xFF83aabc),), // Replace with your desired icon
              backgroundColor: Color(0xFFeaf3ff), // Change the background color as needed
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Changes the position of the shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 80,
            child: GNav(
              gap: 5,
              backgroundColor: Colors.white,
              color: Color(0xFF505255),
              activeColor: Color(0xFF83aabc),
              tabBackgroundColor: Color(0xFFeaf3ff),
              curve: Curves.easeOutExpo,
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.all(16),
              onTabChange: _onTabChange,
              tabs: [
                GButton(icon: Icons.explore, text: "Explore"),
                GButton(icon: Icons.map, text: "Map"),
                GButton(icon: Icons.bookmark, text: "Saved"),
                GButton(icon: Icons.settings, text: "Setting"),
              ],
              selectedIndex: _currentIndex,
            ),
          ),
        ),
      ),
    );
  }
}