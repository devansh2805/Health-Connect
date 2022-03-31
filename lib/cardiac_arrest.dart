import 'package:flutter/material.dart';
import 'package:health_connect/const.dart';
import 'package:health_connect/model.dart';

class CardiacScreen extends StatefulWidget {
  const CardiacScreen({Key? key}) : super(key: key);
  @override
  State<CardiacScreen> createState() => _CardiacScreenState();
}

class _CardiacScreenState extends State<CardiacScreen> {
  bool value1 = false;
  bool value2 = false;
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController cholesterolController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();

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
        title: const Text('Enter Data'),
      ),
      body: Form(
          child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: ageController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                    hintText: 'Enter Your Age',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: heightController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Height',
                    hintText: 'Enter Height',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: weightController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Weight',
                    hintText: 'Enter Weight',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: cholesterolController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cholesterol',
                    hintText: 'Enter Cholesterol',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: glucoseController,
                  style: const TextStyle(
                    color: Constants.darkYellow,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Glucose',
                    hintText: 'Enter Glucose',
                  ),
                ),
              ),
              Row(children: <Widget>[
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Smoker',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 2.0,
                  child: Checkbox(
                    activeColor: Constants.lightYellow,
                    checkColor: Constants.darkYellow,
                    value: value1,
                    onChanged: (bool? value) {
                      setState(() {
                        value1 = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ]),
              Row(children: <Widget>[
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Alcoholic',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 2.0,
                  child: Checkbox(
                    activeColor: Constants.lightYellow,
                    checkColor: Constants.darkYellow,
                    value: value2,
                    onChanged: (bool? value) {
                      setState(() {
                        value2 = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ]),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  CardiacModel cardiacModel = CardiacModel(
                      age: 21,
                      gender: 1,
                      height: 168,
                      weight: 91,
                      systolic: 180,
                      diastolic: 140,
                      alcoholic: 1,
                      smoker: 1,
                      cholestrol: 3,
                      glucose: 2);
                  Cardiac cardiac = await cardiacModel.getCardiacResponse();
                  print("Caridac: " + cardiac.cardio);
                },
                child: const Text("Continue",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300)),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(15, 8, 15, 8)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.lightYellow),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Constants.darkYellow),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
