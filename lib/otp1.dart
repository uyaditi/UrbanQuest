import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:iitb/intrest.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home1.dart';

class otp1 extends StatefulWidget {
  final String mobileNumber;
  final String Uid;

  otp1({required this.mobileNumber, required this.Uid});

  @override
  State<otp1> createState() => _otp1State();
}

class _otp1State extends State<otp1> {

  OtpFieldController otpController = OtpFieldController();

  bool _isLoading = false;
  String verificationId = "";
  bool _resendAvailable = false;
  int _resendTimer = 60;

  Timer? _resendCodeTimer;

  void _resendCode() {
    setState(() {
      _resendAvailable = false;
      _resendTimer = 60;
    });

    // Call the _verifyPhoneNumber method again to send OTP
    _verifyPhoneNumber(widget.mobileNumber);
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      this.verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
    };

    String formattedPhoneNumber = '+91${phoneNumber}';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: Duration(seconds: 60),
    );

    _resendCodeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _resendTimer--;
        if (_resendTimer <= 0) {
          _resendAvailable = true;
          _resendCodeTimer?.cancel();
        }
      });
    });

  }

  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        // If the document exists, return a Map containing the 'name' and 'number' fields
        return userSnapshot.data() as Map<String, dynamic>?;
      } else {
        // If the document doesn't exist, return null
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      String errorMessage = 'Error fetching user data. Please try again.';
      if (e is FirebaseAuthException) {
        errorMessage = 'Error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }
  }

  Future<void> saveUserData(String name, String number, String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('number', number);
    await prefs.setString('uid', uid);
    await prefs.setBool('isLoggedIn', true);
  }


  Future<void> _submitOTP(String otp) async {
    setState(() {
      _isLoading = true;
    });
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Save the verified number in Firestore
      final usersRef = FirebaseFirestore.instance.collection('users');

      final googleUserRef = usersRef.doc(widget.Uid); // Use the Google user's UID as the document ID
      await googleUserRef.update({
        'number': widget.mobileNumber,
      });

      Map<String, dynamic>? userData = await _getUserData(widget.Uid);

      if (userData != null) {
        String? userName = userData['name'] as String?;
        String? userNumber = userData['number'] as String?;

        await saveUserData(
            userName.toString().trim(),
            userNumber.toString().trim(),
            widget.Uid,
        );

        setState(() {
          _isLoading = false;
        });
        // Navigate to home page after verification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => intrest(Uid: widget.Uid)),
        );
      } }catch (e) {
      print('Error submitting OTP: $e');
      String errorMessage = 'Error verifying OTP. Please try again.';
      if (e is FirebaseAuthException) {
        errorMessage = 'Error: ${e.message}';
        // Clear the OTP TextField when the entered OTP is wrong
        if (e.code == 'invalid-verification-code') {
          otpController.clear();
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber(widget.mobileNumber);
  }

  @override
  void dispose() {
    _resendCodeTimer?.cancel();
    super.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Image(image: AssetImage("assets/otp.png"),width: double.infinity,),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontFamily: 'crete',
                  ),
                ),
              ),
              SizedBox(height: 35,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Please enter the 6 digit OTP sent to your phone number +91 ${widget.mobileNumber} for verification",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "crete",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: OtpTextField(
                  textStyle: TextStyle(color: Colors.white),
                  numberOfFields: 6,
                  enabledBorderColor: Colors.white24,
                  cursorColor: Colors.white24,
                  focusedBorderColor: Colors.white,
                  showFieldAsBox: true,
                  onCodeChanged: (String code) {
                  },
                  onSubmit : (pin) {
                    _submitOTP(pin);
                  },// end onSubmit
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffbb2f4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    minimumSize: Size(50.0, 50.0),  // Set the width and height to the same value
                  ),
                  child: _isLoading
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
                          text: _resendAvailable
                              ? "Didn't receive the OTP?"
                              : "Resend OTP in $_resendTimer seconds",
                        ),
                        TextSpan(
                          style: linkStyle,
                          text: " Resend OTP",
                          recognizer: TapGestureRecognizer()
                            ..onTap = _resendAvailable
                                ? () {
                              _resendCode();
                            }
                                : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 90,)
            ],
          ),
        ),
      ),
    );
  }
}
