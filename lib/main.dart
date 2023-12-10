import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:iitb/into.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';

import 'firebase_options.dart';

void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Set your credentials for the HERE SDK.
  String accessKeyId = "VZXztONdrrhyYGsIFgkFFw";
  String accessKeySecret =
      "rGo3jQhF9Vqgy7pLAwng2AVA8I1UG3fqnqWzJ2vhIEF1LZGPwxg1YSR6N1hZeVJQppZhLRbvlPUYw6SiR1z6tA";
  SDKOptions sdkOptions =
  SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _initializeHERESDK();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: splash(),
    debugShowCheckedModeBanner: false,
  ));

}

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => intro(),
        ),
      );
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
        child: Center(
          child: Lottie.asset(
            'assets/cmap.json',
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}

