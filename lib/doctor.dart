import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:health_connect/patient_details_doc.dart';
import 'package:health_connect/patients_list.dart';
import 'package:health_connect/reports_doc.dart';
import 'package:health_connect/symptoms.dart';
import 'package:health_connect/profile_page.dart';
import 'package:health_connect/widgets/custom_clipper.dart';
import 'package:health_connect/authentication.dart';
import 'package:health_connect/login.dart';
import 'package:health_connect/history_doc.dart';
import 'package:http/http.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<StatefulWidget> createState() => DoctorScreenState();
}

class DoctorScreenState extends State<DoctorScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  String userName = " ";
  List list2 = [];
  List nameList = [];
  String patientName = "";
  List<dynamic> _list = [];
  String profilePicUrl = "";
  Query usersref = FirebaseFirestore.instance
      .collection("users")
      .where('userType', isEqualTo: 2);
  @override
  void initState() {
    super.initState();
    firestoreInstance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        userName = value.data()!['name'];
        _list = value.data()!['patients'];
        profilePicUrl = value.data()!['imageUrl'];
        _list.forEach((element) {
          firestoreInstance
              .collection("users")
              .doc(element)
              .get()
              .then((value) {
            print(value.data()!['name']);
            setState(() {
              nameList.add(value.data()!['name']);
            });
          });
        });
      });
    });
  }

  // Map getDetails(int index) {
  //   String name = nameList[index];
  //   bool alco = false;
  //   bool smoke = false;
  //   String birth = "";
  //   String gender = "";
  //   String bp = "";
  //   String tbp = "";
  //   String temp = "";
  //   String tt = "";
  //   String oxy = "";
  //   String to = "";
  //   String hr = "";
  //   String thr = "";
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_list[index])
  //       .get()
  //       .then((value) {
  //     alco = value.data()!["alcohol"];
  //     smoke = value.data()!["smoke"];
  //     birth = DateTime.parse(value.data()!["birthday"].toDate().toString())
  //         .toString()
  //         .substring(0, 10);
  //     if (value.data()!["gender"] == 2) {
  //       gender = "Female";
  //     } else if (value.data()!["gender"] == 1) {
  //       gender = "Male";
  //     } else {
  //       gender = "Other";
  //     }
  //   });
  //   firestoreInstance
  //       .collection("readings")
  //       .doc(_list[index])
  //       .collection("Oxygen")
  //       .orderBy('timestamp', descending: true)
  //       .limit(1)
  //       .get()
  //       .then((value) {
  //     oxy = value.docs.first.data()["value"].toString();
  //     to = DateTime.parse(
  //             value.docs.first.data()["timestamp"].toDate().toString())
  //         .toString()
  //         .substring(0, 10);
  //   });
  //   firestoreInstance
  //       .collection("readings")
  //       .doc(_list[index])
  //       .collection("Temperature")
  //       .orderBy('timestamp', descending: true)
  //       .limit(1)
  //       .get()
  //       .then((value) {
  //     temp = value.docs.first.data()["value"].toString();
  //     tt = DateTime.parse(
  //             value.docs.first.data()["timestamp"].toDate().toString())
  //         .toString()
  //         .substring(0, 10);
  //   });
  //   firestoreInstance
  //       .collection("readings")
  //       .doc(_list[index])
  //       .collection("HeartRate")
  //       .orderBy('timestamp', descending: true)
  //       .limit(1)
  //       .get()
  //       .then((value) {
  //     hr = value.docs.first.data()["value"].toString();
  //     thr = DateTime.parse(
  //             value.docs.first.data()["timestamp"].toDate().toString())
  //         .toString()
  //         .substring(0, 10);
  //   });
  //   firestoreInstance
  //       .collection("readings")
  //       .doc(_list[index])
  //       .collection("BloodPressure")
  //       .orderBy('timestamp', descending: true)
  //       .limit(1)
  //       .get()
  //       .then((value) {
  //     bp = value.docs.first.data()["diastolic"].toString() +
  //         "/" +
  //         value.docs.first.data()["systolic"];
  //     thr = DateTime.parse(
  //             value.docs.first.data()["timestamp"].toDate().toString())
  //         .toString()
  //         .substring(0, 10);
  //   });
  //   var details = {
  //     "name": name,
  //     "alcohol": alco,
  //     "birthday": birth,
  //     "gender": gender,
  //     "oxygen": oxy,
  //     "to": to,
  //     "hr": hr,
  //     "thr": thr,
  //     "temp": temp,
  //     "tt": tt,
  //     "bp": bp,
  //     "tbp": tbp
  //   };
  //   return details;
  // }

  // Future getPatientName() async {
  //   List nL = await getP();
  //   return nL;
  // }

  // List getP() {
  //   _list.forEach((element) {
  //     firestoreInstance.collection("users").doc(element).get().then((value) {
  //       print(value.data()!['name']);
  //       nameList.add(value.data()!['name']);
  //     });
  //   });
  //   return nameList;
  // }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Constants.darkAccent, foregroundColor: Colors.white),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          children: [
            const DrawerHeader(
                padding: EdgeInsets.only(bottom: 40),
                child: Image(
                  image: AssetImage('assets/icons/logo.png'),
                  fit: BoxFit.contain,
                )),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text('Profile',
                  style: TextStyle(
                    color: Constants.darkAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: Constants.darkAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                ),
              ),
              onTap: () {
                Auth.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(pageBuilder: (context, _, __) {
                  return LoginPage(camera: widget.camera);
                }), (route) => false);
              },
            )
          ],
        ),
      ),
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Constants.lightAccent,
              height: Constants.headerHeight + statusBarHeight,
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),

          // BODY
          Padding(
            padding: const EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Hi,\nDoctor " + userName,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()));
                      },
                      child: CircleAvatar(
                        radius: 26.0,
                        backgroundImage: profilePicUrl == ""
                            ? const AssetImage(
                                    "assets/icons/default_picture.png")
                                as ImageProvider
                            : NetworkImage(profilePicUrl),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 150),
                const Text(
                  "YOUR PATIENTS",
                  style: TextStyle(
                      color: Constants.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  width: 240,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      Positioned(
                        child: ClipPath(
                          clipper:
                              MyCustomClipper(clipType: ClipType.semiCircle),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Color.fromRGBO(255, 171, 171, 0.1),
                            ),
                            height: 120,
                            width: 120,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Image(
                                  image: AssetImage('assets/icons/capsule.png'),
                                  width: 40,
                                  height: 40,
                                  color: Color(0xffffabab),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PatientsListScreen()),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const <Widget>[
                                      Text(
                                        "Patients",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Constants.textPrimary),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                //               FutureBuilder(
                // future: _fetchListItems(),
                // builder: (context, AsyncSnapshot snapshot) {
                //   if (!snapshot.hasData) {
                //     return Center(child: CircularProgressIndicator());
                //   } else {
                //     Container(
                //         child: ListView.builder(
                //             itemCount: snapshot.data.length,
                //             scrollDirection: Axis.horizontal,
                //             itemBuilder: (BuildContext context, int index) {
                //               return Text('${snapshot.data[index].title}');
                //             }));
                //   }
                // });
                Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: nameList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin:
                                const EdgeInsets.only(right: 15.0, bottom: 20),
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            width: 240,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                            ),
                            child: InkWell(
                              child: Text(
                                nameList[index],
                                style: TextStyle(fontSize: 20),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title: Text(
                                              nameList[index] + " Details"),
                                          actionsOverflowButtonSpacing: 20,
                                          actions: [
                                            InkWell(
                                              child:
                                                  const Text("Patient Details"),
                                              onTap: () {
                                                // var details = getDetails(index);
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PatientDetailsDocScreen(
                                                                patUid: _list[
                                                                    index])));
                                                // showDialog(
                                                //     context: context,
                                                //     builder: (context) {
                                                //       return Dialog(
                                                //         child: Container(
                                                //             child: Text(details
                                                //                 .toString())),
                                                //       );
                                                //     });
                                              },
                                            ),
                                            InkWell(
                                              child:
                                                  const Text("Patient History"),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HistoryDocScreen(
                                                                patUid: _list[
                                                                    index])));
                                              },
                                            ),
                                            InkWell(
                                              child:
                                                  const Text("Patient Reports"),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReportDocScreen(
                                                                patUid: _list[
                                                                    index])));
                                              },
                                            ),
                                          ]);
                                    });
                              },
                            ),
                          );
                        }))
                // FutureBuilder(
                //     future: getPatientName(),
                //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                //       if (snapshot.connectionState == ConnectionState.none ||
                //           snapshot.hasData == null ||
                //           snapshot.connectionState == ConnectionState.waiting) {
                //         return CircularProgressIndicator();
                //       }
                //       if (snapshot.hasData) {
                //         return ListView.builder(
                // shrinkWrap: true,
                // scrollDirection: Axis.vertical,
                // itemCount: nameList.length,
                //             itemBuilder: (BuildContext context, int index) {
                // return Container(
                // margin: const EdgeInsets.only(right: 15.0),
                // width: 240,
                // decoration: const BoxDecoration(
                //   borderRadius:
                //       BorderRadius.all(Radius.circular(10.0)),
                //   shape: BoxShape.rectangle,
                //   color: Colors.white,
                // ),
                //   child: InkWell(
                //     child: Text(nameList[index]),
                //   ),
                // );
                //             });
                //       }
                //       return Text("Loading");
                //     })
              ],
            ),
          )
        ],
      ),
    );
  }
}
