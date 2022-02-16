import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future<bool> userAlreadyRegistered(String? phoneNumber) async {
    QuerySnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    if (user.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
