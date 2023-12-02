import 'package:flutter/material.dart';
import 'package:inner_joy/Screens/chatbot_prev.dart';
import 'package:inner_joy/Screens/YogaPage.dart';
import 'package:inner_joy/Screens/PhqPage.dart';
import 'package:inner_joy/Screens/ProfilePage.dart';

class Tabs extends StatefulWidget {
  final int selectedIndex;

  const Tabs({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<Tabs> createState() {
    return _TabsState();
  }
}

class _TabsState extends State<Tabs> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.selectedIndex;
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      ProfilePage(),
      ChatPrevPage(),
      PhqPage(),
      YogaPage(),
    ];

    return Scaffold(
      appBar: null,
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 247, 245, 245),
        selectedItemColor: Color(0xFF694F79),
        unselectedItemColor: Color.fromARGB(255, 69, 68, 68),
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/profile.png')),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/chatbot.png'),
              size: 33,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/images/phq.png")),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/images/yoga.png")),
            label: "",
          ),
        ],
      ),
    );
  }
}
