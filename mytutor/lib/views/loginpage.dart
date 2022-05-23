// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytutor/views/mainscreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double screenHeight, screenWidth;
  bool remember = false;
  TextEditingController emailCtrller = TextEditingController();
  TextEditingController passwordCtrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight /2.5,
                      width: screenWidth,
                      child: Image.asset('assets/images/2.png') 
                    ),
                  
                  const Text(
                    "Login to MY Tutor",
                      style: TextStyle(fontSize: 24),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: emailCtrller,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                      keyboardType: TextInputType.emailAddress,
                      ),
                    ),

                    Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextField(
                      controller: passwordCtrller,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      ),
                    ),

                    Row(
                      children:[
                        Checkbox(value: remember, onChanged: _onRememberMe),
                        const Text("Remember Me")
                      ],
                    ),

                    SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                        child: const Text("Login"),
                        onPressed: _loginUser,
                        ),
                      )],
                ),
            ),
          ],),),
    );
  }
  
  void _onRememberMe(bool? value) {
  setState(() {
    remember = value!;
    });
  }

  void _loginUser(){
    String _email = emailCtrller.text;
    String _password = passwordCtrller.text;
    if(_email.isNotEmpty && _password.isNotEmpty){
        http.post(Uri.parse("http://10.31.105.58/mytutor/mobile/PHP/login_user.php"),
            body: {"email": _email, "password": _password}).then((response){
              print(response.body);

              if(response.body == "success"){
                Fluttertoast.showToast(
                  msg: "Success",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 16.0);
                  Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (content)=> const MainScreen()));
              }
              else{
                  Fluttertoast.showToast(
                  msg: "Failed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 16.0);
              }
      });
    }
  }
}

