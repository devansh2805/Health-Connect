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
  List<BloodPressureSysData> bpsdata = [];
  List<BloodPressureDiasData> bpddata = [];
  List<OxygenData> oxydata = [];
  List<TemperatureData> tempdata = [];

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
        setState(() {
          hrdata.add(HeartRateData(
              DateTime.parse(element.data()["timestamp"].toDate().toString())
                  .toString()
                  .substring(0, 10),
              element.data()["value"]));
        });
      });
    });

    firestoreInstance
        .collection('readings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('BloodPressure')
        .orderBy('timestamp')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          bpsdata.add(BloodPressureSysData(
              DateTime.parse(element.data()["timestamp"].toDate().toString())
                  .toString()
                  .substring(0, 10),
              element.data()["systolic"]));
          bpddata.add(BloodPressureDiasData(
              DateTime.parse(element.data()["timestamp"].toDate().toString())
                  .toString()
                  .substring(0, 10),
              element.data()["diastolic"]));
        });
      });
    });

    firestoreInstance
        .collection('readings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Oxygen')
        .orderBy('timestamp')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          oxydata.add(OxygenData(
              DateTime.parse(element.data()["timestamp"].toDate().toString())
                  .toString()
                  .substring(0, 10),
              element.data()["value"]));
        });
      });
    });

    firestoreInstance
        .collection('readings')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Temperature')
        .orderBy('timestamp')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          tempdata.add(TemperatureData(
              DateTime.parse(element.data()["timestamp"].toDate().toString())
                  .toString()
                  .substring(0, 10),
              element.data()["value"]));
        });
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
              title: ChartTitle(text: "Heart Rate History"),
              primaryXAxis:
                  CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
              series: [
                LineSeries(
                  markerSettings: MarkerSettings(isVisible: true),
                  dataSource: hrdata,
                  xValueMapper: (HeartRateData heart, _) => heart.time,
                  yValueMapper: (HeartRateData heart, _) => heart.val,
                )
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: "Blood Pressure - Systolic History"),
              primaryXAxis:
                  CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
              series: [
                LineSeries(
                  markerSettings: MarkerSettings(isVisible: true),
                  dataSource: bpsdata,
                  xValueMapper: (BloodPressureSysData bps, _) => bps.time,
                  yValueMapper: (BloodPressureSysData bps, _) => bps.val,
                )
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: "Blood Pressure - Diastolic History"),
              primaryXAxis:
                  CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
              series: [
                LineSeries(
                  markerSettings: MarkerSettings(isVisible: true),
                  dataSource: bpddata,
                  xValueMapper: (BloodPressureDiasData bpd, _) => bpd.time,
                  yValueMapper: (BloodPressureDiasData bpd, _) => bpd.val,
                )
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: "Oxygen History"),
              primaryXAxis:
                  CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
              series: [
                LineSeries(
                  markerSettings: MarkerSettings(isVisible: true),
                  dataSource: oxydata,
                  xValueMapper: (OxygenData oxy, _) => oxy.time,
                  yValueMapper: (OxygenData oxy, _) => oxy.val,
                )
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: "Body Temperature History"),
              primaryXAxis:
                  CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
              series: [
                LineSeries(
                  markerSettings: MarkerSettings(isVisible: true),
                  dataSource: tempdata,
                  xValueMapper: (TemperatureData temp, _) => temp.time,
                  yValueMapper: (TemperatureData temp, _) => temp.val,
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
  final int val;
}

class BloodPressureSysData {
  BloodPressureSysData(this.time, this.val);
  final String time;
  final int val;
}

class BloodPressureDiasData {
  BloodPressureDiasData(this.time, this.val);
  final String time;
  final int val;
}

class OxygenData {
  OxygenData(this.time, this.val);
  final String time;
  final int val;
}

class TemperatureData {
  TemperatureData(this.time, this.val);
  final String time;
  final int val;
}
