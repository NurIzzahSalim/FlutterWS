// ignore_for_file: unnecessary_const, file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/constants.dart';
import 'package:my_tutor/models/subjects.dart';
import 'package:http/http.dart' as http;


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Subjects>? subjectList = <Subjects>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

   @override
 void initState() {
   super.initState();
   _loadSubject(1);
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
                      childAspectRatio: (1 / 1),
                      children: List.generate(subjectList!.length, (index) {
                          return Card(
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
                               const SizedBox(height: 15),

                              Flexible(
                                  flex: 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          subjectList![index]
                                            .subjectName
                                            .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 10, 
                                            fontWeight: FontWeight.w500,
                                            color: Colors.brown)),
                                        
                                        Text("RM " +
                                          double.parse(subjectList![index]
                                                  .subjectPrice
                                                  .toString())
                                              .toStringAsFixed(2),
                                            style: const TextStyle(
                                            fontSize: 10, 
                                            fontWeight: FontWeight.w600)),
                                        
                                        Text(
                                          subjectList![index]
                                              .subjectSession
                                              .toString() +
                                              "Sessions",
                                            style: const TextStyle(
                                            fontSize: 10, 
                                            color: Colors.brown)),

                                        Text("Rating " +
                                          double.parse(subjectList![index]
                                                  .subjectRating
                                                  .toString())
                                              .toStringAsFixed(2) + "/5",
                                            style: const TextStyle(
                                            fontSize: 10, 
                                            color: Colors.brown)),
                                          
                                      ],
                                    ),
                                  )
                              )
                            ],
                        ));
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
                              {_loadSubject(index + 1)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                        )),
                    );},
                )),
            ]
          )
    );
  }

  void _loadSubject(int pageno) {
    curpage = pageno;
      numofpage ?? 1;

      http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/PHP/load_subject.php"),
        body: {'pageno': pageno.toString()}).then((response) {
        var jsondata = jsonDecode(response.body);
           if (response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          numofpage = int.parse(jsondata['numofpage']);

          if (extractdata['subjects'] != null) {
            subjectList = <Subjects>[];
            extractdata['subjects'].forEach((v) {
            subjectList!.add(Subjects.fromJson(v));
          });
            setState(() {});
          } else {
            titlecenter = "No Subject Available";
            setState(() {});
        }
        }}
    );
  }
}
