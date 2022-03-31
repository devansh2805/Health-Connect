import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardiacModel {
  int age, gender, systolic, diastolic;
  int alcoholic, smoker, cholestrol, glucose;
  double height, weight;

  CardiacModel(
      {required this.age,
      required this.gender,
      required this.height,
      required this.weight,
      required this.systolic,
      required this.diastolic,
      required this.alcoholic,
      required this.smoker,
      required this.cholestrol,
      required this.glucose});

  Future<Cardiac> getCardiacResponse() async {
    final response = await http.get(
      Uri.parse(
        'https://healthconnectapi.herokuapp.com/?age=$age&gender=$gender&height=$height&weight=$weight&ap_hi=$systolic&ap_lo=$diastolic&cholesterol=$cholestrol&gluc=$glucose&smoke=$smoker&alco=$alcoholic',
      ),
    );
    if (response.statusCode == 200) {
      return Cardiac.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("API Call Failure");
    }
  }
}

class Cardiac {
  final String cardio;
  const Cardiac({required this.cardio});

  factory Cardiac.fromJson(Map<String, dynamic> json) {
    return Cardiac(cardio: json['cardio']);
  }
}
