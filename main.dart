import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginpage1/authchange.dart';
import 'package:loginpage1/qr_generator.dart';
//import 'package:loginpage1/queen.dart';
//import 'package:loginpage1/qr_generator.dart';

import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home:
  Myapp1() ));
}

enum Auth{
  login,
  signup
}

class Myapp1 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(body: ChangeNotifierProvider(create: (ctx)=>Autho() ,
      child: StreamBuilder(
        stream:FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if (snapshot.hasData){
            return MyApp();
          }
          else if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          else{
            return  Home();
          }
        },
      ),
    ) ,);
  }

}

class  Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  Auth auth=Auth.login;
  Map<String,String> data={
    "email":'',
    "password":''
  };
  final password=TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Future<void> submit() async{
    final valid=_formKey.currentState.validate();
    if(valid){
      _formKey.currentState.save();
    }
    try{
      if(auth==Auth.login){
        await Provider.of<Autho>(context,listen: false).loginemail(data['email'], data['password']);
      }
      if(auth==Auth.signup){
        await Provider.of<Autho>(context,listen: false).sigupemail(data['email'], data['password']);
      }
    }catch(error){
      print(error);
    }
  }

  void _switch() {
    if (auth == Auth.login) {
      setState(() {
        auth = Auth.signup;
      });
    }
    else {
      setState(() {
        auth = Auth.login;
      });
    }
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Container(width: double.infinity,
      decoration: BoxDecoration(
          gradient:LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink[300],
                Colors.pinkAccent,
                Colors.pink[200]
              ]
          )
      ),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height:45.0),
          Icon(Icons.group_add,size: 60,),
          SizedBox(height:40.0),
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (str){
                  if(str.isEmpty || !str.contains('@')|| !str.contains('.com')){
                    return "Invalid type";
                  }
                  return null;
                },
                onSaved: (str){
                  data['email']=str;
                },
              ),
              SizedBox(height:30.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: password,
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
                validator: (str){
                  if(str.isEmpty ){
                    return "Invalid type";
                  }
                  return null;
                },
                onSaved: (str){
                  data['password']=str;
                },
              ),
              SizedBox(height:30.0),
              if(auth==Auth.signup)
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: 'ReEnter the Password'),
                  validator:auth==Auth.signup ? (str){
                    if(str!=password.text){
                      return "Invalid type";
                    }
                    return null;
                  }:null,

                )
              ,
              ElevatedButton(onPressed: submit, child: Text(auth==Auth.login?'Login':'Signup')),
              TextButton(onPressed: _switch,
                  child: Text(auth==Auth.login?'Signup':'Login',
                    style: TextStyle(color: Colors.black),)),
              TextButton(
                //style: ButtonStyle(shape: MaterialStateProperty.all<TextDecoration.underline> ),
                child:Text("signin with google",style:TextStyle(decoration: TextDecoration.underline,)),
                onPressed: (){
                  Provider.of<Autho>(context, listen: false).googlelog();
                },

              ),

            ],),
          )
        ],
      ),
    ),);
  }
}