import 'package:flutter/material.dart';

Widget position_cardview(
    {required String heading,}) {
  return Container(
    width: 370,
    height: 90,
    margin: EdgeInsets.fromLTRB(0, 20, 1, 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(heading),
            ],
          ),
        ),
      ],
    ),
  );
}
