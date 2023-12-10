import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'otp.dart';
import 'otp1.dart';

class extranumber extends StatefulWidget {
  final String uid;

  extranumber({required this.uid});

  @override
  State<extranumber> createState() => _extranumberState();
}

class _extranumberState extends State<extranumber> {

  bool _isLoading = false;

  TextEditingController numberController = TextEditingController();

  String? _numberError;
  bool _isFormValid = false;
  String? _number;


  void _validateForm() {
    setState(() {
      _numberError = _validateNumber(numberController.text.trim());
      _isFormValid =
          _numberError == null;

      if (_isFormValid) {
        _number = numberController.text.trim();
      }
    });
  }

  void _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('number', isEqualTo: _number)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists. Please login.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => otp1(mobileNumber: numberController.text,Uid:widget.uid)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), duration: Duration(seconds: 1)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToVerify(BuildContext context) {
    _validateForm();

    if (_isFormValid) {
      _registerUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly.'),duration: Duration(seconds: 2),),
      );
    }
  }


  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }

    if (value.contains(' ')) {
      return 'Please clear blank space';
    }

    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }

    return null;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    TextStyle defaultStyle = TextStyle(color: Colors.white, fontFamily: "crete");
    TextStyle linkStyle = TextStyle(color: Color(0xfffbb2f4),fontFamily: "crete");

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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Image(image: AssetImage("assets/num.png"),width: double.infinity,),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "Phone Verification",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: 'crete',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "Enter the phone number associated with your account and we'll send you an OTP for verification",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "crete",
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _numberError != null ? Colors.red : Colors.white, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, // Set the color you want for the error border
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, // Set the color you want for the focused error border
                            width: 2.0,
                          ),
                        ),
                        labelText: 'Mobile Number',
                        labelStyle: TextStyle(
                            color: _numberError != null ? Colors.red : Colors.white24,
                            fontFamily: "crete"
                        ),
                        floatingLabelStyle: TextStyle(
                            color: _numberError != null ? Colors.red : Colors.white,
                            fontFamily: "crete"
                        ),
                        errorText: _numberError,
                        suffixIcon: Icon(Icons.phone),
                        suffixIconColor: MaterialStateColor.resolveWith((states) =>
                        states.contains(MaterialState.focused) ? (_numberError != null ? Colors.red : Colors.white)
                            : Colors.white24,
                        )
                    ),
                    onChanged: (value) {
                      setState(() {
                        _numberError = _validateNumber(value);
                      });
                    },
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    onPressed: () => _navigateToVerify(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xfffbb2f4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      minimumSize: Size(50.0, 50.0),  // Set the width and height to the same value
                    ),
                    child: _isLoading // Show CircularProgressIndicator if _isLoading is true
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Text(
                        "Verify",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "crete",
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: defaultStyle,
                        children: [
                          TextSpan(
                            text: "Already have an account?",
                          ),
                          TextSpan(
                            style: linkStyle,
                            text: " Login here",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => login()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
