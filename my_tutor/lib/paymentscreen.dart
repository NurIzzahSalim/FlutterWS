import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_tutor/constants.dart';
import 'package:my_tutor/models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  //const PaymentScreen({Key? key}) : super(key: key);
  final User user;
  final double totalpayable;

  const PaymentScreen(
      {Key? key, required this.user, required this.totalpayable}): super(key: key);


  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: const Text('My Payment'),
        ),
              body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: CONSTANTS.server +
                    '/mytutor/mobile/php/payment.php?email=' + widget.user.email.toString() +
                    '&mobile=' + widget.user.phone.toString() +
                    '&name=' + widget.user.name.toString() +
                    '&amount=' + widget.totalpayable.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) { _controller.complete(webViewController);
                },
              ),
            )
          ],
        )
    );
  }
}