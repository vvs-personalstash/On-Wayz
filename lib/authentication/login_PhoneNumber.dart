import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:on_ways/authentication/otp.dart';
import 'package:on_ways/authentication/register.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

class PhoneAuthForm extends StatefulWidget {
  static const routename = '/phone';
  static String verify = "";

  @override
  State<PhoneAuthForm> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<PhoneAuthForm> {
  TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isclicked = false;

  @override
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    String countrycode = '+91';

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 175,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: IntlPhoneField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        initialCountryCode: 'IN',
                        onCountryChanged: (value) {
                          countrycode = value.toString();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          if (credential.smsCode != null) {
                            try {
                              UserCredential credential1 =
                                  await user!.linkWithCredential(credential);
                            } on FirebaseAuthException catch (e) {
                              print(e);
                            }
                          }
                        },
                        verificationFailed: _onVerificationFailed,
                        codeSent: (String verificationId, int? ResendingToken) {
                          PhoneAuthForm.verify = verificationId;
                          Navigator.pushNamed(context, MyVerify.routename);
                        },
                        phoneNumber: '$countrycode${phoneController.text}',
                        codeAutoRetrievalTimeout: (String verificationId) {
                          return null;
                        });
                  },
                  child: isclicked == false
                      ? Text("Send the code")
                      : Container(
                          child: CircularProgressIndicator(color: Colors.white),
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        });
  }
}
