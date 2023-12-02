import 'package:flutter/material.dart';



class YogaPage extends StatelessWidget {
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
      child: Center(
        child: Text("Yoga Page Content"),
      ),
    ));
  }
}
