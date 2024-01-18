import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kiteflux/kiteconnect.dart';
import 'package:kiteflux/position_caardview.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key, required this.enctoken}) : super(key: key);

  final String enctoken;

  @override
  home_screenState createState() => home_screenState();
}

class home_screenState extends State<home_screen> {
  late String enctoken; // Declare an instance variable to store enctoken
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(247, 255, 104, 104),
        title: const Text('Kiteflux'),
      ),
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
    );
  }
}

