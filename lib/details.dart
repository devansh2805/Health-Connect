import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connect/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NamePageState();
  }
}

class NamePageState extends State<NamePage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 90.0,
            ),
            Center(
              child: Text(
                "Enter your Name",
                style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.person,
                ),
                hintText: 'Your name',
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  const Color(
                    0xffffffff,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(
                    0xff00C6BD,
                  ),
                ),
              ),
              onPressed: () async {
                if (_nameController.text == '') {
                  Fluttertoast.showToast(
                    msg: "Name Cannot be Empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    'uid': FirebaseAuth.instance.currentUser!.uid,
                    'name': _nameController.text,
                    'phoneNumber':
                        FirebaseAuth.instance.currentUser!.phoneNumber,
                  });
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const MyHomePage(
                          title: 'Health Connect',
                        );
                      },
                    ),
                  );
                }
              },
              child: const Text(
                "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
