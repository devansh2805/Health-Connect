import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  final firestoreInstance = FirebaseFirestore.instance;
  List<HeartRateData> hrdata = [];

  void initState() {
    super.initState();
    getValues();
  }

  void getValues() {
    firestoreInstance
        .collection('readings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('HeartRate')
        .orderBy('timestamp')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        hrdata.add(HeartRateData(
            element.data()["timestamp"], element.data()["value"]));
      });
    });
  }

  var tod = DateTime.now();
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
          title: const Text('Patient History'),
        ),
        body: ListView(
          children: [
            SfCartesianChart(
              primaryXAxis:
                  CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
              series: [
                LineSeries(
                  dataSource: hrdata,
                  xValueMapper: (HeartRateData heart, _) => heart.time,
                  yValueMapper: (HeartRateData heart, _) => heart.val,
                )
              ],
            ),
          ],
        ));
  }
}

class HeartRateData {
  HeartRateData(this.time, this.val);
  final String time;
  final double val;
}
