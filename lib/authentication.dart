import 'package:health_connect/database.dart';
import 'package:health_connect/details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_connect/patient_screen.dart';
import 'package:camera/camera.dart';

class Auth {
  final CameraDescription camera;

  Auth({required this.camera});

  Future<void> loginUser(String phoneNumber, BuildContext context) async {
    final TextEditingController _codeController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(
        seconds: 60,
      ),
      verificationCompleted: (AuthCredential credential) async {
        /*
        Navigator.of(context).pop();
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        User? user = userCredential.user;
        if (user != null) {
          if (await Database().userAlreadyRegistered(user.phoneNumber)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NamePage();
                },
              ),
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Authentication Error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } */
      },
      verificationFailed: (FirebaseAuthException authException) {
        _showAlertDialog(context, authException.code);
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Enter Code"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    final code = _codeController.text.trim();
                    AuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: code,
                    );
                    UserCredential userCredential =
                        await _auth.signInWithCredential(credential);

                    User? user = userCredential.user;
                    if (user != null) {
                      if (await Database()
                          .userAlreadyRegistered(user.phoneNumber)) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomeScreen(
                                camera: camera,
                              );
                            },
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NamePage(camera: camera);
                            },
                          ),
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Authentication Error",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: const Text(
                    "Confirm",
                  ),
                )
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _showAlertDialog(context, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.sourceSansPro(),
          ),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }
}
