import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Image(image: AssetImage("assets/about.png"),width: double.infinity,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      "Discover Your Urban Playground with UrbanQuest",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontFamily: 'crete',
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text("Welcome to UrbanQuest, your guide to exploring the heartbeat of your city! We're dedicated to connecting you with the pulse of local businesses, events, and hidden gems. Whether you're seeking the hottest cafes, trendy boutiques, exciting events, or unique experiences, UrbanQuest is your companion to uncovering the vibrant tapestry of your urban landscape.\n\n With our passion for community and support for local businesses, UrbanQuest empowers you to delve into your city's diverse tapestry while supporting the heartbeat of your community. Join us in discovering the endless adventures and hidden treasures your city has to offer!\n\nFeel free to customize the description to better fit the tone, mission, and specific features of your UrbanQuest app. This description highlights the essence of exploration, community support, and the app's role in connecting users to their local urban environment.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'crete'
                      ),),
                    SizedBox(
                      height: 62,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      //),
    );
  }
}
