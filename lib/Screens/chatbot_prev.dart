import 'package:flutter/material.dart';
import 'package:inner_joy/Chatbot.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPrevPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 85),
              Text(
                " I'm Joy, your cheerful virtual friend",
                style: GoogleFonts.nunito(
                  fontSize: 23,
                  color: Color(0xFF694F79),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Feel free to chat with me about anything you like!",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Color(0xFF694F79),
                ),
              ),
              SizedBox(height: 60),
              Image.asset(
                'assets/images/Joy.png',
                width: 280,
                height: 280,
              ),
              SizedBox(height: 30),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(90.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Chatbot()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 60),
                      ),
                      child: Text(
                        "Start chatting",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF694F79),
                          fontSize: 17,
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
}
