import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/BarScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'models/user.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY Tutor',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        textTheme: GoogleFonts.anaheimTextTheme(
          Theme.of(context).textTheme.apply(),
        )
      ),
      home: const MySplashScreen(title: 'MY Tutor'),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool remember = false;
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
      Timer(const Duration(seconds: 3), () => loadPref());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children:[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mytutorSC.png'), 
                fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,50,0,20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:const [
                Text("MY Tutor"),
                CircularProgressIndicator(), 
                Text("Version 0.1.0", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              ],
            ),
          )],
      ),
    );
  }

  Future<void> loadPref() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        status = "Credentials found, auto log in...";
      });
      _loginUser(email, password);
    } else {
      _loginUser(email, password);
      setState(() {
        status = "Login as guest...";
      });
    }
  }

  void _loginUser(String email, String password) {
    http.post(
        Uri.parse("${CONSTANTS.server}/mytutor/mobile/PHP/login_user.php"),
        body: {
          "email": email, "password": password})
          .then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        User user = User.fromJson(extractdata);
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => BarScreen(
                      user: user,
                    )));
      } else {
        User user = User(
            id: '0',
            name: 'guest',
            email: 'guest@mytutorapp.com',
            cart: '0');
        Fluttertoast.showToast(
            msg: "You're in the Guest Mode",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => BarScreen(
                      user: user,
                    )));
      }
    });
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
