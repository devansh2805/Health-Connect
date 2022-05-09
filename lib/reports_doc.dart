import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connect/const.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class ReportDocScreen extends StatefulWidget {
  const ReportDocScreen({Key? key, required this.patUid}) : super(key: key);
  final String patUid;
  @override
  State<ReportDocScreen> createState() => ReportDocScreenState();
}

class ReportDocScreenState extends State<ReportDocScreen> {
  List urls = [];
  List names = [];
  void fetchData() async {
    String uid = widget.patUid;
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
        backgroundColor: Constants.darkAccent,
        foregroundColor: Colors.white,
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
    );
  }
}
