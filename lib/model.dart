import 'package:tflite_flutter/tflite_flutter.dart';

class CardiacModel {
  late Interpreter _interpreter;

  _loadModel() async {
    _interpreter = await Interpreter.fromAsset("model.tflite");
  }

  classify() async {
    await _loadModel();
    print(_interpreter.getInputTensors().shape);
    var x = _interpreter.getInputTensor(0);
    print(x.data);
    //print(_interpreter.getOutputTensors().shape);
    classifyPatient(
        50.toDouble(),
        168.toDouble(),
        62.toDouble(),
        2196.toDouble(),
        120.toDouble(),
        80.toDouble(),
        double.parse('1'),
        double.parse('2'),
        double.parse('3'),
        double.parse('0'),
        double.parse('1'));
  }

  classifyPatient(
      double age,
      double height,
      double weight,
      double bmi,
      double sys,
      double dia,
      double gender,
      double glucose,
      double cholesterol,
      double smoker,
      double alcoholic) async {
    //await _loadModel();

    var input = [
      [
        age,
        height,
        weight,
        sys,
        dia,
        bmi,
        gender,
        cholesterol,
        glucose,
        smoker,
        alcoholic
      ]
    ];

    var output = List.filled(1, 0).reshape([1, 1]);
    _interpreter.run(input, output);
    print(output);
  }
}
