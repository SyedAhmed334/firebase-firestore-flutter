// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_flutter/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

import '../../../utilities/utils.dart';
import 'add_post_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Post Screen'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              }).onError((error, stackTrace) {
                Utils().toastMessage(context, error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Search here...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: databaseRef,
              defaultChild: Text('Add data here!'),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();
                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(
                      snapshot.child('title').value.toString(),
                    ),
                    subtitle: Text(
                      snapshot.child('id').value.toString(),
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialogue(
                                  snapshot.child('title').value.toString(),
                                  snapshot.child('id').value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                            onTap: () {
                              setState(() {});
                              databaseRef
                                  .child(snapshot.child('id').value.toString())
                                  .remove();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase())) {
                  return ListTile(
                    title: Text(
                      snapshot.child('title').value.toString(),
                    ),
                    subtitle: Text(
                      snapshot.child('id').value.toString(),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> showMyDialogue(String title, String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        editController.text = title;
        return AlertDialog(
          title: Text('Update'),
          content: TextFormField(
            controller: editController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                databaseRef
                    .child(id)
                    .update({
                      'title': editController.text,
                    })
                    .then((value) => Utils().toastMessage(context, 'Success!!'))
                    .onError((error, stackTrace) {
                      Utils().toastMessage(context, error.toString());
                    });
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

// Expanded(
// child: StreamBuilder(
// stream: databaseRef.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (!snapshot.hasData) {
// return CircularProgressIndicator();
// } else {
// Map<dynamic, dynamic> map =
// snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(list[index]['title'].toString()),
// subtitle: Text(list[index]['id'].toString()),
// );
// },
// );
// }
// },
// ),
// ),
