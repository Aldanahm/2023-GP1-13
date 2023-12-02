import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inner_joy/Screens/gad7_questions.dart';
import 'package:inner_joy/Screens/phq9_questions.dart';

class PhqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 45),
                Text(
                  'Well-being Check',
                  style: GoogleFonts.nunito(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF694F79),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Explore Our Mental Health Tests',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Color(0xFF694F79),
                  ),
                ),
                SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Depression.png',
                        width: 150,
                        height: 150,
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PHQ9Questions(),
                              ),
                            );
                          },
                          child: Text('Depression Test',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25,
                              )),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF694F79).withOpacity(0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Anxiety.png',
                        width: 150,
                        height: 150,
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GAD7Questions(),
                              ),
                            );
                          },
                          child: Text('Anxiety Test',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25,
                              )),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF694F79).withOpacity(0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
