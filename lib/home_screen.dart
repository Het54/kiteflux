import 'package:flutter/material.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key, required this.enctoken}) : super(key: key);

  final String enctoken;

  @override
  home_screenState createState() => home_screenState();
}

class home_screenState extends State<home_screen> {
  late String enctoken; // Declare an instance variable to store enctoken

  @override
  void initState() {
    super.initState();
    // Initialize the instance variable with the value from the widget
    enctoken = widget.enctoken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(247, 255, 104, 104),
        title: const Text('Kiteflux'),
      ),
      body: Text(enctoken),
    );
  }
}

