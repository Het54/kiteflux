import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiteflux/kiteconnect.dart';


class order_screen extends StatefulWidget {
  const order_screen({Key? key, required this.enctoken, required this.triggerPrice, required this.tradingsymbol, required this.targetPrice, required this.stoplossPrice, required this.quantity, required this.productType, required this.exchange}) : super(key: key);

  final String enctoken;
  final double triggerPrice;
  final dynamic tradingsymbol;
  final double targetPrice;
  final double stoplossPrice;
  final int quantity;
  final dynamic productType;
  final dynamic exchange;

  @override
  order_screenState createState() => order_screenState();
}

class order_screenState extends State<order_screen> {
  late String enctoken; 
  late double triggerPrice;
  late dynamic tradingsymbol;
  late double targetPrice;
  late double stoplossPrice;
  late int quantity;
  late dynamic productType;
  late dynamic exchange;
  late String index_name;
  var indexlp;
  late Timer timer;
  List<dynamic> OrderList = [];

  @override
  void initState() {
    super.initState();
    enctoken = widget.enctoken;
    triggerPrice = widget.triggerPrice;
    tradingsymbol = widget.tradingsymbol;
    targetPrice = widget.targetPrice;
    stoplossPrice = widget.stoplossPrice;
    quantity = widget.quantity;
    productType = widget.productType;
    exchange = widget.exchange;
    RegExp regex = RegExp(r'^[a-zA-Z]+');
    Match? match = regex.firstMatch(tradingsymbol);
    index_name = match?.group(0) ?? '';
    if(tradingsymbol!="Null"){
      OrderList.add(
        {
          "tradingsymbol": tradingsymbol,
          "stoploss": stoplossPrice,
          "target": targetPrice,
          "quantity": quantity,
          "product": productType,
          "exchange": exchange,
        }
      );
    }
    get_last_price();
  }



  get_last_price() async {
    for(int i=0; i<OrderList.length; i++){
      String exchange = OrderList[i]['exchange'];
      String result = "";
      if(index_name == "NIFTY"){
        result = 'NSE:NIFTY 50';
      }
      else if(index_name == "BANKNIFTY"){
        result = 'NSE:NIFTY BANK';
      }
      else if(index_name == "FINNIFTY"){
        result = 'NSE:NIFTY FIN SERVICE';
      }
      var kite = kiteconnect(enctoken);
      var index_lp = await kite.ltp(result);

      
      

      String op_type = tradingsymbol.substring(tradingsymbol.length - 2);
      if(productType == "MIS"){
          productType = kiteconnect.PRODUCT_MIS;
      }
      else{
          productType = kiteconnect.PRODUCT_NRML;
      }

      if(quantity>0){ //Buy Position
        if(op_type == 'CE'){
          while(true){
            setState(() {
              indexlp = index_lp[result]['last_price'];
            });
            if(indexlp>=targetPrice || indexlp<=stoplossPrice){
              sell_order(tradingsymbol, quantity, productType);
              break;
            }              
          }
        }

        else if(op_type == 'PE'){
          while(true){
            setState(() {
              indexlp = index_lp[result]['last_price'];
            });
            if(indexlp<=targetPrice || indexlp>=stoplossPrice){
              sell_order(tradingsymbol, quantity, productType);
              break;
            }              
          }
        }
      }
      else if(quantity<0){ //Sell Position
        if(op_type == 'CE'){
          while(true){
            setState(() {
              indexlp = index_lp[result]['last_price'];
            });
            if(indexlp<=targetPrice || indexlp>=stoplossPrice){
              buy_order(tradingsymbol, quantity, productType);
              break;
            }              
          }
        }

        else if(op_type == 'PE'){
          while(true){
            setState(() {
              indexlp = index_lp[result]['last_price'];
            });
            if(indexlp>=targetPrice || indexlp<=stoplossPrice){
              sell_order(tradingsymbol, quantity, productType);
              break;
            }              
          }
        }
      }
    }
    
    
  }


  sell_order(t_symbol, quantity, product_type) async{
    var kite = kiteconnect(enctoken);
    kite.placeOrder(kiteconnect.VARIETY_REGULAR, kiteconnect.EXCHANGE_NFO, t_symbol, kiteconnect.TRANSACTION_TYPE_SELL, quantity, product_type, kiteconnect.ORDER_TYPE_MARKET, null, null,null,null,null,null,null,"Sell_oreder");
  }

  buy_order(t_symbol, quantity, product_type) async{
    var kite = kiteconnect(enctoken);
    kite.placeOrder(kiteconnect.VARIETY_REGULAR, kiteconnect.EXCHANGE_NFO, t_symbol, kiteconnect.TRANSACTION_TYPE_BUY, quantity, product_type, kiteconnect.ORDER_TYPE_MARKET, null, null,null,null,null,null,null,"Sell_oreder");
  }

  

  

  @override
  Widget build(BuildContext context) {
    var text = "Stop Service";
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
                  itemCount: OrderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> orderList =
                        OrderList[index];

                    // Determine the color based on the quantity
                    Color quantityColor =
                        orderList['quantity'] >= 0 ? Colors.green : Colors.red;

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
                                  'Qty: ${orderList['quantity']}',
                                  style: TextStyle(
                                    color: quantityColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Type: ${orderList['product']}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 5), 
                            Text(
                                  orderList['tradingsymbol'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SL: ${orderList['stoploss']}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Tgt: ${orderList['target']}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),


                            Text(
                                  '$index_name: $indexlp',
                                  style: TextStyle(color: Colors.green),
                                ),
                          ],
                        ),
                        onTap: () {
                          // handle ontap here
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