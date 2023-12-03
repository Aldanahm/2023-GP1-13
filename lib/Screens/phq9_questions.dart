import 'package:flutter/material.dart';
import 'package:inner_joy/Screens/phq9_results_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inner_joy/Screens/PhqPage.dart';

class PHQ9Questions extends StatefulWidget {
  @override
  _PHQ9QuestionsState createState() => _PHQ9QuestionsState();
}

class _PHQ9QuestionsState extends State<PHQ9Questions> {
  int currentQuestionIndex = 0;
  List<int> userResponses = List.filled(9, -1);

  List<String> questions = [
    "Little interest or pleasure in doing things?",
    "Feeling down, depressed, or hopeless?",
    "Trouble falling or staying asleep, or sleeping too much?",
    "Feeling tired or having little energy?",
    "Poor appetite or overeating?",
    "Feeling bad about yourself or that you are a failure or have let yourself or your family down?",
    "Trouble concentrating on things, such as reading the newspaper or watching television?",
    "Moving or speaking so slowly that other people could have noticed, or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?",
    "Thoughts that you would be better off dead or of hurting yourself in some way"
  ];

  void answerQuestion(int response) async {
    userResponses[currentQuestionIndex] = response;
    if (currentQuestionIndex < 8) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      int totalScore = userResponses.reduce((a, b) => a + b);

      DateTime now = DateTime.now();
      int year = now.year;
      int month = now.month;

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;

        DocumentReference userDoc = firestore.collection('users').doc(userId);

        final userDocSnapshot = await userDoc.get();
        final Map<String, dynamic>? userData =
            userDocSnapshot.data() as Map<String, dynamic>?;

        Map<String, dynamic> data = {
          'latestPHQScore': totalScore,
        };

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
          if (userData['username'] != null) {
            data['username'] = userData['username'];
          }
        }

      userDoc.set(data, SetOptions(merge: true));

      BuildContext pageContext = context;

        Navigator.push(
          pageContext,
          MaterialPageRoute(
            builder: (pageContext) => PHQResultsPage(totalScore: totalScore),
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
                'Question ${currentQuestionIndex + 1} of 9',
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