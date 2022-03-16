import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class CardiacScreen extends StatefulWidget {
  const CardiacScreen({Key? key}) : super(key: key);
  @override
  State<CardiacScreen> createState() => _CardiacScreenState();
}

class _CardiacScreenState extends State<CardiacScreen> {
  bool value1 = false;
  bool value2 = false;
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
              const Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  style: TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                    hintText: 'Enter Your Age',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  style: TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Height',
                    hintText: 'Enter Height',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  style: TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Weight',
                    hintText: 'Enter Weight',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  style: TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cholestrol',
                    hintText: 'Enter Cholestrol',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  style: TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Glucose',
                    hintText: 'Enter Glucose',
                  ),
                ),
              ),
              Row(children: <Widget>[
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Smoker',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 2.0,
                  child: Checkbox(
                    activeColor: Constants.lightYellow,
                    checkColor: Constants.darkYellow,
                    value: this.value1,
                    onChanged: (bool? value) {
                      setState(() {
                        this.value1 = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ]),
              Row(children: <Widget>[
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Alcoholic',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 2.0,
                  child: Checkbox(
                    activeColor: Constants.lightYellow,
                    checkColor: Constants.darkYellow,
                    value: this.value2,
                    onChanged: (bool? value) {
                      setState(() {
                        this.value2 = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ]),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("Continue",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w300)),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(15, 8, 15, 8)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Constants.lightYellow),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Constants.darkYellow),
                  ))
            ],
          )
        ],
      )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     saveFunction();
      //   },
      //   child: const Icon(Icons.arrow_right_alt, size: 40.0),
      //   backgroundColor: Constants.darkAccent,
      //   foregroundColor: Colors.white,
      // )
    );
  }
}
