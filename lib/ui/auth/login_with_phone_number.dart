// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/ui/auth/verify_code.dart';
import 'package:firebase_flutter/utilities/utils.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final phoneNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number here',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Sign Up',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: (e) {
                        Utils().toastMessage(context, e.toString());
                        setState(() {
                          loading = false;
                        });
                      },
                      codeSent: (String verificationId, int? token) {
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyCodeScreen(
                                verificationId: verificationId),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (e) {
                        Utils().toastMessage(context, e.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                }),
          ],
        ),
      ),
    );
  }
}
