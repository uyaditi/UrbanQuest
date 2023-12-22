import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: AssetImage('assets/spa/spa1.jpg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Shop Name and Distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spa',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,fontFamily: "crete"),
                      ),
                      Text(
                        'Distance: 3400m', // Replace with actual distance
                        style: TextStyle(fontSize: 16,color: Color(0xFF83aabc),fontFamily: "crete"),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Andheri East",
                    style: TextStyle(fontFamily: "crete",fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A relaxing oasis for body and mind, Spa offers a range of rejuvenating treatments and therapies. Our spa provides a tranquil escape from the hustle and bustle, allowing you to unwind and revitalize your senses. With experienced therapists and luxurious amenities, Spa aims to provide a serene experience for your overall well-being.',
                    style: TextStyle(fontSize: 16,color: Colors.grey,fontFamily: "crete"),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Row with 2 Columns
                  Text(
                    "General Info",
                    style: TextStyle(fontFamily: "crete",fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Column 1
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.access_time,
                              ),
                              title: Text('Start Time: 9:00 AM',style: TextStyle(fontFamily: "crete",fontSize: 15),), // Replace with actual start time
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.access_time,
                              ),
                              title: Text('Close Time: 9:00 PM',style: TextStyle(fontFamily: "crete",fontSize: 15),), // Replace with actual start time
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.location_on,
                              ),
                              title: Text('Location: Greater Indra NGR-Mariyyman NGR',style: TextStyle(fontFamily: "crete",fontSize: 15),), // Replace with actual start time
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      // Column 2
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.punch_clock,
                              ),
                              title: Text('Duration: 1 hr',style: TextStyle(fontFamily: "crete",fontSize: 15),), // Replace with actual start time
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.discount,
                              ),
                              title: Text('Discount: 10%',style: TextStyle(fontFamily: "crete",fontSize: 15),), // Replace with actual start time
                            ),
                            SizedBox(height: 100,)// Replace with actual time
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Horizontal Dotted Line
                  Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Business Details",
                    style: TextStyle(fontFamily: "crete",fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                    ),
                    title: Text('Phone: +912261517555',style: TextStyle(fontFamily: "crete",fontSize: 15),), // Replace with actual start time
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.web,
                    ),
                    title: Text('Website: http://www.theleela.com/en_us/hotels-in-mumbai/the-leela-mumbai-hotel/spa/signature-spa-treatments',style: TextStyle(fontFamily: "crete",fontSize: 15),), // Replace with actual start time
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

