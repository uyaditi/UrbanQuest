import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iitb/About.dart';
import 'package:iitb/Update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Login.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  String? Name;
  String selectedAvatar = "assets/avatars/a2.png";

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? '';

    setState(() {
      Name = name;
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  double _rating = 0.0;

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


  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadAvatarFromPrefs();
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate this app',style: TextStyle(fontFamily: "crete"),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: _rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text("Cancel",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "crete"
                      ),),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF83aabc),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      _showRatingSubmission(context);
                    },
                    child: Text('Submit',style: TextStyle(fontFamily: "crete"),),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRatingSubmission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rating Submitted',style: TextStyle(fontFamily: "crete"),),
          content: Text('You rated $_rating stars.',style: TextStyle(fontFamily: "crete"),),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF83aabc),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK',style: TextStyle(fontFamily: "crete"),),
            ),
          ],
        );
      },
    );
  }

  void _loadAvatarFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAvatar = prefs.getString('avatar');
    if (savedAvatar != null && savedAvatar.isNotEmpty) {
      setState(() {
        selectedAvatar = savedAvatar;
      });
    }
  }

  Widget _buildAvatarRow(SharedPreferences prefs, String imagePath) {
    return GestureDetector(
          onTap: () async {
            setState(() {
              selectedAvatar = imagePath;
            });
            await prefs.setString('avatar', imagePath);
            Navigator.of(context).pop();
          },
          child: Image.asset(imagePath, height: 60, width: 60),
        );
  }

  Future<void> _showAvatarSelectionDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Your Avatar',
            style: TextStyle(fontFamily: "crete"),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _buildAvatarRow(prefs, 'assets/avatars/a1.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a2.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a3.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a4.png'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    _buildAvatarRow(prefs, 'assets/avatars/a5.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a6.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a7.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a8.png'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    _buildAvatarRow(prefs, 'assets/avatars/a9.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a10.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a11.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a12.png'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    _buildAvatarRow(prefs, 'assets/avatars/a13.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a14.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a15.png'),
                    SizedBox(width: 10,),
                    _buildAvatarRow(prefs, 'assets/avatars/a16.png'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    String avatarText = _getAvatarText(Name);

    return Scaffold(
      backgroundColor: Color(0xFF83aabc),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  ZoomDrawer.of(context)!.toggle();
                },
                child: const Icon(Icons.close,color: Color(0xFF83aabc),), // Replace with your desired icon
                backgroundColor: const Color(0xFFeaf3ff), // Change the background color as needed
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: GestureDetector(
                onTap: (){
                  _showAvatarSelectionDialog(context);
                },
                  child: Image.asset(selectedAvatar,height: 100,width: 100,)
              ),
            ),
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Text(
                Name?.isNotEmpty == true ? Name! : 'Welcome User',
                style: TextStyle(fontFamily: "crete", fontSize: 20, color: Colors.white),
              ),
            ),
            SizedBox(height: 30,),
            ListTile(
              leading: Icon(
                Icons.home,color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "crete"
                ),
              ),
              onTap: (){
                ZoomDrawer.of(context)!.toggle();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,color: Colors.white,
              ),
              title: Text(
                "Account",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "crete"
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Update()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.star,color: Colors.white,
              ),
              title: Text(
                "Rating",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "crete"
                ),
              ),
              onTap: (){
                _showRatingDialog(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,color: Colors.white,
              ),
              title: Text(
                "About",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "crete"
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip, color: Colors.white,
              ),
              title: Text(
                "Privacy Policy",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "crete"
                ),
              ),
              onTap: () async {
                final url = Uri.parse("https://www.termsfeed.com/live/d53ac39f-fbdd-493c-87d9-d25ff96b4026");
                if(await canLaunchUrl(url)){
                  await launchUrl(url);
                }
              },
            ),
            SizedBox(height: 150,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        "Confirm Logout",
                        style: TextStyle(
                            fontFamily: "crete"
                        ),
                      ),
                      content: const Text("Are you sure you want to log out?",
                        style: TextStyle(
                            fontFamily: "crete"
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Cancel",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "crete"
                            ),),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF83aabc),
                          ),
                          onPressed: () async {
                            // Clear user data from Shared Preferences
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                            await prefs.remove('name');
                            await prefs.remove('number');
                            await prefs.remove('uid');
                            await prefs.remove('selectedChips');
                            await prefs.remove('latitude');
                            await prefs.remove('longitude');
                            await prefs.remove('locationName');
                            await prefs.remove('likedCards');

                            // Sign out from Firebase Auth and Google Sign-In (if applicable)
                            await FirebaseAuth.instance.signOut();
                            await _googleSignIn.signOut();

                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Login()),
                            );
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(fontFamily: "crete"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  minimumSize: const Size(50.0, 50.0),  // Set the width and height to the same value
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38.0),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Color(0xFF83aabc),
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
    );
  }
}



