import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_connect/doctor.dart';
import 'package:health_connect/login.dart';
import 'package:health_connect/patient_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Future<DocumentSnapshot> user = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    return value.data()!['userType'];
  });

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(user);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health Connect',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? const LoginPage()
            : (user.toString() == "Doctor"
                ? const DoctorScreen()
                : const HomeScreen()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Hi',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
