import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardiacScreen extends StatefulWidget {
  const CardiacScreen({Key? key}) : super(key: key);
  @override
  State<CardiacScreen> createState() => _CardiacScreenState();
}

class _CardiacScreenState extends State<CardiacScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.darkAccent,
          foregroundColor: Colors.white,
          title: const Text('Add Symptoms'),
        ),
        body: Expanded(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Age"),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Enter your age'),
                    )
                  ],
                )
              ],
            ),
          ),
        )

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


//   Future<void> saveFunction() async {
//     int num = checkBoxListTileModel.length;
//     for (var i = 0; i < num; i++) {
//       if (checkBoxListTileModel[i].isCheck == true) {
//         symptomsList.add(checkBoxListTileModel[i].title);
//       }
//     }
//     await FirebaseFirestore.instance.collection('userSymptoms').add({
//       'uid': FirebaseAuth.instance.currentUser!.uid,
//       'symptoms': symptomsList,
//       'time': Timestamp.now()
//     });
//     Navigator.pop(context);
//   }
// }

// class CheckBoxListTileModel {
//   int symId;
//   String title;
//   bool isCheck;

//   CheckBoxListTileModel(
//       {required this.symId, required this.title, required this.isCheck});

//   static List<CheckBoxListTileModel> getSymps() {
//     return <CheckBoxListTileModel>[
//       CheckBoxListTileModel(symId: 1, title: "Fever", isCheck: false),
//       CheckBoxListTileModel(symId: 2, title: "Runny Nose", isCheck: false),
//       CheckBoxListTileModel(symId: 3, title: "Cough", isCheck: false),
//       CheckBoxListTileModel(symId: 4, title: "Bodyache", isCheck: false),
//       CheckBoxListTileModel(symId: 5, title: "Fatigue", isCheck: false),
//       CheckBoxListTileModel(symId: 6, title: "Headache", isCheck: false),
//       CheckBoxListTileModel(symId: 7, title: "Vomiting", isCheck: false),
//       CheckBoxListTileModel(symId: 8, title: "Rash", isCheck: false),
//       CheckBoxListTileModel(symId: 9, title: "Nausea", isCheck: false),
//       CheckBoxListTileModel(symId: 10, title: "Diarrhoea", isCheck: false),
//     ];
//   }
// }