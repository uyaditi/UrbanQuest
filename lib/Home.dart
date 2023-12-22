import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

import 'package:iitb/Events.dart';
import 'package:iitb/Explore.dart';
import 'Map.dart';
import 'Save.dart';
import 'Setting.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  List<Widget> _screens = [
    Explore(),
    MapScreen(),
    Events(),
    Save(),
    Setting(),
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
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 16.0), // Add bottom margin here
        child: CustomNavigationBar(
          iconSize: 30.0,
          selectedColor: Colors.white,
          strokeColor: Colors.white,
          unSelectedColor: Colors.grey[600],
          backgroundColor: Colors.black,
          borderRadius: Radius.circular(20.0),
          blurEffect: true,
          opacity: 0.8,
          items: [
            CustomNavigationBarItem(
              icon: Icon(
                Icons.explore,
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(
                Icons.map,
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(
                Icons.event,
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(
                Icons.bookmark,
              ),
            ),
            CustomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          isFloating: true,
        ),
      ),
    );
  }
}
