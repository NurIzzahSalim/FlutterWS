// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:my_tutor/TutorScreen.dart';
//import 'package:my_tutor/models/user.dart';
import 'mainscreen.dart';
import 'models/user.dart';

class BarScreen extends StatefulWidget {
  //const BarScreen({Key? key}) : super(key: key);
  final User user;
  const BarScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<BarScreen> createState() => _BarScreenState();
}

class _BarScreenState extends State<BarScreen> {
int _selectedIndex = 0;
late List<Widget> tabbar;

  @override
  void initState() {
    super.initState();
    tabbar = [
      MainScreen(user: widget.user),
      const TutorScreen(),
      MainScreen(user: widget.user),
      MainScreen(user: widget.user),
      MainScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: tabbar[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 40),
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),

        unselectedItemColor: Colors.black,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            label: 'Subjects',
            backgroundColor: Colors.brown,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind_outlined),
            label: 'Tutors',
            backgroundColor: Colors.brown,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high_outlined),
            label: 'Subscribe',
            backgroundColor: Colors.brown,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Favourite',
            backgroundColor: Colors.brown,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
            backgroundColor: Colors.brown,
          ),
          
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}