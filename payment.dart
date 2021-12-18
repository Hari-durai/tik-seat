//import 'dart:html';

//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';



// ignore: must_be_immutable
class Payment extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);
  Payment(this.value);
   var value;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Payment> {
  int _itemCount = 1;
  var _razorpay;
  var amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    showDialog(context: context, builder: (ctx)=>
        AlertDialog(content: Text("You Are Pay for  $_itemCount Tickets"),title: Text("You transaction is Success"),actions: [
          TextButton(onPressed:()=>Navigator.of(context).pop(), child:Text("Okay"))
        ],)
    );
    print("Payment Done");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showDialog(context: context, builder: (ctx)=>
        AlertDialog(content: Text("Error Occurred"),title: Text("Transaction Failed"),actions: [
          TextButton(onPressed:()=>Navigator.of(context).pop(), child:Text("Okay"))
        ],)
    );
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(backgroundColor: Colors.black45,
      appBar: AppBar(title: Text("Safe Payment"),centerTitle: true,backgroundColor: Colors.brown,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(margin: EdgeInsets.all(10),color:Colors.white54,
                child: ListTile(title: Text("Per Ticket is",style: TextStyle(fontSize: 23,color: Colors.deepPurpleAccent),),trailing: Text("₹${widget.value}"),)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child:   Row(
                    children: <Widget>[Text("How Many Member?",style: TextStyle(fontSize: 20,color: Colors.deepPurpleAccent),),SizedBox(width: 60,),
                      _itemCount!=1? new  IconButton(icon: new Icon(Icons.remove),onPressed: ()=>setState(()=>_itemCount--),):new Container(),
                      new Text(_itemCount.toString()),
                      new IconButton(icon: new Icon(Icons.add),onPressed: ()=>setState(()=>_itemCount++))
                    ],
                  ),

            ),
            CupertinoButton(
                color: Colors.purple,
                child: Text("Pay"),
                onPressed: () {
                  ///Make payment
                  var options = {
                    'key': "rzp_test_8V7cxEodnaGp8S",
                    // amount will be multiple of 100
                    'amount':(int.parse(widget.value)*100*_itemCount)// (int.parse(amountController.text) * 100)
                        .toString(), //So its pay 500
                    'name': 'Secure Payment',
                    'description': 'Demo',
                    'timeout': 300, // in seconds
                    'prefill': {
                      'contact': '6385493863',
                      'email': 'prakash2001ttl@gmail.com'
                    }
                  };
                  _razorpay.open(options);
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }
}