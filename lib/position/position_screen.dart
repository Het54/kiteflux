import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kiteflux/kiteconnect.dart';
import 'package:kiteflux/position/position_caardview.dart';

class position_screen extends StatefulWidget {
  const position_screen({Key? key, required this.enctoken}) : super(key: key);

  final String enctoken;

  @override
  position_screenState createState() => position_screenState();
}

class position_screenState extends State<position_screen> {
  late String enctoken; 
  List<dynamic> PositionList = [];

  @override
  void initState() {
    super.initState();
    enctoken = widget.enctoken;
  }

  Future<String> get_position() async {
    var kite = kiteconnect(enctoken);
    var positions = await kite.positions();
    print(positions['data']['net'][0].values.toList());
    var x = positions['data']['net'][0].values.toList()[0];
    return (x);
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('KiteFlux')),
        body: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shadowColor: Colors.teal,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
            ),
          onPressed: () async {
              String x = await get_position();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Position",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      x,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white,
                  );
                },
              );
          },
          child: const Text('Submit', style: TextStyle(color: Colors.teal, fontSize: 15)),
        ),
      )
    );
  }
}