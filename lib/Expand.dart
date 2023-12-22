import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:  BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/spa/spa1.jpg'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20, // Adjust this value as needed for positioning
                  right: 20, // Adjust this value as needed for positioning
                  child: FloatingActionButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    child: Icon(Icons.bookmark),
                    backgroundColor: Color(0xFF83aabc),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(height: 20,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

