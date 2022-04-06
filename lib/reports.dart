import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  String uid = "";
  List urls = [];
  List names = [];
  void fetchData() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('reports')
        .get()
        .then(
      (value) {
        for (var element in value.docs) {
          urls.add(element.data()['link']);
          names.add(element.data()['name']);
        }
      },
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: urls.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: SafeArea(
                child: InkWell(
                  onTap: () async {
                    if (await canLaunch(urls[index])) {
                      await launch(urls[index]);
                    } else {
                      print("Something went wrong");
                    }
                  },
                  child: Thumbnail(
                    dataResolver: () async {
                      HttpClientRequest request =
                          await HttpClient().getUrl(Uri.parse(urls[index]));
                      HttpClientResponse response = await request.close();
                      return consolidateHttpClientResponseBytes(response);
                    },
                    name: names[index],
                    mimeType: 'application/pdf',
                    widgetSize: 300,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.file_upload_outlined),
        label: const Text(
          "Upload Report",
        ),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          if (result != null) {
            String? path = result.files.single.path;
            if (path != null) {
              File file = File(path);
              final Reference firebaseStorageRef = FirebaseStorage.instance
                  .ref()
                  .child('reports/$uid/${result.files.single.name}');
              final TaskSnapshot taskSnapshot =
                  await firebaseStorageRef.putFile(file);
              String url = await taskSnapshot.ref.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('reports')
                  .add({"link": url, "name": result.files.single.name});
              setState(() {});
            }
          }
        },
      ),
    );
  }
}
