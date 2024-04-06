import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kiteflux/Orders/order_screen.dart';
import 'package:kiteflux/etoken_screen.dart';
import 'package:kiteflux/kiteconnect.dart';

class launch_screen extends StatefulWidget {
  const launch_screen({Key? key}) : super(key: key);

  @override
  launch_screenState createState() => launch_screenState();
}

class launch_screenState extends State<launch_screen> {


  @override
  void initState() {
    super.initState();
    // Navigate to next screen after 5 seconds
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Etoken()),
      );
    });
  }



  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/Images/playstore.png',
                width: 200, // Adjust width as needed
                height: 150, // Adjust height as needed
              ),
              Text(
                  'KiteFlux',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
