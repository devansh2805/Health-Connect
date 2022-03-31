import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);
  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  @override
  final TextEditingController _searchController = new TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  bool _isSearching = false;
  List<dynamic> _list = [];
  List<dynamic> _list2 = [];
  String _searchText = "";
  List searchresult = [];

  _AddDoctorScreenState() {
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
  void initState() {
    super.initState();
    values();
    _isSearching = false;
    // getAllValues();
  }

  void values() {
    _list = [];
    firestoreInstance
        .collection('users')
        .where('userType', isEqualTo: 1)
        .get()
        .then((value) {
      value.docs.asMap().forEach((key, values) {
        setState(() {
          _list.add(values.data()["name"]);
        });
      });
    });
    firestoreInstance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _list2 = value.data()!['doctors'];
      });
    });
  }

  void search(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }

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
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15.0),
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
                child: searchresult.isNotEmpty ||
                        _searchController.text.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = searchresult[index];
                          List<String> name =
                              (listData.toString().toLowerCase()).split(" ");
                          String imgname = name[0];
                          bool vis = true;
                          if (_list2.contains(listData.toString())) {
                            vis = false;
                          } else {
                            vis = true;
                          }
                          return Container(
                            child: Row(
                              children: [
                                Text(listData.toString()),
                                Spacer(),
                                Visibility(
                                    visible: vis,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            vis = !vis;
                                          });
                                        },
                                        child: Text("Add")))
                              ],
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _list.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = _list[index];
                          List<String> name =
                              (listData.toString().toLowerCase()).split(" ");
                          String imgname = name[0];
                          bool vis = true;
                          if (_list2.contains(listData.toString())) {
                            vis = false;
                          } else {
                            vis = true;
                          }
                          return Container(
                            child: Row(
                              children: [
                                Text(listData.toString()),
                                Spacer(),
                                Visibility(
                                    visible: vis,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _list2.add(listData.toString());
                                            firestoreInstance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({'doctors': _list2});
                                          });
                                        },
                                        child: Text("Add")))
                              ],
                            ),
                          );
                        },
                      )),
          ],
        ));
  }
}
