import 'package:flutter/material.dart';
import 'package:mytutor/views/loginpage.dart';
import 'package:mytutor/views/registerpage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Tutor'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const UserAccountsDrawerHeader(
              accountName: Text("Nur Izzah"),
              accountEmail: Text("n.izasalim1803@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                 "https://cdn.myanimelist.net/r/360x360/images/characters/9/310307.jpg?s=56335bffa6f5da78c3824ba0dae14a26"),
              ),
            ),
              
              _createDrawerItem(
                icon: Icons.person,
                text: 'Login', 
                onTap: () { 
                  Navigator.pop(context);
                    Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (content) => const LoginPage())); 
                    },
                  ),

              _createDrawerItem(
                icon: Icons.person,
                text: 'New Registration', 
                onTap: () { 
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (content) => const RegisterPage())); 
                    },
                  )]
          )),


        body: const Center(
            child: Text('Hello World'),
          ),
      );
  }
  
  Widget _createDrawerItem(
    {required IconData icon, required String text, required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
}
