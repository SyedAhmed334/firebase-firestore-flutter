// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/ui/post/post_screen.dart';
import 'package:flutter/material.dart';

import '../../utilities/utils.dart';
import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  VerifyCodeScreen({required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final phoneNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Verify')),
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
                  hintText: 'Enter 6 digit code',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final credentials = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: phoneNumberController.text);
                try {
                  await auth.signInWithCredential(credentials);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostScreen(),
                      ));
                  setState(() {
                    loading = false;
                  });
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(context, e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
