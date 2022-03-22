import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connect/const.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String uid = "";
  String profilePicUrl = "";

  fetchData() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    profilePicUrl = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => value.data()!['imageUrl']);

    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.darkAccent,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
              const SizedBox(
                height: 15,
              ),
              CircleAvatar(
                backgroundImage: profilePicUrl == ""
                    ? const AssetImage("assets/icons/profile_picture.png")
                        as ImageProvider
                    : NetworkImage(profilePicUrl),
                radius: width * 0.2,
              ),
              Positioned(
                child: MaterialButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) =>
                          bottomSheet(context, profilePicUrl)),
                    );
                  },
                  color: Colors.indigo[400],
                  textColor: Colors.white,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 24,
                  ),
                  shape: const CircleBorder(),
                ),
                top: width * 0.25,
                left: width * 0.25,
              ),
              const SizedBox(
                height: 35,
              ),
              // buildTextField("Full Name", "Tanmay Patel", false),
              // buildTextField("E-mail", "tp@gmail.com", false),
              // buildTextField("Password", "*********", true),
              // buildTextField("Location", "Visnagar, India", false),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {},
                    child: const Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black54)),
                  ),
                  RaisedButton(
                      onPressed: () {},
                      color: Constants.darkAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 2,
                      child: const Text("SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(BuildContext context, String imageUrl) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: imageUrl == null
                  ? null
                  : () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({"imageUrl": ""});
                      ;
                      setState(() {
                        profilePicUrl = "";
                      });
                      Navigator.pop(context);
                    },
              child: Text(
                "Remove profile picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: imageUrl == "" || imageUrl == null
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: () async {
                await uploadImage();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.camera,
                color: Colors.black,
              ),
              label: const Text(
                "Choose Image",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    XFile photo;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      try {
        photo = (await _picker.pickImage(source: ImageSource.gallery))!;
        var file = File(photo.path);

        if (photo != null) {
          final Reference firebaseStorageRef =
              _storage.ref().child("users/$uid");
          final TaskSnapshot taskSnapshot =
              await firebaseStorageRef.putFile(file);
          String url = await taskSnapshot.ref.getDownloadURL();
          // await Database().updateProfilePic(uid, url);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({"imageUrl": url});
          setState(() {
            profilePicUrl = url;
          });
        }
      } catch (e) {
        print("/n/n/n Error:" + e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong"),
          ),
        );
      }
    } else {
      print("Permission was not granted");
    }
  }
  // Widget buildTextField(
  //     String labelText, String placeholder, bool isPasswordTextField) {
  //   return Padding(
  //       padding: const EdgeInsets.only(bottom: 35.0),
  //       child: TextField(
  //         // obscureText: isPasswordTextField ? showPassword : false,
  //         decoration: InputDecoration(
  //           suffixIcon: isPasswordTextField
  //               ? IconButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       // showPassword = !showPassword;
  //                     });
  //                   },
  //                   icon: const Icon(
  //                     Icons.remove_red_eye,
  //                     color: Colors.grey,
  //                   ))
  //               : null,
  //           contentPadding: const EdgeInsets.only(bottom: 3),
  //           labelText: labelText,
  //           floatingLabelBehavior: FloatingLabelBehavior.always,
  //           hintText: placeholder,
  //           hintStyle: const TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black26,
  //           ),
  //         ),
  //       ));
  // }
}
