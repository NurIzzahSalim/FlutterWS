import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_tutor/BarScreen.dart';
//import 'package:my_tutor/MainScreen.dart';
import 'package:my_tutor/models/cart.dart';
import 'package:my_tutor/paymentscreen.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'models/user.dart';


class CartScreen extends StatefulWidget {
  //const CartScreen({Key? key}) : super(key: key);
  final User user;
  const CartScreen({Key? key, required this.user}) : super(key: key);
  
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Cart> cartList = <Cart>[];
   String titlecenter = "Loading...";
   double totalpayable = 0.0;
   late int gridcount;


  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('MY Cart'),
              backgroundColor: Colors.brown,
              leading: GestureDetector(
                child: const Icon(
                  Icons.arrow_back, 
                  color: Colors.white,),
                  
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => 
                          BarScreen(user: widget.user,)));
                },
              ),
            ),

    body: cartList.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    titlecenter,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),

              ) : Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Text(titlecenter,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    
                    Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 1.3),
                            children: List.generate(cartList.length, (index) {
                              
                              return InkWell(
                                  child: Card(
                                      child: Column(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "mytutor/mobile/assets/courses/" +
                                          cartList[index].subid.toString() +
                                          '.png',
                                      fit: BoxFit.cover,
                                      width: resWidth,
                                      
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 10),
                                      Flexible(
                                        flex: 4,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            
                                            children: [
                                              Column(children: [
                                                Text(
                                                  cartList[index].subname.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:FontWeight.bold),
                                                ),
                                                
                                                const SizedBox(width: 15),
                                                Text(
                                                    "RM ${double.parse(
                                                      cartList[index].pricetotal.toString()).toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:FontWeight.bold)),
                                              ]),
                                    ]),
                                  )
                                ],
                              )));
                            }))),
                    
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Total Payable: RM ${totalpayable.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold),
                            ),
                            
                            ElevatedButton(
                                onPressed: _onPaynowDialog,
                                child: const Text("Pay Now"))
                          ],
                        ),
                      ),
                    )
                  ],
              ))));
  }

  void _loadCart() {
     http.post(
        Uri.parse("${CONSTANTS.server}/mytutor/mobile/PHP/load_cart.php"),
        body: {
          'user_email': widget.user.email,    
        }).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response(
            'Error', 408); },

    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        titlecenter = "Timeout. Please retry again later";
        return http.Response(
            'Error', 408); },

    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['cart'] != null) {
          cartList = <Cart>[];
          extractdata['cart'].forEach((v) {
            cartList.add(Cart.fromJson(v));
          });
          int qty = 0;
          totalpayable = 0.00;
          for (var element in cartList) {
            qty = qty + int.parse(element.cartqty.toString());
            totalpayable =
                totalpayable + double.parse(element.pricetotal.toString());
          }
           titlecenter = "Subjects in Your Cart = $qty";
          setState(() {});
        }
      } else {
        titlecenter = "Your Cart is Empty For Now";
        cartList.clear();
        setState(() {});
      }
    });
  }


  void _onPaynowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          
          title: const Text("Pay Now", style: TextStyle(),
          ),
          
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes", style: TextStyle(),
              ),
              
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => PaymentScreen(
                             user: widget.user, totalpayable: totalpayable)));
                _loadCart();
              },
            ),
            
            TextButton(
              child: const Text(
                "No",style: TextStyle(),
              ),
              
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }
}