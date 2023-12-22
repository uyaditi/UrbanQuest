import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iitb/Expand.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'expanded.dart';

class Cards extends StatefulWidget {

  final String imagePath;
  final String cafeName;
  final String location;
  final String address;
  final String discount;
  final double rating;
  final double distance;
  final bool isLiked;

  Cards({
    required this.imagePath,
    required this.cafeName,
    required this.location,
    required this.address,
    required this.discount,
    required this.rating,
    required this.distance,
    this.isLiked = false,
  });

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  bool _isLiked = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _printLikedCards() async {
    List<String>? likedCards = _prefs.getStringList('likedCards');
    if (likedCards != null) {
      print('Liked Cards:');
      likedCards.forEach((card) {
        print(card);
      });
    } else {
      print('No liked cards found.');
    }
  }

  Future<void> _saveLikedCard() async {
    List<String>? likedCards = _prefs.getStringList('likedCards');

    Map<String, dynamic> newCard = {
      'imagePath': widget.imagePath,
      'cafeName': widget.cafeName,
      'location': widget.location,
      'address': widget.address,
      'discount': widget.discount,
      'rating': widget.rating,
      'distance': widget.distance,
    };

    if (likedCards == null) {
      likedCards = [];
    } else {
      likedCards = likedCards.cast<String>().toList();
    }

    if (_isLiked) {
      likedCards.add(json.encode(newCard));
    } else {
      likedCards.removeWhere((card) =>
      json.decode(card)['cafeName'] == widget.cafeName); // Adjust the condition for uniqueness
    }

    await _prefs.setStringList('likedCards', likedCards);

    //_printLikedCards(); // Print the updated list of liked cards
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.cafeName == "Spa") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InfoCard()),
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          width: 340,
          height: 300,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FractionallySizedBox(
                          heightFactor: 1.0,
                          child: ClipRect(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  image: AssetImage(widget.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            color: Colors.black.withOpacity(0.5),
                            child: Text(
                              widget.discount,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,fontFamily: "crete"
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    widget.cafeName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,fontFamily: "crete"),
                                  ),
                                ),
                              ),
                              Text(
                                '${widget.distance}m',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,fontFamily: "crete"
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    widget.location,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,fontFamily: "crete"
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    widget.address,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,fontFamily: "crete"
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.amber, // Star color
                                  ),
                                  Text(
                                    '${widget.rating}', // Rating number
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,fontFamily: "crete"
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                    _saveLikedCard();
                  },
                  child: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked
                        ? Colors.red
                        : Colors.white, // Initial grey color
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