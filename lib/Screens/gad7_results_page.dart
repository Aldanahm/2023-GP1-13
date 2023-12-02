import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inner_joy/Screens/PhqPage.dart';
import 'package:inner_joy/Screens/tabs.dart';
import 'package:google_fonts/google_fonts.dart';

class GAD7ResultsPage extends StatefulWidget {
  final int totalScore;

  GAD7ResultsPage(this.totalScore);

  @override
  _GAD7ResultsPageState createState() => _GAD7ResultsPageState();
}

class _GAD7ResultsPageState extends State<GAD7ResultsPage> {
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background3.png'),
              fit: BoxFit.cover,
            ),
          ),
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
                "Why I'm Feeling This Way?",
                _renderUnderstandingYourselfContent(),
                showImage: true,
              ),
              _buildSection(
                'Advice To help You:',
                _renderFriendlyAdvice(widget.totalScore),
                showImage: true,
              ),
              _buildSection(
                'Next Steps and Follow-Up',
                _renderNextStepsContent(widget.totalScore),
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
                        style: TextStyle(
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

  Widget _buildSection(String title, Widget content, {bool showImage = true}) {
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
                    "\nConsider engaging in meditation audio clips occasionally, based on your personal preference so don't pressure yourself much. Meditation can offer a serene break when you feel it would be beneficial.\n\n",
              ),
              _boldText("Yoga Exercises:"),
              TextSpan(
                text:
                    "\nYou don't need to worry about incorporating yoga exercises into your routine. Instead, focus on other activities that align with your comfort and well-being.\n\n",
              ),
              _boldText("Brick-Breaker Game:"),
              TextSpan(
                text:
                    "\nEngage in the brick-breaker game as a stress-relief activity. Incorporate it into your routine 2 times a week for a light and enjoyable break.\n\n",
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
                    "\nEngage with our stress-relief game 2-3 times a week. This frequency can aid in managing anxiety and provide a pleasant distraction.\n\n",
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
                    "\nPrioritize daily engagement with meditation audio clips. Meditation holds significant benefits for managing anxiety and fostering a calmer state of mind.\n\n",
              ),
              _boldText("Yoga Exercises:"),
              TextSpan(
                text:
                    "\nYou don't need to worry about incorporating yoga exercises into your routine. Instead, focus on other activities that align with your comfort and well-being.\n\n",
              ),
              _boldText("Brick-Breaker Game:"),
              TextSpan(
                text:
                    "\nEngage in the brick-breaker game as a stress-relief activity. Consider incorporating it into your routine 4 times a week for a refreshing break.\n\n",
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
                    "\nPlay our stress-relief game 6-7 times a week. Regular engagement is crucial for managing anxiety and providing a positive outlet.\n\n",
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
    } else {
      severity = "Severe";
    }

    String result = 'Your test score indicates that you have:\n\n ';

    if (severity == "No") {
      result += 'No have anxiety symptoms';
    } else {
      result += '$severity anxiety symptoms';
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
          "InnerJoy thinks it's great that you're not experiencing anxiety at the moment.\n\nFrom your test results, it is clear that you prioritize self-care and maintain a healthy routine, so please continue doing so. Remember to prioritize your mental health, and if stressors arise, consider implementing relaxation techniques to manage them effectively.If things elevate, focus on immediate strategies to alleviate symptoms and explore the roots of your anxiety over time.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
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
          "After analyzing your test results, even though your case is not a high case of anxiety, you are still advised to explore what might be contributing to these feelings and work on developing coping strategies.\n\nIncorporating relaxation techniques, such as deep breathing or progressive muscle relaxation, can be helpful. You need to consider engaging in activities that bring you joy and reaching out to your support network when needed.\nAdditionally, engaging in activities that bring you joy and reaching out to your support network when needed are valuable steps in managing minimal anxiety.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
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
          "Thank you for sharing your experiences with mid-level anxiety. From your test results, you need to delve into the sources of your anxiety and develop coping mechanisms.\n\nMindfulness practices, cognitive-behavioral techniques can be achieved through our app. From your test results, you also need to set realistic expectations as the are valuable tools in your case especially. It's important to build a strong support system and consider seeking professional guidance to explore these feelings further.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
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
          "InnerJoy understands that your anxiety is more pronounced right now.\n\nIt's crucial to address these feelings comprehensively. You are advised to work on identifying triggers and implementing coping strategies. Therapy can provide a structured environment to explore and understand your anxiety better.\nDeveloping a toolbox of techniques and creating a support plan will be essential for managing your symptoms effectively. In your case, seeking professional help is a critical step, and you will need to collaborate to create a comprehensive treatment plan. To help identify your triggers, Mindfulness practices, cognitive-behavioral techniques can be achieved through our app.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        );
      default:
        return Text(
          "InnerJoy is here to support you through this challenging time of severe anxiety.\n\nAddressing the intensity of your anxiety requires a comprehensive approach. Seeking immediate professional help is essential, and together, we'll develop a comprehensive treatment plan. Building a robust support system, incorporating relaxation techniques, and considering medication options if appropriate are crucial components of your journey toward managing and reducing severe anxiety.\n\nYou don't have to face this alone, and your courage in seeking help is commendable.\n\nMore specifically, InnerJoy recognizes that in your case, anxiety might make it challenging to seek a therapist. However, taking the first step and booking an appointment is a positive move that we encourage, and we believe that with time, things can become more manageable and less overwhelming.\n\nYou are advised to take this test on a monthly basis to keep track from not escalating into more severe conditions.",
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
          "Past or Childhood Experiences",
          "Early neglect, loss of a loved one, or overprotective parenting during childhood can influence current emotional well-being.",
        ),
        _buildUnderstandingYourselfItem(
          "Current Life Situation",
          "Factors like chronic stress, major life changes, uncertainty about the future, academic or work pressure, unemployment, financial strain, and periods of loneliness contribute to feelings of anxiety.",
        ),
        _buildUnderstandingYourselfItem(
          "Physical or Mental Health Problems",
          "Existing serious physical conditions or underlying mental health issues can impact mental well-being and contribute to anxiety.",
        ),
        _buildUnderstandingYourselfItem(
          "Traumatic Events",
          "Experiencing or witnessing traumatic events can significantly contribute to anxiety, leaving a lasting impact on mental health.",
        ),
        _buildUnderstandingYourselfItem(
          "Genetic or Biological Factors",
          "Genetic predispositions and biological factors can play a role in the development of anxiety disorders, providing insight into its origins and guiding personalized treatment approaches.",
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
