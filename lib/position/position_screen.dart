import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kiteflux/kiteconnect.dart';

class position_screen extends StatefulWidget {
  const position_screen({Key? key, required this.enctoken}) : super(key: key);

  final String enctoken;

  @override
  position_screenState createState() => position_screenState();
}

class position_screenState extends State<position_screen> {
  late String enctoken;
  List<dynamic> PositionList = [];
  late Timer timer;
  dynamic toatlpnl = 0;

  @override
  void initState() {
    super.initState();
    enctoken = widget.enctoken;
    get_position();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      get_last_price(); // Update positions every second
    });
  }

  Future<void> get_position() async {
    try {
      var kite = kiteconnect(enctoken);
      var positions = await kite.positions();
      setState(() {
        PositionList = positions['data']['net'];
        print(PositionList);
      });
    } catch (e) {
      print("Error fetching positions: $e");
      // Handle error
    }
  }

  get_last_price() async {
    for (int i = 0; i < PositionList.length; i++) {
      String exchange = PositionList[i]['exchange'];
      String tradingsymbol = PositionList[i]['tradingsymbol'];
      String result = '$exchange:$tradingsymbol';

      var kite = kiteconnect(enctoken);
      var lastp = await kite.ltp(result);
      var average = PositionList[i]['average_price'];
      var qty = PositionList[i]['quantity'];
      var lastprice = lastp[result]['last_price'];
      var pnl = PositionList[i]['pnl'];
      if(qty < 0){
        pnl = (average-lastprice)*-(qty);
      }
      else if(qty > 0){
        pnl = (average-lastprice)*(qty);
      }
      toatlpnl += pnl; 
      setState(() {
        PositionList[i]['last_price'] = lastprice;
        PositionList[i]['pnl'] = pnl;
      });
    }
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalPnL = PositionList.fold(
        0, (sum, position) => sum + (position['pnl'] ?? 0.0));
    
    Color totalPnLColor = totalPnL > 0 ? Colors.green : totalPnL < 0 ? Colors.red : Colors.black;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('KiteFlux')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: PositionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> positionList =
                        PositionList[index];

                    // Determine the color based on the quantity
                    Color quantityColor =
                        positionList['quantity'] >= 0 ? Colors.green : Colors.red;

                    // Determine the color based on P&L
                    Color pnlColor =
                        positionList['pnl'] >= 0 ? Colors.green : Colors.red;

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(
                          vertical: 3, horizontal: 3),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Qty: ${positionList['quantity']}',
                                  style: TextStyle(
                                    color: quantityColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${positionList['exchange']}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  positionList['tradingsymbol'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'P&L: ',
                                  style: TextStyle(
                                    color: pnlColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${positionList['pnl']}',
                                  style: TextStyle(
                                    color: pnlColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Type: ${positionList['product']}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text('LTP: ${positionList['last_price']}'),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text('Avg: ${positionList['average_price']}'),
                          ],
                        ),
                        onTap: () {
                          // Handle tap if needed
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0), // Add padding of 8.0 (adjust as needed)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total P&L',
                      style: TextStyle(
                        fontSize: 18, // Adjust the font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$totalPnL',
                      style: TextStyle(
                        color: totalPnL > 0 ? Colors.green : totalPnL < 0 ? Colors.red : Colors.black,
                        fontSize: 18, // Adjust the font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
