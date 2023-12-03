import 'package:flutter/material.dart';
import 'package:inner_joy/Screens/gad7_results_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inner_joy/Screens/PhqPage.dart';

class GAD7Questions extends StatefulWidget {
  @override
  _GAD7QuestionsState createState() => _GAD7QuestionsState();
}

class _GAD7QuestionsState extends State<GAD7Questions> {
  int currentQuestionIndex = 0;
  List<int> userResponses = List.filled(7, -1);

  List<String> questions = [
    "Feeling nervous, anxious, or on edge?",
    "Not being able to stop or control worrying?",
    "Worrying too much about different things?",
    "Trouble relaxing?",
    "Being so restless that it's hard to sit still?",
    "Becoming easily annoyed or irritable?",
    "Feeling afraid, as if something awful might happen",
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
          if (userData['username'] != null) {
            data['username'] = userData['username'];
          }
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
            if (currentQuestionIndex > 0) {
              setState(() {
                currentQuestionIndex--;
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhqPage(),
                ),
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Question ${currentQuestionIndex + 1} of 7',
                style: TextStyle(
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
                style: TextStyle(
                  fontSize: 25,
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
                      colors: [
                        Color(0xFFB8A2B9),
                        Color(0xFFA18AAE),
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => answerQuestion(i),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      i == 0
                          ? "Not at all"
                          : i == 1
                              ? "Several days"
                              : i == 2
                                  ? "More than half the days"
                                  : "Nearly every day",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                if (userResponses[currentQuestionIndex] == i)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
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
