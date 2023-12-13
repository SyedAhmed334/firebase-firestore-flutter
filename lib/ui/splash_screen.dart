// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../firebase_services/splash_services.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Firebase Practice',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
