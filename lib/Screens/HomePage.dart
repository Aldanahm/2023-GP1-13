import 'package:flutter/material.dart';
import 'package:inner_joy/Screens/AuthScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xFF675175);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/Background2.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          width: double.infinity,
          height: mediaQuery.size.height,
          padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.02,
            vertical: mediaQuery.size.height * 0.05,
          ),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Add the image at the top with a larger height
              Image.asset(
                'assets/images/logo.png',
                height: mediaQuery.size.height * 0.3,
              ),

              // Center the text
              Column(
                children: <Widget>[
                  Text(
                    "Welcome to",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 47,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "InnerJoy",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 47,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    "It's okay not to be okay; it's not okay to stay that way",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  },
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB8A2B9), Color(0xFFA18AAE)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    width: mediaQuery.size.width * 0.9,
                    height: 60,
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          fontSize: 21,
                          color: Colors.white,
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
