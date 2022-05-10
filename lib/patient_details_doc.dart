import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientDetailsDocScreen extends StatefulWidget {
  const PatientDetailsDocScreen({Key? key, required this.patUid})
      : super(key: key);
  final String patUid;
  @override
  State<PatientDetailsDocScreen> createState() =>
      _PatientDetailsDocScreenState();
}

class _PatientDetailsDocScreenState extends State<PatientDetailsDocScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  String name = "";
  String alco = "";
  String smoke = "";
  String birth = "";
  String gender = "";
  String bp = "";
  String tbp = "";
  String temp = "";
  String tt = "";
  String oxy = "";
  String to = "";
  String hr = "";
  String thr = "";
  @override
  void initState() {
    // TODO: implement initState

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patUid.toString())
        .get()
        .then((value) {
      setState(() {
        name = value.data()!["name"];
      });
      setState(() {
        if (value.data()!["alcohol"]) {
          alco = "Yes";
        } else {
          alco = "No";
        }
      });
      setState(() {
        if (value.data()!["smoke"]) {
          smoke = "Yes";
        } else {
          smoke = "No";
        }
      });

      setState(() {
        birth = DateTime.parse(value.data()!["birthday"].toDate().toString())
            .toString()
            .substring(0, 10);
      });
      setState(() {
        if (value.data()!["gender"] == 2) {
          gender = "Female";
        } else if (value.data()!["gender"] == 1) {
          gender = "Male";
        } else {
          gender = "Other";
        }
      });
    });
    firestoreInstance
        .collection("readings")
        .doc(widget.patUid.toString())
        .collection("HeartRate")
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((value) {
      setState(() {
        hr = value.docs.first.data()["value"].toString();
        thr = DateTime.parse(
                value.docs.first.data()["timestamp"].toDate().toString())
            .toString()
            .substring(0, 10);
      });
    });
    firestoreInstance
        .collection("readings")
        .doc(widget.patUid.toString())
        .collection("Oxygen")
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((value) {
      setState(() {
        oxy = value.docs.first.data()["value"].toString();
        to = DateTime.parse(
                value.docs.first.data()["timestamp"].toDate().toString())
            .toString()
            .substring(0, 10);
      });
    });
    firestoreInstance
        .collection("readings")
        .doc(widget.patUid.toString())
        .collection("Temperature")
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((value) {
      setState(() {
        temp = value.docs.first.data()["value"].toString();
        tt = DateTime.parse(
                value.docs.first.data()["timestamp"].toDate().toString())
            .toString()
            .substring(0, 10);
      });
    });

    firestoreInstance
        .collection("readings")
        .doc(widget.patUid.toString())
        .collection("BloodPressure")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get()
        .then((value) {
      setState(() {
        bp = value.docs.first.data()["diastolic"].toString() +
            "/" +
            value.docs.first.data()["systolic"].toString();
        tbp = DateTime.parse(
                value.docs.first.data()["timestamp"].toDate().toString())
            .toString()
            .substring(0, 10);
      });
    });
    var details = {
      "name": name,
      "alcohol": alco,
      "birthday": birth,
      "gender": gender,
      "oxygen": oxy,
      "to": to,
      "hr": hr,
      "thr": thr,
      "temp": temp,
      "tt": tt,
      "bp": bp,
      "tbp": tbp
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.darkAccent,
          foregroundColor: Colors.white,
          title: const Text('Patient Details'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.all(20),
            child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "UID",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            widget.patUid.toString(),
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ]),
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Birthday",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            birth,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ]),
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Gender",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            gender,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ]),
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Alcoholic",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            alco,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ]),
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Smoker",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            smoke,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ]),
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Last Oxygen Reading and DateTime",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            oxy + " on " + to,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ]),
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Last Blood Pressure Reading and DateTime",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            bp + " on " + tbp,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ]),
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Last Heart Rate Reading and DateTime",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            hr + " on " + thr,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ]),
                TableRow(children: [
                  Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Last Temperature Reading and DateTime",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            temp + " on " + tt,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ])
              ],
            ),
          ),
        )
        // Container(
        //   margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        //   child: Column(
        //     children: [
        //       Row(children: [
        // Text(
        //   "UID\n",
        //   style: TextStyle(fontSize: 20),
        // ),
        //         Spacer(),
        // Text(
        //   widget.patUid.toString(),
        //   style: TextStyle(fontSize: 20),
        // )
        //       ]),
        //       Row(children: [
        //         Text("Birthday", style: TextStyle(fontSize: 20)),
        //         Spacer(),
        //         Text(birth, style: TextStyle(fontSize: 20))
        //       ]),
        //       Row(children: [
        //         Text("Gender", style: TextStyle(fontSize: 20)),
        //         Spacer(),
        //         Text(gender, style: TextStyle(fontSize: 20))
        //       ]),
        //       Row(children: [
        //         Text("Alcoholic", style: TextStyle(fontSize: 20)),
        //         Spacer(),
        //         Text(alco, style: TextStyle(fontSize: 20))
        //       ]),
        //       Row(children: [
        //         Text("Smoker", style: TextStyle(fontSize: 20)),
        //         Spacer(),
        //         Text(smoke, style: TextStyle(fontSize: 20))
        //       ]),
        //       Row(children: [
        //         Text("Last Oxygen Reading and DateTime",
        //             style: TextStyle(fontSize: 20)),
        //         Spacer(),
        //         Text(oxy + " on " + to, style: TextStyle(fontSize: 20))
        //       ]),
        //       Row(children: [
        //         Text("Last BP Reading and DateTime",
        //             style: TextStyle(fontSize: 20)),
        //         Spacer(),
        //         Text(bp + " on " + tbp, style: TextStyle(fontSize: 20))
        //       ]),
        //       Row(children: [
        //         Text("Last HR Reading and DateTime  ",
        //             style: TextStyle(fontSize: 20)),
        //         Text(hr + " on " + thr, style: TextStyle(fontSize: 20))
        //       ]),
        //       Row(children: [
        //         Text("Last Temperature Reading and DateTime",
        //             style: TextStyle(fontSize: 20)),
        //         Spacer(),
        //         Text(temp + " on " + tt, style: TextStyle(fontSize: 20))
        //       ]),
        //     ],
        //   ),
        // )
        );
  }
}
