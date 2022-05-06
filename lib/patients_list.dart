import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({Key? key}) : super(key: key);
  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  @override
  final TextEditingController _searchController = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  List searchresult = [];
  bool _isSearching = false;
  List<dynamic> list = [];
  String _searchText = "";
  String userName = " ";
  List<dynamic> list2 = [];
  List list12 = [];

  _PatientsListScreenState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchController.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    values();
    _isSearching = false;
  }

  void values() {
    firestoreInstance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        userName = value.data()!['name'];
      });
    });
    firestoreInstance
        .collection('users')
        .where('userType', isEqualTo: 2)
        .get()
        .then((value) {
      value.docs.asMap().forEach((key, values) {
        list12 = values.data()["doctors"];
        print(list12);
        if (list12.contains(userName)) {
          list2.add(values.data()["uid"]);
        }
      });
      print(list2);
    });
    list2.forEach((element) {
      firestoreInstance
          .collection('users')
          .doc(element.toString())
          .get()
          .then((value) {
        setState(() {
          list.add(value.data()!["name"]);
        });
      });
    });
  }

  void search(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < list.length; i++) {
        String data = list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }

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
        title: const Text('View Patients'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
              controller: _searchController,
              onChanged: search,
            ),
          ),
          Flexible(
              child:
                  searchresult.isNotEmpty || _searchController.text.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchresult.length,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = searchresult[index];
                            return Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Row(
                                children: [
                                  Text(listData.toString()),
                                ],
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = list[index];

                            return Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Row(
                                children: [
                                  Text(listData.toString()),
                                ],
                              ),
                            );
                          },
                        ))
        ],
      ),
    );
  }
}
