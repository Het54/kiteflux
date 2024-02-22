import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kiteflux/Orders/order_screen.dart';
import 'package:kiteflux/home_screen.dart';
import 'package:kiteflux/kiteconnect.dart';
import 'package:kiteflux/Position/position_caardview.dart';
import 'package:intl/intl.dart';
import 'package:kiteflux/position/position_screen.dart';

class watchlist_screen extends StatefulWidget {
  const watchlist_screen({Key? key, required this.enctoken}) : super(key: key);
  final String enctoken;

  @override
  watchlist_screenState createState() => watchlist_screenState();
}

class watchlist_screenState extends State<watchlist_screen> {
  late String enctoken;
  List<Map<String, dynamic>> allInstruments = [];
  List<Map<String, dynamic>> filteredInstruments = [];

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    enctoken = widget.enctoken;
    get_instruments();
  }

  Future<void> get_instruments() async {
    var kite = kiteconnect(enctoken);
    var instruments = await kite.instruments("NFO");
    // List<Map<String, dynamic>> result = await instruments.where((i) =>
    //     i['name'] == "NIFTY" &&
    //     i['expiry'] == DateTime(2024, 2, 29) &&
    //     i['strike'] == 22050 &&
    //     i['instrument_type'] == "PE").toList();
    // print(result);
    if (!isDisposed) {
      setState(() {
        allInstruments = instruments;
        filteredInstruments = instruments;
      });
    }
  }

  String formatInstrument(Map<String, dynamic> instrument) {
  var expiry = instrument['expiry'];
  if (expiry is DateTime) {
    // 'expiry' is already a DateTime, no need to parse
    return "${instrument['name']} ${DateFormat('dd MMM').format(expiry)} ${instrument['strike']} ${instrument['instrument_type']}";
  } else if (expiry is String) {
    // 'expiry' is a String, parse it to DateTime
    DateTime expiryDateTime = DateTime.parse(expiry);
    return "${instrument['name']} ${DateFormat('dd MMM').format(expiryDateTime)} ${instrument['strike']} ${instrument['instrument_type']}";
  } else {
    // Handle other cases or return a default value
    return "Invalid instrument data";
  }
}

  void filterInstruments(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredInstruments = allInstruments;
      });
    } else {
      setState(() {
        filteredInstruments = allInstruments
            .where((i) => formatInstrument(i).toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('KiteFlux')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (query) {
                  filterInstruments(query);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 5,),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredInstruments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> instrument = filteredInstruments[index];

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                      child: ListTile(
                        title: Text(
                          formatInstrument(instrument),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Last Price: ${instrument['last_price']}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController triggerPriceController = TextEditingController();

                              return AlertDialog(
                                title: Text(
                                  "Trigger Price based on ${instrument['name']}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Enter Trigger Price:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    TextFormField(
                                      controller: triggerPriceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Enter trigger price',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Validate trigger price and send it to another screen
                                      String triggerPriceText = triggerPriceController.text.trim();
                                      if (triggerPriceText.isNotEmpty) {
                                        // Convert the trigger price to a float
                                        double triggerPrice = double.tryParse(triggerPriceText) ?? 0.0;

                                        // Send triggerPrice to another screen
                                        Navigator.of(context).pop(); // Close the dialog
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => order_screen(
                                              enctoken: widget.enctoken,
                                              triggerPrice: triggerPrice,
                                              tradingsymbol: instrument['tradingsymbol'],
                                              targetPrice: 0.00,
                                              stoplossPrice: 0.00,
                                              quantity: 0,
                                              productType: Null,
                                              exchange: Null,),

                                          ),
                                        );
                                        
                                      } else {
                                        // Show an error message if trigger price is not entered
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Please enter a valid trigger price.'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('Submit'),
                                  ),
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.white,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

