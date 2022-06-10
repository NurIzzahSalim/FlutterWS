// ignore_for_file: file_names
import 'package:my_tutor/models/admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
//import 'package:my_tutor/LoginScreen.dart';
//import 'package:mytutor/views/loginpage.dart';
//import 'package:mytutor/views/registerpage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required Admin admin}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 late double screenHeight, screenWidth, resWidth;
 late List<Widget> tabchildren;
 int _currentIndex = 0;
 String maintitle = "Subject";

 @override
 void initState() {
   super.initState();
   _loadSubject();
 }

  @override
  Widget build(BuildContext context) {  
    
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth <= 600){
      resWidth = screenWidth;
    }else{
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Tutor'),
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
        
        body: const Center(
            child: Text('Hello World'),
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
        
    void _loadSubject() {
      http.post(
        Uri.parse(CONSTANTS.server + "/slumberjer.com/mytutor/mytutordb.sql"),
      
    );
  } 
}

