import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:health_connect/symptoms.dart';
import 'package:health_connect/profile_page.dart';
import 'package:health_connect/widgets/card_main.dart';
import 'package:health_connect/widgets/card_section.dart';
import 'package:health_connect/widgets/custom_clipper.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({Key? key}) : super(key: key);

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
              onTap: () {},
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text('History',
                  style: TextStyle(
                    color: Constants.darkAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  )),
              onTap: () {},
            ),
            ListTile(
              minVerticalPadding: 20,
              title: const Text('Check Severity',
                  style: TextStyle(
                    color: Constants.darkAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                  )),
              onTap: () {},
            ),
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
                // Header - Greetings and Avatar
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        "Hi,\nDoctor",
                        style: TextStyle(
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
                      child: const CircleAvatar(
                        radius: 26.0,
                        backgroundImage:
                            AssetImage('assets/icons/default_picture.png'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 80),

                // Main Cards - Heartbeat and Blood Pressure
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
                                            const SymptomsScreen()),
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
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
