import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_connect/patient_screen.dart';
import 'package:health_connect/doctor.dart';
import 'package:camera/camera.dart';

class NamePage extends StatefulWidget {
  const NamePage({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<StatefulWidget> createState() {
    return NamePageState();
  }
}

class NamePageState extends State<NamePage> {
  late TextEditingController _nameController;
  int _userType = 1;
  int _gender = 1;
  DateTime selectedDate = DateTime(DateTime.now().year);
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 90.0,
            ),
            Center(
              child: Text(
                "Personal Details",
                style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.person,
                ),
                hintText: 'Your name',
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            DropdownButton(
              value: _userType,
              items: const [
                DropdownMenuItem(
                  child: Text("Doctor"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("Patient"),
                  value: 2,
                )
              ],
              hint: const Text("Select User Type"),
              onChanged: (int? value) {
                setState(() {
                  _userType = value!;
                });
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            DropdownButton(
              value: _gender,
              items: const [
                DropdownMenuItem(
                  child: Text("Male"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("Female"),
                  value: 2,
                ),
                DropdownMenuItem(
                  child: Text("Other"),
                  value: 3,
                )
              ],
              hint: const Text("Select Gender"),
              onChanged: (int? value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("DOB"),
              const SizedBox(width: 20),
              Text(selectedDate.day.toString() +
                  "/" +
                  selectedDate.month.toString() +
                  "/" +
                  selectedDate.year.toString()),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text(
                  'Pick Date',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  const Color(
                    0xffffffff,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(
                    0xff00C6BD,
                  ),
                ),
              ),
              onPressed: () async {
                if (selectedDate == DateTime.now()) {
                  Fluttertoast.showToast(
                    msg: "Please select your date of birth",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  if (_nameController.text == '') {
                    Fluttertoast.showToast(
                      msg: "Name Cannot be Empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({
                      'uid': FirebaseAuth.instance.currentUser!.uid,
                      'name': _nameController.text,
                      'phoneNumber':
                          FirebaseAuth.instance.currentUser!.phoneNumber,
                      'userType': _userType,
                      'gender': _gender,
                      'birthday': selectedDate
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          if (_userType == 1) {
                            return HomeScreen(
                              camera: widget.camera,
                            );
                          } else {
                            return DoctorScreen(
                              camera: widget.camera,
                            );
                          }
                        },
                      ),
                    );
                  }
                }
              },
              child: const Text(
                "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
