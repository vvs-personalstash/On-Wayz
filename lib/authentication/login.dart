import 'package:flutter/material.dart';
import 'package:on_ways/utilities/custom_button.dart';

class LoginPage extends StatelessWidget {
  static const routename = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("Assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: CustomButton(
                dimensions: dimensions,
                label: 'Login with Google',
                action: () {}),
          )),
    ));
  }
}
