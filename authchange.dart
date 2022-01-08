//import 'dart:convert';


//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Autho with ChangeNotifier{
  final googleSignIn=GoogleSignIn();
  String tok;
  String useor;
  List  phone=[];
  DateTime exp;
  GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  Future googlelog() async {
   // phone.add(a);
    final googleus= await googleSignIn.signIn();
    if(googleus==null)
      return;
    _user=googleus;
    final googleauth= await googleus.authentication;
    final cred=GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(cred);
    notifyListeners();
  }
 

  Future signout() async{

    FirebaseAuth.instance.currentUser.delete();

   await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }



  notifyListeners();
}
