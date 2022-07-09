// ignore_for_file: unnecessary_const, file_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tutor/LoginScreen.dart';
import 'package:my_tutor/cartscreen.dart';
import 'package:my_tutor/constants.dart';
import 'package:my_tutor/models/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/models/user.dart';

//import 'models/user.dart';


class MainScreen extends StatefulWidget {
  //const MainScreen({Key? key, required User user}) : super(key: key);
  final User user;
  const MainScreen({Key? key,required this.user,}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Subjects>? subjectList = <Subjects>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
   super.initState();
   _loadSubject(1,search);
 }
  
  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
      if(screenWidth <= 600){
        resWidth = screenWidth;
      } else{
        resWidth = screenWidth * 0.75;
      }

    return Scaffold(
        appBar: AppBar(
          title: const Text('MY TUTOR SUBJECT'),
               actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {_loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              if (
                widget.user.email == "guest@mytutorapp.com") 
              {
                _loadOptions();
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartScreen(
                              user: widget.user,)));
                _loadSubject(1, search);
                _loadMyCart();
              }
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(
                widget.user.cart.toString(),
                style: const TextStyle(
                  color: Colors.white)),
          ),
        ],
        ),

        body: subjectList!.isEmpty
          ? Center(
            child: Text(titlecenter,
            style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold))) 
            
          :Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Subject Available",
                    style: 
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),
              
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 1.5),
                      children: List.generate(subjectList!.length, (index) {
                        return InkWell(
                          splashColor: Colors.brown,
                          onTap: () => {_loadSubjectDetails(index)},
                          child: Card(
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                      "/mytutor/mobile/assets/courses/" +
                                      subjectList![index].subjectId.toString() +
                                      '.png',
                                      fit: BoxFit.cover,
                                      width: resWidth,
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  
                                  Flexible(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            subjectList![index]
                                                .subjectName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                              "RM ${double.parse(subjectList![index].subjectPrice.toString()).toStringAsFixed(2)}",
                                              textAlign: TextAlign.left),
                                          Text(
                                              "Session: ${subjectList![index].subjectSession}",
                                              textAlign: TextAlign.left),
                                          Text(
                                              "Rating: ${subjectList![index].subjectRating}",
                                              textAlign: TextAlign.left),
                                        ],
                                      )),
                                ],
                              )),
                        );
                      }))),
                
                SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.brown;
                    } else {
                      color = Colors.black;
                    }
                    
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () =>
                              {_loadSubject(index + 1,search)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: color
                          ),
                        )),
                    );},
                )),
            ]
          )
    );
  }

  void _loadSubject(int pageno, String search) {
    curpage = pageno;
      numofpage ?? 1;

      http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/PHP/load_subject.php"),
        body: {
          'pageno': pageno.toString(),
          'search': search,
        }).timeout(
          const Duration(seconds:5),
          onTimeout:(){
            return http.Response(
              'Error', 408);
          }
        ).then((response) {
        var jsondata = jsonDecode(response.body);
           if (response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          numofpage = int.parse(jsondata['numofpage']);

          if (extractdata['subjects'] != null) {
            subjectList = <Subjects>[];
            extractdata['subjects'].forEach((v) {
            subjectList!.add(Subjects.fromJson(v));
          });
            titlecenter = subjectList!.length.toString() + "Subject Available";
           
           } else {
            titlecenter = "No Subject Available";
            subjectList!.clear();
          } 
            
         setState(() {});
          
          } else {
            titlecenter = "No Subject Available";
            subjectList!.clear();
            setState(() {});
        }
    });
  }

  void _loadSearchDialog() {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search Subject",
                  style: 
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                ),
          
          content: SizedBox(
            height: screenHeight/3,
            child: Column(
              children: [
                TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Type Subject Here',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))
                                ),
                  ),
              ],
            ),
          ),
            actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubject(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
        );
      });         
     }
   );
  }

  void _addtocartDialog(int index) {
      if (widget.user.email == "guest@mytutorapp.com") {
      _loadOptions();
    } else {
      _addtoCart(index);
    }
  }


  void _loadMyCart() {
    if (widget.user.email != "guest@mytutorapp.com") {
      http.post(
          Uri.parse("${CONSTANTS.server}/mytutor/mobile/PHP/load_cart.php"),
          body: {
            "email": widget.user.email.toString(),
          }).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          return http.Response(
              'Error', 408);
        },
      ).then((response) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          print(jsondata['data']['carttotal'].toString());
          setState(() {
            widget.user.cart = jsondata['data']['carttotal'].toString();
          });
        }
      });
    }
  }

  void _addtoCart(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/PHP/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subid": subjectList![index].subjectId.toString(),
        }).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response(
            'Error', 408);
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _loadOptions() {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Please Login",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _onLogin, 
                  child: const Text("Login")),
              ],
            ),
          );
        });
  }
  

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  _loadSubjectDetails(int index) {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            
            title: const Text(
              "Subject Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mytutor/mobile/assets/courses/" +
                      subjectList![index].subjectId.toString() +
                      '.png',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 20),
                
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  
                  Text(
                    "\nSubject Name: ${subjectList![index].subjectName}",
                    textAlign: TextAlign.justify,
                  ),
                  
                  Text(
                    "\nSubject Description: \n${subjectList![index].subjectDescription}",
                    textAlign: TextAlign.justify,
                  ),
                  
                  Text(
                    "\nSubject Price: RM ${double.parse(subjectList![index].subjectPrice.toString()).toStringAsFixed(2)}",
                    textAlign: TextAlign.justify,
                  ),
                  
                  Text(
                    "\nSubject Sessions: ${subjectList![index].subjectSession}",
                    textAlign: TextAlign.justify,
                  ),
                  
                  Text(
                    "\nSubject Rating: ${subjectList![index].subjectRating}",
                    textAlign: TextAlign.justify,
                  ),
                ])
              ],
            )),
            
            actions: [
              SizedBox(
                  child: IconButton(
                    onPressed: () {
                      _addtocartDialog(index);},
                        icon: const Icon(
                          Icons.shopping_cart))),
            ],
          );
        });
  }
}
