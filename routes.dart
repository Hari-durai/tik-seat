import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginpage1/payment.dart';

class Routes extends StatefulWidget{
  Routes(this.auth);
  final String auth;
  @override
  _RoutesState createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  String author;
  @override
  void initState() {
    if (author==null){
      author=widget.auth;
    }
    setState(() {
      author=widget.auth;
      getfn();
    });
   
    print(author);
    super.initState();
  }
  getfn() async{
    print(author);
    author=widget.auth;
    return  FirebaseFirestore.instance.collection('user').doc(author).collection('route');

  }

  @override
  Widget build(BuildContext context) {
   author='RYuefU3bDWedYNBozQMlNTp0wRw2';
    Query query =FirebaseFirestore.instance.collection('user').doc(author).collection('route');

    return author==null?getfn():Scaffold(appBar: AppBar(title: Column(
      children: [
        Text("All Routes"),
        Text("TN-50-2425")
      ],
    ),centerTitle: true,backgroundColor: Colors.brown,actions: [IconButton(icon: Icon(Icons.logout),
        onPressed: (){FirebaseAuth.instance.signOut();})]),
        body: Container(
          padding: EdgeInsets.only(top: 40),
          child: StreamBuilder<Object>(
              stream: query.snapshots(),
              builder: (context, stream) {
                QuerySnapshot querySnapshot = stream.data;
                if(stream.connectionState==ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(),);
                else if(stream.hasError){
                  print(author);
                }
                return ListView.builder(
                    itemCount:querySnapshot.docs.length,
                    itemBuilder: (ctx,index)=>
                        Card(
                          child: ListTile(title:
                          Text(querySnapshot.docs[index]['Route'],style:TextStyle(fontSize: 20),),
                            trailing: Text("₹${querySnapshot.docs[index]['Price']}",style: TextStyle(fontSize: 20),),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      Payment(querySnapshot.docs[index]['Price'])
                                  )
                              );
                            },

                          ),
                        ));
              }
  }
}
