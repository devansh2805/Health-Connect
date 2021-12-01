import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:health_connect/screens/detail_screen.dart';
import 'package:health_connect/const.dart';
import 'package:health_connect/widgets/custom_clipper.dart';

class CardMain extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String value;
  final String unit;
  final Color color;

  const CardMain(
      {Key? key,
      required this.image,
      required this.title,
      required this.value,
      required this.unit,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        width: ((MediaQuery.of(context).size.width -
                (Constants.paddingSide * 2 + Constants.paddingSide / 2)) /
            2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
        ),
        child: Material(
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              // overflow: Overflow.clip,
              children: <Widget>[
                Positioned(
                  child: ClipPath(
                    clipper: MyCustomClipper(clipType: ClipType.semiCircle),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Color.fromRGBO(0, 0, 0, 0.03),
                      ),
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Icon and Hearbeat
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image(width: 32, height: 32, image: image),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 13, color: Constants.textDark),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Constants.textDark,
                        ),
                      ),
                      Text(
                        unit,
                        style: const TextStyle(
                            fontSize: 15, color: Constants.textDark),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () {},
                          child: const Text("Read"),
                          style: ElevatedButton.styleFrom(
                            primary: Constants.lightAccent,
                            onPrimary: Colors.white,
                          )),
                    ],
                  ),
                )
              ],
            ),
            onTap: () {
              // debugPrint("CARD main clicked. redirect to details page");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => DetailScreen()),
              // );
            },
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
