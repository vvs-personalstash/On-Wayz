import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:on_ways/utilities/custom_textfield.dart';

class SignUpPage extends StatelessWidget {
  static const routename = '/signup';

  final TextEditingController nameController = TextEditingController();
  SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var dimensions = MediaQuery.of(context).size;
    debugPrint(user.email);
    return SafeArea(
        child: Scaffold(
            body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: dimensions.height * 0.3,
          ),
          Row(
            children: [
              CustomTextField(
                label: 'Full Name',
                iconData: Icons.person,
                textEditingController: nameController,
              ),
            ],
          )
        ],
      )),
    )));
  }
}
