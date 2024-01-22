import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kiteflux/kiteconnect.dart';
import 'package:kiteflux/position/position_caardview.dart';

class order_screen extends StatefulWidget {
  const order_screen({Key? key, required this.enctoken, required this.triggerPrice, required this.tradingsymbol}) : super(key: key);

  final String enctoken;
  final double triggerPrice;
  final dynamic tradingsymbol;

  @override
  order_screenState createState() => order_screenState();
}

class order_screenState extends State<order_screen> {
  late String enctoken; 
  late double triggerPrice;
  late dynamic tradingsymbol;
  List<dynamic> PositionList = [];

  @override
  void initState() {
    super.initState();
    enctoken = widget.enctoken;
    triggerPrice = widget.triggerPrice;
    tradingsymbol = widget.tradingsymbol;
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('KiteFlux')),
        body: Text("$triggerPrice" "$tradingsymbol")
      )
    );
  }
}