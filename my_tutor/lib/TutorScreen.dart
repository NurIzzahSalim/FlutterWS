// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/models/subjects.dart';
import '../constants.dart';
import 'models/tutors.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutors>? tutorList = <Tutors>[];
  List<Subjects>? subjectList = <Subjects>[];
  String titlecenter = "Loading..";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  String search = "";

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
    _loadSubject(1, search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY Tutor', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: tutorList!.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("List of Tutors",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 2),
                        children: List.generate(tutorList!.length, (index) {
                          return InkWell(
                            splashColor: Colors.blueGrey,
                            onTap: () => {
                              _loadTutorDetails(index)

                            },

                            child: Card(
                                child: Column(
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    imageUrl: CONSTANTS.server +
                                        "/mytutor/mobile/assets/tutors/" +
                                        tutorList![index].tutorId.toString() +
                                        '.jpg',
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Flexible(
                                    flex: 4,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          
                                          const Text("Name:",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 12)),
                                          Text(
                                              tutorList![index]
                                                  .tutorName
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5),
                                          
                                          const Text("Email:",
                                              style: TextStyle(fontSize: 12)),
                                          Text(
                                            tutorList![index]
                                                .tutorEmail
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          
                                          const Text("Phone:",
                                              style: TextStyle(fontSize: 12)),
                                          Text(
                                              tutorList![index]
                                                  .tutorPhone
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)
                                          ),
                                        ],
                                      ),
                                    ))
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
                            onPressed: () => {_loadTutors(index + 1)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/PHP/load_tutor.php"),
        body: {'pageno': pageno.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
          tutorList = <Tutors>[];
          extractdata['tutors'].forEach((v) {
            tutorList!.add(Tutors.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Tutor Available";
          setState(() {});
        }
      }
    });
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

  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor Details",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
               child: Column(
              children: [
                  CachedNetworkImage(
                    imageUrl: CONSTANTS.server +
                      "/mytutor/mobile/assets/tutors/" +
                      tutorList![index].tutorId.toString() +
                      '.jpg',
                       placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),),

                   const Text(
                    "Name:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15)),
                    Text(
                        tutorList![index].tutorName.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                           const SizedBox(height: 5),

                    const Text(
                      "Subject:",
                        style: TextStyle(fontSize: 15)),
                      Text(
                          subjectList![index].subjectName.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                                          
                    const Text(
                      "Email:",
                        style: TextStyle(fontSize: 15)),
                      Text(
                          tutorList![index].tutorEmail.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold),),
                            const SizedBox(height: 5),
                    
                    const Text(
                      "Phone:",
                        style: TextStyle(fontSize: 15)),
                      Text(
                          tutorList![index].tutorPhone.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),

                    const Text(
                      "Description:",
                        style: TextStyle(fontSize: 15)),
                      Text(
                          tutorList![index].tutorDescription.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
              ]),
            ),
          );
        }
    );
  }


}