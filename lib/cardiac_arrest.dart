import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:health_connect/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardiacScreen extends StatefulWidget {
  int systolic;
  int diastolic;
  CardiacScreen({Key? key, required this.systolic, required this.diastolic})
      : super(key: key);

  @override
  State<CardiacScreen> createState() =>
      _CardiacScreenState(systolic, diastolic);
}

class _CardiacScreenState extends State<CardiacScreen> {
  int alco = 0;
  int smok = 0;
  int gen = 0;
  static int systolic = 0;
  static int diastolic = 0;
  final firestoreInstance = FirebaseFirestore.instance;

  _CardiacScreenState(systolic, diastolic) {
    systolic = systolic;
    diastolic = diastolic;
  }
  @override
  void initState() {
    getBp();
    super.initState();
  }

  void getBp() async {
    await firestoreInstance
        .collection('readings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('BloodPressure')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((value) {
      int dia = value.docs.first.data()["diastolic"];
      int sys = value.docs.first.data()["systolic"];
      setState(() {
        diastolic = dia;
        systolic = sys;
      });
    });
    await firestoreInstance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      alco = value.data()!["alcohol"];
      smok = value.data()!["smoke"];
      gen = value.data()!["gender"];
    });
  }

  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController cholesterolController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController bpsController =
      TextEditingController(text: systolic.toString());
  final TextEditingController bpdController =
      TextEditingController(text: diastolic.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        backgroundColor: Constants.darkAccent,
        foregroundColor: Colors.white,
        title: const Text('Enter Data'),
      ),
      body: Form(
          child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: ageController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                    hintText: 'Enter Your Age',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: heightController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Height',
                    hintText: 'Enter Height',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: weightController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Weight',
                    hintText: 'Enter Weight',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: cholesterolController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cholesterol',
                    hintText: 'Enter Cholesterol',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: glucoseController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Glucose',
                    hintText: 'Enter Glucose',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: bpdController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'BP Diastolic',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: bpsController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'BP Systolic',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  int glucose = int.parse(glucoseController.text);
                  if (glucose < 140) {
                    glucose = 1;
                  } else if (glucose >= 140 && glucose < 180) {
                    glucose = 2;
                  } else {
                    glucose = 3;
                  }
                  int cholesterol = int.parse(cholesterolController.text);
                  if (cholesterol < 100) {
                    cholesterol = 1;
                  } else if (cholesterol >= 100 && cholesterol < 140) {
                    cholesterol = 2;
                  } else {
                    cholesterol = 3;
                  }
                  CardiacModel cardiacModel = CardiacModel(
                    age: int.parse(ageController.text),
                    gender: gen,
                    height: double.parse(heightController.text),
                    weight: double.parse(weightController.text),
                    systolic: int.parse(bpsController.text),
                    diastolic: int.parse(bpdController.text),
                    alcoholic: alco,
                    smoker: smok,
                    cholestrol: cholesterol,
                    glucose: glucose,
                  );
                  Cardiac cardiac = await cardiacModel.getCardiacResponse();
                  if (int.parse(cardiac.cardio) == 0) {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Severity Prediction"),
                            content: const Text("Your cardiac health is good"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
                  } else {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Severity Prediction"),
                            content: const Text(
                                "Your cardiac health is not good. Contact your doctor immediately"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
                  }
                  print("Caridac: " + cardiac.cardio);
                },
                child: const Text("Continue",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300)),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(15, 8, 15, 8)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.lightYellow),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Constants.darkYellow),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
