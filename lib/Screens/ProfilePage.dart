import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

import 'package:inner_joy/Screens/SettingsPage.dart';
import 'package:inner_joy/gadChartWidget.dart';
import 'package:inner_joy/phqChartWidget.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Adjust the height as needed
        child: AppBar(
          title: Text(''), // Add an empty title
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Color(0xFF694F79),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return SettingsPage();
                  },
                ));
              },
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/Background3.png'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey there,',
                        style: GoogleFonts.nunito( // Use Google Fonts
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF694F79),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Hope you're doing well today!",
                          style: GoogleFonts.nunito( // Use Google Fonts
                            fontSize: 18,
                            color: Color(0xFF694F79),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey,
                        margin: EdgeInsets.only(top: 18),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Depression Rate',
                        style: GoogleFonts.nunito( // Use Google Fonts
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF694F79),
                        ),
                      ),
                      SizedBox(height: 50),
                      phqChartWidget(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anxiety Rate',
                        style: GoogleFonts.nunito( // Use Google Fonts
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF694F79),
                        ),
                      ),
                      SizedBox(height: 50),
                      gadChartWidget(),
                    ],
                  ),
                ),
                // Add more widgets as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
