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
    classifyPatient(50, 168, 62, 2196, 120, 80, '1', '2', '3', '0', '1');
  }

  classifyPatient(
      int age,
      int height,
      int weight,
      int bmi,
      int sys,
      int dia,
      String gender,
      String glucose,
      String cholesterol,
      String smoker,
      String alcoholic) async {
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
