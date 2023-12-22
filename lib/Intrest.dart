import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iitb/Home1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intrest extends StatefulWidget {
  final String Uid;

  Intrest({required this.Uid});

  @override
  State<Intrest> createState() => _IntrestState();
}

class _IntrestState extends State<Intrest> {
  List<String> selectedChips = [];
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveToFirestore(List<String> selectedChips) {
    String collectionName = 'users'; // Collection name in Firestore
    CollectionReference users = _firestore.collection(collectionName);

    // Create a document reference with the UID
    DocumentReference userDoc = users.doc(widget.Uid);

    // Retrieve the current document data
    userDoc.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic>? existingData = (docSnapshot.data() ?? {}) as Map<String, dynamic>?;
        // Update the existing data with the selectedChips field
        existingData?['selectedChips'] = selectedChips;

        // Update the document with merged data
        userDoc.set(existingData).then((value) async {
          print('Selected chips added to Firestore.');

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList('selectedChips', selectedChips);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home1()),
          );
        }).catchError((error) {
          print('Failed to add selected chips: $error');
        });
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF83aabc),
              Color(0xFF83aabc),
              Color(0xFF562a79),
              Color(0xFF562a79),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Image(image: AssetImage("assets/interest.png"), width: double.infinity),
            Center(
              child: Text(
                "What are your interests?",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontFamily: 'crete',
                ),
              ),
            ),
            SizedBox(height: 25,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Please select your interests, so we can help you discover the perfect places tailored just for you!",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "crete",
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30,),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: filterChips.map((chip) {
                bool isSelected = selectedChips.contains(chip);
                return FilterChip(
                  label: Text(chip,style: TextStyle(
                    fontFamily: "crete"
                  ),),
                  selected: isSelected,
                  backgroundColor: Colors.white24,
                  selectedColor: Color(0xFF83aabc), // Customize the selected color as desired
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedChips.add(chip);
                      } else {
                        selectedChips.remove(chip);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton(
                onPressed: () {
                  print('All Selected Chips: $selectedChips');
                  if (selectedChips.isNotEmpty) {
                    _saveToFirestore(selectedChips); // Save to Firestore if the list is not empty
                  } else {
                    _saveToFirestore(["Restaurants","Cafes","Malls"]); // Save an empty list to Firestore
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xfffbb2f4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  minimumSize: Size(50.0, 50.0),  // Set the width and height to the same value
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "crete",
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveToFirestore(["Restaurants","Cafes","Malls"]);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home1()),
          );
        },
        label: Text('Skip',style: TextStyle(
          color: Colors.black,
          fontFamily: "crete"
        ),),
        icon: Icon(Icons.skip_next,color: Colors.black,),
        backgroundColor: Color(0xfffbb2f4),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
