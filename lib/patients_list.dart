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
  final TextEditingController _searchController = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  List searchresult = [];
  bool _isSearching = false;
  List<dynamic> _list = [];
  String _searchText = "";
  String userName = " ";
  List<dynamic> _list2 = [];
  List _list12 = [];

  @override
  void initState() {
    super.initState();
    values();

    firestoreInstance
        .collection('users')
        .orderBy('doctors')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        _list12 = element.data()["doctors"];
        print(_list12);
        if (_list12.contains(userName)) {
          _list2.add(element.data()["uid"]);
        }
      });
    });
    print(_list2);
    _list2.forEach((element) {
      firestoreInstance.collection('users').doc(element).get().then((value) {
        setState(() {
          _list.add(value.data()!['name']);
        });
      });
    });
    _isSearching = false;
  }

  void values() async {
    await firestoreInstance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        userName = value.data()!['name'];
      });
    });
  }

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
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = _list[index];

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
