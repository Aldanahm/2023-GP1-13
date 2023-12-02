import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inner_joy/Screens/phq9_results_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PHQ9Questions extends StatefulWidget {
  @override
  _PHQ9QuestionsState createState() => _PHQ9QuestionsState();
}

class _PHQ9QuestionsState extends State<PHQ9Questions> {
  int currentQuestionIndex = 0;
  List<int> userResponses = List.filled(9, -1);

  List<String> questions = [
    "Do you have little interest or pleasure in doing things? \nFor example, imagine engaging in activities that used to bring joy, now there's disinterest or absence of pleasure.",
    "Have you recently been feeling down, depressed, or hopeless?",
    "Do you have trouble falling or staying asleep, or sleeping too much?",
    "Are you constantly feeling tired or having little energy? \nLike you're going about your routine, a lack of energy makes even simple tasks feel exhausting.",
    "Do you experience poor appetite or find yourself overeating?",
    "Are there recurring thoughts of feeling bad about yourself or believing you are a failure or have let yourself or your family down?",
    "Do you face trouble concentrating on things, such as reading or watching television?",
    "Are often moving or speaking so slowly that other people could have noticed, or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?",
    "Do you encounter thoughts that you would be better off dead or of hurting yourself in some way?"
  ];

  void answerQuestion(int response) async {
    userResponses[currentQuestionIndex] = response;
    if (currentQuestionIndex < 8) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      int totalScore = userResponses.reduce((a, b) => a + b);

      // Get the current date
      DateTime now = DateTime.now();
      int year = now.year;
      int month = now.month;

      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid; // Retrieve the user ID from Firebase Auth

        // Reference to the Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Reference to the user's document
        DocumentReference userDoc = firestore.collection('users').doc(userId);

        // Get the existing data of the user's document
        final userDocSnapshot = await userDoc.get();
        final Map<String, dynamic>? userData =
            userDocSnapshot.data() as Map<String, dynamic>?;

        // Prepare a map with the new data
        Map<String, dynamic> data = {
          'latestPHQScore': totalScore,
        };

        // If the user document exists, update the data
        if (userData != null) {
          if (userData['phqScores'] == null) {
            data['phqScores'] = [];
          } else {
            data['phqScores'] = List.from(userData['phqScores'] as List);
          }
          data['phqScores'].add({
            'totalScore': totalScore,
            'year': year,
            'month': month,
          });
          // Add the username to the data if it's present
          if (userData['username'] != null) {
            data['username'] = userData['username'];
          }
        }

        // Update the user's document in Firestore
        userDoc.set(data);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PHQResultsPage(totalScore as int),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: null,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF694F79),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Question ${currentQuestionIndex + 1} of 9',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF694F79),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  questions[currentQuestionIndex],
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    color: Color(0xFF694F79),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
              margin: EdgeInsets.only(bottom: 15),
            ),
            for (int i = 0; i < 4; i++)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFFA18AAE), // Bottom-left color
                          Color(0xFFB8A2B9), // Top-right color
                        ],
                      ),
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
                        answerQuestion(i);
                      },
                      child: Text(
                        [
                          'Not at all',
                          'Several days',
                          'More than half the days',
                          'Nearly every day'
                        ][i],
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.transparent,
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
