// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/ui/auth/login_screen.dart';
import 'package:firebase_flutter/ui/firebase_firestore/firebase_firestore_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/post/post_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Future.delayed(
        Duration(seconds: 3),
        () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FireStoreScreen(),
            )),
      );
    } else {
      Future.delayed(
        Duration(seconds: 3),
        () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            )),
      );
    }
  }
}
