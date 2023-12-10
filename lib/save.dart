import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Cards.dart';

class Save extends StatefulWidget {
  const Save({Key? key});

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> {
  List<Map<String, dynamic>> likedCards = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLikedCards();
  }

  Future<void> fetchLikedCards() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    List<String>? storedLikedCards = _prefs.getStringList('likedCards');

    if (storedLikedCards != null && storedLikedCards.isNotEmpty) {
      try {
        List<Map<String, dynamic>> decodedCards = storedLikedCards
            .map((card) => json.decode(card))
            .cast<Map<String, dynamic>>()
            .toList();

        setState(() {
          likedCards = decodedCards;
        });
      } catch (e) {
        print('Error decoding cards: $e');
      }
    }
  }

  Future<void> onRefresh() async {
    setState(() {
      isLoading = true; // Set loading state to true when initiating refresh
    });
    await fetchLikedCards(); // Fetch liked cards again
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Favourites",
                  style: TextStyle(
                    fontFamily: "crete",
                    fontSize: 40,
                    color: Color(0xFF83aabc),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: likedCards.isEmpty
                    ? RefreshIndicator(
                  onRefresh: onRefresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 300.0),
                        child: Text(
                          'No Favorites yet!',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: "crete",
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView.builder(
                    itemCount: likedCards.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> item = likedCards[index];
                      return Cards(
                        imagePath: item['imagePath'],
                        cafeName: item['cafeName'],
                        location: item['location'],
                        address: item['address'],
                        discount: item['discount'],
                        rating: item['rating'],
                        distance: item['distance'].toDouble(),
                        isLiked: true,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
