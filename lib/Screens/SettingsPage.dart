import 'package:flutter/material.dart';
import 'package:inner_joy/EditProfilePage.dart';
import 'package:inner_joy/PrivacyPolicyPage.dart';
import 'package:inner_joy/Screens/HomePage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF694F79)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(''), // Remove the title
        backgroundColor: Colors.transparent, // Remove the blue color
        elevation: 0, // Remove the shadow
      ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Background3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      height: 60,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to Edit Profile Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF694F79),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF694F79),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                    Container(
                      height: 60,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to Privacy Policy Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicyPage()),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF694F79),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF694F79),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Notifications',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF694F79)),
                            ),
                            Switch(
                              value: notificationsEnabled,
                              onChanged: (value) {
                                // Toggle notification setting
                                setState(() {
                                  notificationsEnabled = value;
                                });
                              },
                              activeTrackColor: Color(0xFF694F79),
                              activeColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB8A2B9), Color(0xFFA18AAE)],
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform logout action "navigate to the HomePage"
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => const HomePage()),
                      );
                    },
                    child: Text(
                      'Log Out',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

