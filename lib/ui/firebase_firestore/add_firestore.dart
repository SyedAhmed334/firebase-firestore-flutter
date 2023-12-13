// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

import '../../utilities/utils.dart';

class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({super.key});

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData> {
  bool loading = false;
  final fireStoreController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firestore Data'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              maxLines: 4,
              controller: fireStoreController,
              decoration: InputDecoration(
                hintText: 'Add data here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore
                      .doc(id)
                      .set({'title': fireStoreController.text, 'id': id}).then(
                          (value) {
                    Utils().toastMessage(context, 'Success!');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(context, error.toString());
                  });
                }),
          ],
        ),
      ),
    );
  }
}
