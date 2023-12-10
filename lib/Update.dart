import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

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

  Future<void> _updateUserData() async {
    // Fetching UID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    List<String>? selectedChip = prefs.getStringList('selectedChips');

    if (uid != null) {
      // Get new data from input fields
      String newName = nameController.text.trim();
      String newEmail = emailController.text.trim();
      String newNumber = numberController.text.trim();

      if (selectedChips.isEmpty) {
        selectedChips = selectedChip!;
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': newName,
        'number': newNumber,
        'email': newEmail,
        'selectedChips': selectedChips,
      });

      prefs.setString('name', newName);
      prefs.setStringList('selectedChips', selectedChips);
      // Show success message or handle navigation
      // For example, show a SnackBar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User data updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
              Image(image: AssetImage("assets/update.png"),width: double.infinity,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Update Your Account",
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
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Choose your interests:",
                    style: TextStyle(
                      fontFamily: "crete",
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
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
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  onPressed: () {
                    _validateForm();

                    if (_isFormValid) {
                      _updateUserData();
                      Future.delayed(Duration(seconds: 4), () {
                        Navigator.pop(context);
                      });
                    }
                  },
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
                      "Update",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "crete",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
