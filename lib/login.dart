import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iitb/otp.dart';
import 'package:iitb/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  bool _isLoading = false;

  TextEditingController numberController = TextEditingController();

  bool _isSwitched = false;

  String? _numberError;
  bool _isFormValid = false;


  void _validateForm() {
    setState(() {
      _numberError = _validateNumber(numberController.text);

      _isFormValid =
          _numberError == null;
    });
  }

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  void _loadRememberedNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = prefs.getBool('rememberMe') ?? false;
      if (_isSwitched) {
        String? rememberedNumber = prefs.getString('rememberedNumber');
        if (rememberedNumber != null && rememberedNumber.isNotEmpty) {
          numberController.text = rememberedNumber;
          _numberError = _validateNumber(rememberedNumber);
          _isFormValid = _numberError == null;
        }
      }
    });
  }

  void _onRememberMeChanged(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = value;
      if (_isSwitched) {
        // If "Remember me" is checked, save the number in Shared Preferences
        prefs.setString('rememberedNumber', numberController.text.trim());
        prefs.setBool('rememberMe', true);
      } else {
        // If "Remember me" is unchecked, remove the number from Shared Preferences
        prefs.remove('rememberedNumber');
        prefs.setBool('rememberMe', false);
      }
    });
  }

  Future<String?> _checkNumberExists(String number) async {
    try {
      // Query Firestore to check if the provided number exists in the 'users' collection
      QuerySnapshot snapshot = await usersCollection.where('number', isEqualTo: number).get();

      // If the snapshot contains any documents, it means the number exists
      if (snapshot.docs.isNotEmpty) {
        // Return the document UID of the first document where the number is found
        return snapshot.docs.first.id;
      }
      return null; // Return null if the number is not found in any document
    } catch (e) {
      // Handle any errors during the Firestore query
      print('Error checking number existence: $e');
      return null; // Assume the number doesn't exist in case of an error
    }
  }

  void _navigateToHome(BuildContext context) async {
    _validateForm();

    if (_isFormValid) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      try {
        // Get the user's input number
        String userNumber = numberController.text.trim();

        // Check if the user's input number exists in Firestore
        String? documentUID = await _checkNumberExists(userNumber);

        if (documentUID != null) {
          // If the number exists, navigate to the verify1 screen and pass the document UID
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => otp(mobileNumber: userNumber, documentUID: documentUID)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Number not found. Please register first.')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => register()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), duration: Duration(seconds: 2),),
        );
      } finally {
        setState(() {
          _isLoading = false; // Set loading state to false after the transition is complete
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly.')),
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
    _loadRememberedNumber();
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
                Image(image: AssetImage("assets/logiin.png"),width: double.infinity,),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "Login To Your Account",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'crete',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "Enter the registered phone number to verify your login.",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "crete",
                    ),
                    textAlign: TextAlign.center,
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
                        fontFamily: "crete",
                      ),
                      floatingLabelStyle: TextStyle(
                        color: _numberError != null ? Colors.red : Colors.white,
                        fontFamily: "crete",
                      ),
                      errorText: _numberError,
                      suffixIcon: Icon(Icons.phone),
                      suffixIconColor: MaterialStateColor.resolveWith(
                            (states) => states.contains(MaterialState.focused) ? (_numberError != null ? Colors.red : Colors.white) : Colors.white24,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _numberError = _validateNumber(value);
                      });
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Row(
                    children: [
                      Switch(
                        value: _isSwitched,
                        onChanged: _onRememberMeChanged,
                        activeColor: Colors.white,
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "crete"
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    onPressed: () => _navigateToHome(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xfffbb2f4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      minimumSize: Size(50.0, 50.0),  // Set the width and height to the same value
                    ),
                    child: _isLoading // Show CircularProgressIndicator if _isLoading is true
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                        )
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38.0),
                          child: Text(
                      "Login",
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
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: defaultStyle,
                        children: [
                          TextSpan(
                            text: "Don't have an account?",
                          ),
                          TextSpan(
                            style: linkStyle,
                            text: " Register here",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => register()
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80,)
              ],
          ),
        ),
      ),
    );
  }
}
