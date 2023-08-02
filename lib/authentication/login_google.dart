import 'package:flutter/material.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/authentication/register.dart';
import 'package:on_ways/screens/scaffold_screen.dart';
import 'package:on_ways/utilities/custom_button.dart';
import 'package:on_ways/Providers/authenticaation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              action: () async {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                await provider.googleLogin();
                final user = FirebaseAuth.instance.currentUser;
                final _firestore = FirebaseFirestore.instance;
                final user_credentials =
                    _firestore.collection("User-Data").doc('${user!.uid}');
                debugPrint(user.email);

                Provider.of<Users>(context, listen: false).updateDetails();

                user_credentials.get().then((docSnapshot) => {
                      if (docSnapshot.exists)
                        {
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.routename)
                        }
                      else
                        {
                          Navigator.pushReplacementNamed(
                              context, SignUpPage.routename)
                        }
                    });
              },
            ),
          )),
    ));
  }
}
