
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CryptoScreen extends StatelessWidget {
const CryptoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('BITCOIN CRYPTOCURRENCY EXCHANGE'),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
          SizedBox(
              height: 150,
              child: Center(
               child: Image.asset('assets/images/crypto2.png'),
               )),
      const MyCryptoPage(),
           ] )
      ),
    );
  }
}

class MyCryptoPage extends StatefulWidget {
  const MyCryptoPage({Key? key}) : super(key: key);

  @override
  State<MyCryptoPage> createState() => _MyCryptoPageState();
}

class _MyCryptoPageState extends State<MyCryptoPage> {

  String selectCurr = "eth";
  double result = 0.0;
  double input = 0.0, rates = 0.0, description =0.0; 

  List<String> currList = [
    "btc","eth","ltc","bch","bnb","eos","xrp","xlm","link","dot",
    "yfi","usd","aed","ars","aud","bdt","bhd","bmd","brl","cad",
    "chf","clp","cny","czk","dkk","eur","gbp","hkd","huf","idr",
    "ils","inr","jpy","krw","kwd","lkr","mmk","mxn","myr","ngn",
    "nok","nzd","php","pkr","pln","rub","sar","sek","sgd","thb",
    "try","twd","uah","vef","vnd","zar","xdr","xag",
    "xau","bits","sats",
  ];

  TextEditingController inputEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
                "Cryptocurrency Exchance",
                style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            TextField(
              controller: inputEditingController,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                hintText: "Please Enter The Bitcoin Value",
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0))
                  ),
              ),
              const SizedBox(height: 10.0),

              Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text(
                "Please Choose One Currency > ",
                style: TextStyle(fontSize: 15),
                ),

              SizedBox(
                child: DropdownButton(  
                    itemHeight: 60,
                    value: selectCurr,
                    onChanged: (newValue){
                      setState(() {
                        selectCurr = newValue.toString();
                      });
                    },
                    items: currList.map((selectCurr){
                      return DropdownMenuItem(
                        child: Text(
                          selectCurr,
                          ),
                          value: selectCurr,
                      );
                    }).toList(),
                  ),
              ),
              ]),

                ElevatedButton(
                  onPressed: _loadResult, child: const Text("Load Result")
                  ),
                  const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 600.0,
                  height: 100.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "The Result for Bitcoin Above is : ",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),

                        Text(
                          description.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],),
                  color: const Color.fromARGB(255, 208, 237, 250),
                )
         ])
     );
  }

  Future<void> _loadResult() async {
    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    input = double.parse(inputEditingController.text);
    
    if(response.statusCode == 200) {
      var jsonData = response.body;
      var parsedJson =json.decode(jsonData);
      rates = parsedJson['rates'][selectCurr]['value'];

      setState((){
        description = rates * double.parse(inputEditingController.text);
           
      });
    }
  }
}
