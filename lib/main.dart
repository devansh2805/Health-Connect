import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_connect/doctor.dart';
import 'package:health_connect/login.dart';
import 'package:health_connect/patient_screen.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  CameraDescription camera;

  Future<DocumentSnapshot> getUserType() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health Connect',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? LoginPage(camera: camera)
            : MyHomePage(camera: camera));
  }
}

class MyHomePage extends StatefulWidget {
  final CameraDescription camera;
  const MyHomePage({Key? key, required this.camera}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<int> getUserDetails() async {
    int userType = 1;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userType = value.data()!['userType'];
    });
    return userType;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == 1) {
            return const DoctorScreen();
          } else {
            return HomeScreen(camera: widget.camera);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
