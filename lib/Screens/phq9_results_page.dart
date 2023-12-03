import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inner_joy/Screens/tabs.dart';

class PHQResultsPage extends StatefulWidget {
  final int totalScore;

  PHQResultsPage({required this.totalScore}); // Updated constructor

  @override
  _PHQResultsPageState createState() => _PHQResultsPageState();
}

class _PHQResultsPageState extends State<PHQResultsPage> {
  late Image _whyThisWayImage;
  late Image _nextStepImage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    final ByteData whyThisWayData =
        await rootBundle.load('assets/images/WhyThisWay.png');
    final Uint8List whyThisWayBytes = whyThisWayData.buffer.asUint8List();
    setState(() {
      _whyThisWayImage = Image.memory(whyThisWayBytes);
    });

    final ByteData nextStepData =
        await rootBundle.load('assets/images/NextStep.png');
    final Uint8List nextStepBytes = nextStepData.buffer.asUint8List();
    setState(() {
      _nextStepImage = Image.memory(nextStepBytes);
    });
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
            image: AssetImage('assets/images/Background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Results',
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF694F79),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: _interpretScore(widget.totalScore),
              ),
              _buildSection(
                title: "Why I'm Feeling This Way?",
                content: _renderUnderstandingYourselfContent(),
                showImage: true,
              ),
              _buildSection(
                title: 'Advice To help You:',
                content: _renderFriendlyAdvice(widget.totalScore),
                showImage: true,
              ),
              _buildSection(
                title: 'Next Steps and Follow-Up',
                content: _renderNextStepsContent(widget.totalScore),
                showImage: true,
              ),
              SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => Tabs(selectedIndex: 2),
                      ),
                      (route) => false,
                    );
                  },
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
                    width: double.infinity,
                    height: 60,
                    child: Center(
                      child: Text(
                        'Done',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    bool showImage = true,
  }) {
    Image? sectionImage;

    if (title == "Why I'm Feeling This Way?") {
      sectionImage = _whyThisWayImage;
    } else if (title == 'Next Steps and Follow-Up' ||
        title == 'Advice To help You:') {
      sectionImage = _nextStepImage;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF694F79),
                ),
              ),
              SizedBox(width: 8),
              if (showImage && sectionImage != null)
                Container(
                  width: 50,
                  height: title == "Why I'm Feeling This Way?" ? 100.0 : 50.0,
                  child: sectionImage,
                ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 128, 126, 126).withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: content,
        ),
      ],
    );
  }

  Widget _renderNextStepsContent(int score) {
    switch (score) {
      case 0:
        return RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            children: [
              TextSpan(
                text:
                    "InnerJoy suggests the following activities to enhance your mental well-being:\n\n",
              ),
              _boldText("Meditation Assistance (Audio Clips):"),
              TextSpan(
                text:
                    "\nExplore our meditation audio clips a few times a week. These brief sessions can offer moments of calm and mental clarity.\n\n",
              ),
              _boldText("Yoga Exercises:"),
              TextSpan(
                text:
                    "\nIntegrate simple yoga exercises into your routine, aiming for 2 sessions per week. These exercises are designed to promote relaxation and mental well-being.\n\n",
              ),
              _boldText("Brick-Breaker Game:"),
              TextSpan(
                text:
                    "\nPlay our stress-relief game once a week. This light engagement can contribute positively to your mood and help manage mild depressive feelings.\n\n",
              ),
              TextSpan(
                text:
                    "We understand the importance of not adding unnecessary pressure. Mental health is our priority, and strict schedules might increase stress. The PHQ tracking will be separate from activity tracking, allowing for a more relaxed approach. Take this plan with a light heart, and remember not to pressure yourself. InnerJoy is here to support you on your mental health journey.",
              ),
            ],
          ),
        );
      case 1:
      case 2:
      case 3:
      case 4:
        return RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            children: [
              TextSpan(
                text:
                    "InnerJoy suggests the following activities to enhance your mental well-being:\n\n",
              ),
              _boldText("Meditation Assistance (Audio Clips):"),
              TextSpan(
                text:
                    "\nIntegrate meditation audio clips into your routine on most days. These sessions can offer moments of relaxation and mental rejuvenation.\n\n",
              ),
              _boldText("Yoga Exercises:"),
              TextSpan(
                text:
                    "\nInclude yoga exercises in your routine, aiming for 3 sessions per week. These exercises are tailored to enhance both physical and mental well-being.\n\n",
              ),
              _boldText("Brick-Breaker Game:"),
              TextSpan(
                text:
                    "\nEngage with our stress-relief game 2-3 times a week. This frequency can aid in managing depressive feelings and provide a pleasant distraction.\n\n",
              ),
              TextSpan(
                text:
                    "We understand the importance of not adding unnecessary pressure. Mental health is our priority, and strict schedules might increase stress. The PHQ tracking will be separate from activity tracking, allowing for a more relaxed approach. Take this plan with a light heart, and remember not to pressure yourself. InnerJoy is here to support you on your mental health journey.",
              ),
            ],
          ),
        );
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        return RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            children: [
              TextSpan(
                text:
                    "InnerJoy suggests the following activities to foster mental well-being:\n\n",
              ),
              _boldText("Meditation Assistance (Audio Clips):"),
              TextSpan(
                text:
                    "\nEngage in meditation audio clips daily. Consistent meditation can promote a calmer mind and improved mental well-being.\n\n",
              ),
              _boldText("Yoga Exercises:"),
              TextSpan(
                text:
                    "\nIncorporate yoga exercises into your routine, aiming for 4 sessions per week. These exercises are designed to provide both physical and mental relaxation.\n\n",
              ),
              _boldText("Brick-Breaker Game:"),
              TextSpan(
                text:
                    "\nIn your case, you don't need to worry about incorporating the brick-breaker game into your routine. Instead, focus on other activities that contribute to your mental well-being.\n\n",
              ),
              TextSpan(
                text:
                    "We understand the importance of not adding unnecessary pressure. Mental health is our priority, and strict schedules might increase stress. The PHQ tracking will be separate from activity tracking, allowing for a more relaxed approach. Take this plan with a light heart, and remember not to pressure yourself. InnerJoy is here to support you on your mental health journey.",
              ),
            ],
          ),
        );
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
        return RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            children: [
              TextSpan(
                text:
                    "InnerJoy recommends the following activities to provide comprehensive mental health support:\n\n",
              ),
              _boldText("Meditation Assistance (Audio Clips):"),
              TextSpan(
                text:
                    "\nEngage in meditation audio clips twice daily. Consistent meditation can significantly contribute to a calmer mind and improved mental health.\n\n",
              ),
              _boldText("Yoga Exercises:"),
              TextSpan(
                text:
                    "\nIncorporate yoga exercises into your daily routine. Daily sessions are designed to promote physical and mental well-being.\n\n",
              ),
              _boldText("Brick-Breaker Game:"),
              TextSpan(
                text:
                    "\nYou don't need to worry about incorporating the brick-breaker game into your routine. Instead, focus on other activities that contribute to your mental well-being.\n\n",
              ),
              TextSpan(
                text:
                    "We understand the importance of not adding unnecessary pressure. Mental health is our priority, and strict schedules might increase stress. The PHQ tracking will be separate from activity tracking, allowing for a more relaxed approach. Take this plan with a light heart, and remember not to pressure yourself. InnerJoy is here to support you on your mental health journey.",
              ),
            ],
          ),
        );
      default:
        return Container(); // Placeholder for other cases (should not happen)
    }
  }

  Widget _interpretScore(int score) {
    String severity = '';

    if (score == 0) {
      severity = "No";
    } else if (score <= 4) {
      severity = "Minimal";
    } else if (score <= 9) {
      severity = "Mild";
    } else if (score <= 14) {
      severity = "Moderate";
    } else if (score <= 19) {
      severity = "Moderately severe";
    } else {
      severity = "Severe";
    }

    String result = 'Your test score indicates that you have:\n\n ';

    if (severity == "No") {
      result += 'No have depression symptoms';
    } else {
      result += '$severity depression symptoms';
    }

    return Center(
      child: Text(
        result,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        textAlign: TextAlign.center, // Center-align the text
      ),
    );
  }

  TextSpan _boldText(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _renderFriendlyAdvice(int score) {
    switch (score) {
      case 0:
        return Text(
          "It's fantastic that you're not experiencing depression right now.\n\nFrom your test results, it is clear that you prioritize self-care and maintain a healthy routine, so please continue doing so. Consider setting goals for personal growth, and always be mindful of stressors that may arise. If challenges do come up, reach out for support early to prevent them from escalating.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        );
      case 1:
      case 2:
      case 3:
      case 4:
        return Text(
          "It's understandable that you're feeling a bit down, don't worry because your case is a place where you can easily escalate to a case of No Depression.\n\nInnerJoy advises you to explore the factors contributing to these emotions as it is not recommended to keep running away from them. After analyzing your test answers, consider incorporating enjoyable activities into your routine and focusing on building a strong support system. Additionally, developing healthy coping mechanisms and addressing any underlying issues can be beneficial.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        );
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        return Text(
          "We appreciate your openness about your feelings in taking this test. In your case, InnerJoy thinks it's essential to explore these emotions in more depth as they are in danger of escalating to a high rate of depression.\n\nConsider journaling or expressing yourself creatively to gain insight. Engaging in therapy can provide valuable tools to navigate through this stage. Most importantly, you are advised to build a support network as it is crucial in your case. Please don't try to get over this alone. Together, we can work on strategies to manage and alleviate your symptoms.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        );
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
        return Text(
          "After analyzing your test results, InnerJoy hears that things are challenging right now. Let's delve into your experiences and emotions to understand them better.\n\nInnerJoy advises you to seek professional help as your case needs more professional help than our app only. Therapy can provide a structured and supportive space to explore and process these feelings. We'll work on developing coping strategies and setting realistic goals to gradually improve your well-being.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        );
      default:
        return Text(
          "InnerJoy is here to support you through this difficult time. It's crucial that we address the severity of your depression with a multifaceted approach.\n\nSeeking immediate professional help is essential, and we'll work collaboratively to develop a comprehensive treatment plan. You need to be building a strong support system and focus on small, manageable steps in self-care will be integral to your journey towards recovery. You don't have to face this alone, and your courage in seeking help is commendable.\n\nMore specifically, InnerJoy understands that in your case, you are too depressed to even seek a therapist. However, we strongly encourage you to take the first step and book an appointment and we're positive that things will get easier by time.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        );
    }
  }

  Widget _renderUnderstandingYourselfContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUnderstandingYourselfItem(
          "Life Events",
          "Depression can be triggered or worsened by significant life events, including bereavement, relationship issues, illness, work or school problems, financial worries, or major life transitions.",
        ),
        _buildUnderstandingYourselfItem(
          "Age and Socioeconomic Factors",
          "Depression may be more prevalent in older adults and individuals facing challenging social and economic circumstances, adding an extra layer of complexity to emotional well-being.",
        ),
        _buildUnderstandingYourselfItem(
          "Genetic Influence",
          "A genetic predisposition inherited from parents can increase the likelihood of experiencing depression, highlighting the role of genetic factors in mental health.",
        ),
        _buildUnderstandingYourselfItem(
          "Personality Traits",
          "Certain personality traits, such as low self-esteem or excessive self-criticism, may make someone more prone to depression, emphasizing the interconnected nature of mental health and personality.",
        ),
        _buildUnderstandingYourselfItem(
          "Loneliness",
          "Feeling isolated and disconnected from loved ones can contribute significantly to depression, underscoring the importance of social connections for emotional well-being.",
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Remember, anxiety doesn't have to control your life. With the right support and self-care strategies, you can manage your symptoms and live a fulfilling life. You're Not Alone!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnderstandingYourselfItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}