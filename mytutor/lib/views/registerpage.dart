import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytutor/views/loginpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ndialog/ndialog.dart';
import 'package:mytutor/model/config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double screenHeight, screenWidth, resWidth;
  final _formKey = GlobalKey<FormState>();
  //final bool _isChecked = false;
  bool _passwordVisible = true;

  final focus  = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if(screenWidth <= 600){
      resWidth = screenWidth;
    }else{
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [upperHalf(context), lowerHalf(context)],) )
        )  
      )
    );
  }

  Widget upperHalf(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: SizedBox(
        height: screenHeight / 3.5,
        width: resWidth * 0.7,
        child: Image.asset(
          'assets/images/2.png',
           fit: BoxFit.cover,
          ),
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      width: resWidth,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Card(
            elevation: 10, 
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
              child: Form(key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Register New Account",
                    style: TextStyle(
                      fontSize: resWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      ),
                    ),
                   
                   const SizedBox(
                      height: 10,
                    ),

                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "name must be longer than 3"
                            : null,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus);
                        },
                        controller: _nameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty ||
                                !val.contains("@") ||
                                !val.contains(".")
                            ? "enter a valid email"
                            : null,
                        focusNode: focus,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus1);
                        },
                        controller: _emailditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(),
                            labelText: 'Email',
                            icon: Icon(Icons.phone),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (val) => validatePassword(val.toString()),
                      focusNode: focus1,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus2);
                      },
                      controller: _passEditingController,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(),
                          labelText: 'Password',
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )),
                      obscureText: _passwordVisible,
                    ),
                    
                    TextFormField(
                      style: const TextStyle(),
                      textInputAction: TextInputAction.done,
                      validator: (val) {
                        validatePassword(val.toString());
                        if (val != _passEditingController.text) {
                          return "password do not match";
                        } else {
                          return null;
                        }
                      },
                      focusNode: focus2,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus3);
                      },
                      controller: _pass2EditingController,
                      decoration: InputDecoration(
                          labelText: 'Re-enter Password',
                          labelStyle: const TextStyle(),
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )),
                      obscureText: _passwordVisible,
                    ),
                    
                    const SizedBox(
                      height: 15,),
                  
                  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(screenWidth / 3, 50)),
                          child: const Text('Register'),
                          onPressed: _registerUserAccount,  
                  ),
                ],
              )
              )
            )
          ),
          
          const SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Already Register? ",
                  style: TextStyle(
                    fontSize: 16.0,
                  )),
              GestureDetector(
                onTap: () => {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage()))
                },
                child: const Text(
                  "Login here",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: null,
            child: const Text(
              "Back to Home",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

   String? validatePassword(String value) {
    // String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _name = _nameEditingController.text;
    String _email = _emailditingController.text;
    String _pass = _passEditingController.text;
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));
    progressDialog.show();

    http.post(Uri.parse(MyConfig.server + "/mytutordb/PHP/register_user.php"),
        body: {
          "name": _name,
          "email": _email,
          "password": _pass
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        //Navigator.push(context,
            //MaterialPageRoute(builder: (BuildContext context) => const LoginPage()));
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
}