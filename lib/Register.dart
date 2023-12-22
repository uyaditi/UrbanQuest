import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iitb/Login.dart';

import 'Extranumber.dart';
import 'Otp.dart';
import 'Otp1.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading1 = true;
    });
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);

        final user = authResult.user;
        if (user != null) {
          String email = user.email ?? '';
          String name = user.displayName ?? '';
          String phoneNumber = user.phoneNumber ?? '';
          String uid = user.uid; // Get the UID of the signed-in user

          // Check if the email already exists in Firestore
          final usersRef = FirebaseFirestore.instance.collection('users');
          final querySnapshot = await usersRef.where('email', isEqualTo: email).get();

          if (querySnapshot.size == 0) {
            // Email doesn't exist in Firestore, so save the data
            final userRef = usersRef.doc(uid); // Use the UID as the document ID
            await userRef.set({
              'email': email,
              'name': name,
              'number': phoneNumber,
            });
          }

          setState(() {
            _isLoading1 = false;
          });

          if (phoneNumber == "" ) {
            await FirebaseAuth.instance.signOut();
            await _googleSignIn.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => extranumber(uid: uid)),
            );
          }else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Otp1(mobileNumber: phoneNumber, Uid: uid,)),
            );
          }
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
    finally {
      setState(() {
        _isLoading1 = false;
      });
    }
  }


  bool _isLoading = false;
  bool _isLoading1 = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();


  String? _nameError;
  String? _emailError;
  String? _numberError;
  bool _isFormValid = false;

  String? _name;
  String? _email;
  String? _number;


  void _validateForm() {
    setState(() {
      _nameError = _validateName(nameController.text.trim());
      _emailError = _validateEmail(emailController.text.trim());
      _numberError = _validateNumber(numberController.text.trim());
      _isFormValid =
          _nameError == null && _emailError == null && _numberError == null;

      if (_isFormValid) {
        _name = nameController.text.trim();
        _email = emailController.text.trim();
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
          .where('email' , isEqualTo: _email)
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
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        DocumentReference newUserDocRef = await FirebaseFirestore.instance.collection('users').add({
          'name': _name,
          'email': _email,
          'number': _number,
        });


        setState(() {
          _isLoading = false;
        });

        String documentUID = newUserDocRef.id;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Otp1(mobileNumber: numberController.text, Uid: documentUID,)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), duration: Duration(seconds: 2)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }




  void _navigateToHome(BuildContext context) {
    _validateForm();

    if (_isFormValid) {
      _registerUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly.'),duration: Duration(seconds: 2),),
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email format';
    }
    return null;
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
      body: SingleChildScrollView(
        child: Container(
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
              SizedBox(height: 20,),
              Image(image: AssetImage("assets/signup.png"),width: double.infinity,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Create New Account",
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
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: nameController,
                  cursorColor: Colors.white24,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _nameError != null ? Colors.red : Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Enter your name',
                      labelStyle: TextStyle(
                          color: _nameError != null ? Colors.red : Colors.white24,
                          fontFamily: "crete"
                      ),
                      floatingLabelStyle: TextStyle(
                          color: _nameError != null ? Colors.red : Colors.white,
                          fontFamily: "crete"
                      ),
                      errorText: _nameError,
                      suffixIcon: Icon(Icons.person),
                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.focused) ? (_nameError != null ? Colors.red : Colors.white)
                          : Colors.white24,
                      )
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nameError = _validateName(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white24,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _emailError != null ? Colors.red : Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: _emailError != null ? Colors.red : Colors.white24,
                          fontFamily: "crete"
                      ),
                      floatingLabelStyle: TextStyle(
                          color: _emailError != null ? Colors.red : Colors.white,
                          fontFamily: "crete"
                      ),
                      errorText: _emailError,
                      suffixIcon: Icon(Icons.email),
                      suffixIconColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.focused) ? (_emailError != null ? Colors.red : Colors.white)
                          : Colors.white24,
                      )
                  ),
                  onChanged: (value) {
                    setState(() {
                      _emailError = _validateEmail(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: numberController,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  cursorColor: Colors.white24,
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
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
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
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  onPressed: () => _navigateToHome(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffbb2f4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    minimumSize: Size(50.0, 50.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 38.0),
                        child: Text(
                    "Register",
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
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child:
                  Center(
                      child: Text(
                          "-OR-",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "crete",
                          )
                      )
                  )
              ),
              Center(
                  child: Text(
                      "Register With",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "crete",
                      )
                  )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _handleGoogleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfffbb2f4),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading1
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            :Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Image.asset("assets/google.png", width: 24, height: 24), // Your Google icon
                            SizedBox(width: 10),
                            Text(
                              "Register with Google",
                              style: TextStyle(
                                fontFamily: "crete",
                                fontSize: 16,
                                color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
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
                                MaterialPageRoute(builder: (context) => Login()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
