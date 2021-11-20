import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  String countryCode = "";
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IntlPhoneField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'IN',
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (phone) {
                setState(() {
                  countryCode = phone.countryCode!;
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () async {
                final phoneNumber = countryCode + _phoneController.text.trim();
                setState(() => clicked = true);
                await Auth().loginUser(phoneNumber, context);
              },
              child: Text(
                'Login',
                style: GoogleFonts.sourceSansPro(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xff00C6BD),
                ),
              ),
            ),
            const SizedBox(height: 10),
            clicked
                ? Column(
                    children: const [
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xff00C6BD),
                          ),
                        ),
                      ),
                      Text(
                        "Please wait...",
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
