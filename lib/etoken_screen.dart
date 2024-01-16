import 'package:flutter/material.dart';

class Etoken extends StatefulWidget {  
  
const Etoken({ Key? key }) : super(key: key);

  @override
  EtokenState createState() => EtokenState();


}

class EtokenState extends State<Etoken> {

  List<dynamic> BeatsList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromARGB(247, 255, 104, 104),
      title: const Text('Kiteflux'),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 250,),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal)
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(247, 255, 104, 104))
              ),
              border: OutlineInputBorder(),
              labelText: 'EncToken',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shadowColor: Colors.teal,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
            ),
          onPressed: () {},
          child: const Text('Submit', style: TextStyle(color: Colors.teal, fontSize: 15)),
        ),
      ],
    ), 
  );
}

  
  
}
