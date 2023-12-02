import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inner_joy/Screens/gad7_results_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GAD7Questions extends StatefulWidget {
  @override
  _GAD7QuestionsState createState() => _GAD7QuestionsState();
}

class _GAD7QuestionsState extends State<GAD7Questions> {
  int currentQuestionIndex = 0;
  List<int> userResponses = List.filled(7, -1);

  List<String> questions = [
    "Do you feel nervous, anxious, or on edge? \nImagine sitting at your desk, feeling uneasy, making it hard to concentrate on work.",
    "Are you not able to stop or control worrying? \nPicture trying to unwind in the evening, but persistent worries about the future make relaxation difficult.",
    "Do you worry too much about different things? \nLike you're going about your day, persistent thoughts of potential problems make it challenging to stay present.",
    "Do you have trouble relaxing? \nImagine attempting to enjoy a quiet evening, an ongoing sense of tension makes relaxation elusive.",
    "Have you became so restless that it's hard to sit still? \nEnvision focusing on a task, but overwhelming restlessness makes it difficult to stay seated.",
    "Are you becoming easily annoyed or irritable?",
    "Do you feeling afraid, as if something awful might happen? \nImagine going about your day, a lingering feeling of impending doom makes routine activities feel daunting.",
  ];

  void answerQuestion(int response) async {
    userResponses[currentQuestionIndex] = response;
    if (currentQuestionIndex < 6) {
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

        // Prepare a map with the new GAD7 scores data
        Map<String, dynamic> data = {
          'latestGADScore': totalScore,
        };

        // If the user document exists, update the data
        if (userData != null) {
          if (userData['gadScores'] == null) {
            data['gadScores'] = [];
          } else {
            data['gadScores'] = List.from(userData['gadScores'] as List);
          }
          data['gadScores'].add({
            'totalScore': totalScore,
            'year': year,
            'month': month,
          });
        }

        // Update the user's document in Firestore with merge:true
        userDoc.set(data, SetOptions(merge: true));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GAD7ResultsPage(totalScore as int),
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
                  'Question ${currentQuestionIndex + 1} of 7',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF694F79),
                  ),
                ),
              ),
            ),
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
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
              margin: EdgeInsets.only(bottom: 15),
            ),
            for (int i = 0; i < 4; i++)
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
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
                    elevation: 0, // Remove the default button elevation
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
