import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({Key? key}) : super(key: key);
  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getSymps();
  bool value = false;
  String alert = "";
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var symptomsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.darkAccent,
          foregroundColor: Colors.white,
          title: const Text('Add Symptoms'),
        ),
        body: ListView.builder(
            itemCount: checkBoxListTileModel.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      CheckboxListTile(
                          activeColor: Colors.pink[300],
                          dense: true,
                          title: Text(
                            checkBoxListTileModel[index].title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5),
                          ),
                          value: checkBoxListTileModel[index].isCheck,
                          secondary: const SizedBox(
                            height: 50,
                            width: 50,
                          ),
                          onChanged: (bool? val) {
                            itemChange(val!, index);
                          })
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            saveFunction();
          },
          child: const Icon(Icons.arrow_right_alt, size: 40.0),
          backgroundColor: Constants.darkAccent,
          foregroundColor: Colors.white,
        ));
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
    });
  }

  Future<void> saveFunction() async {
    int num = checkBoxListTileModel.length;
    for (var i = 0; i < num; i++) {
      if (checkBoxListTileModel[i].isCheck == true) {
        symptomsList.add(checkBoxListTileModel[i].title);
      }
    }
    await FirebaseFirestore.instance.collection('userSymptoms').add({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'symptoms': symptomsList,
      'time': Timestamp.now()
    });

    if (checkBoxListTileModel[0].isCheck &&
        checkBoxListTileModel[2].isCheck &&
        checkBoxListTileModel[3].isCheck) {
      alert = "Please test yourself for Covid-19";
    }
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            elevation: 5,
            backgroundColor: Colors.indigo[50],
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width - 10,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Text(
                        alert,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CheckBoxListTileModel {
  int symId;
  String title;
  bool isCheck;

  CheckBoxListTileModel(
      {required this.symId, required this.title, required this.isCheck});

  static List<CheckBoxListTileModel> getSymps() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(symId: 1, title: "Fever", isCheck: false),
      CheckBoxListTileModel(symId: 2, title: "Runny Nose", isCheck: false),
      CheckBoxListTileModel(symId: 3, title: "Cough", isCheck: false),
      CheckBoxListTileModel(symId: 4, title: "Bodyache", isCheck: false),
      CheckBoxListTileModel(symId: 5, title: "Fatigue", isCheck: false),
      CheckBoxListTileModel(symId: 6, title: "Headache", isCheck: false),
      CheckBoxListTileModel(symId: 7, title: "Vomiting", isCheck: false),
      CheckBoxListTileModel(symId: 8, title: "Rash", isCheck: false),
      CheckBoxListTileModel(symId: 9, title: "Nausea", isCheck: false),
      CheckBoxListTileModel(symId: 10, title: "Diarrhoea", isCheck: false),
    ];
  }
}
