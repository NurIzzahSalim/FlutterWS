// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:my_tutor/TutorScreen.dart';
import 'MainScreen.dart';

class BarScreen extends StatefulWidget {
  const BarScreen({Key? key}) : super(key: key);

  @override
  State<BarScreen> createState() => _BarScreenState();
}

class _BarScreenState extends State<BarScreen> {
  late List<Widget> tabchildren;
 int _currentIndex = 0;
 String maintitle = "Subject";

  static const List<Widget> _pages = <Widget>[
    MainScreen(),
    TutorScreen(),
    MainScreen(),
    MainScreen(),
    MainScreen(),
  ];
  
  final int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
        ),
       bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const[
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_outlined ,),
              label: "Subject",
              backgroundColor: Colors.brown,
              ),

              BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind_outlined  ,),
              label: "Tutors",
              backgroundColor: Colors.brown,
              
              ),
              
              BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_high_outlined,),
              label: "Subcribe",
              backgroundColor: Colors.brown,
              ),
              
              BottomNavigationBarItem(
              icon: Icon(Icons.favorite,),
              label: "Favourite",
              backgroundColor: Colors.brown,
              ),
              
              BottomNavigationBarItem(
              icon: Icon(Icons.person,),
              label: "My Profile",
              backgroundColor: Colors.brown,
              ),
          ]
        ),  
    );
  }
    void onTabTapped(int index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex ==0){
              maintitle = "Subject";
            }
            if (_currentIndex ==1){
              maintitle = "Tutors";
            }
            if (_currentIndex ==2){
              maintitle = "Subcribe";
            }
            if (_currentIndex ==3){
              maintitle = "Favourite";
            }
            if (_currentIndex ==4){
              maintitle = "My Profile";
            }
          });
        }
}