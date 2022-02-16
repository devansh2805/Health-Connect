import 'package:flutter/material.dart';
// import 'package:mediapp/screens/detail_screen.dart';
import 'package:health_connect/const.dart';

class ProgressVertical extends StatelessWidget {
  final int value;
  final String date;
  final bool isShowDate;

  const ProgressVertical(
      {Key? key,
      required this.value,
      required this.date,
      required this.isShowDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 7),
        width: 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                width: 10,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  shape: BoxShape.rectangle,
                  color: Colors.lightGreen,
                ),
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                              shape: BoxShape.rectangle,
                              color: Constants.darkGreen),
                          height: constraints.maxHeight * (value / 100),
                          width: constraints.maxWidth,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            Text((isShowDate) ? date : ""),
          ],
        ));
  }
}
