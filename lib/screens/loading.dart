import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:on_ways/authentication/login.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:on_ways/screens/scaffold_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_ways/authentication/register.dart';
import 'package:on_ways/Providers/authenticaation.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  void isUser(BuildContext context) async {
    print(user);
    if (user == null) {
      print(1);
      Navigator.pushReplacementNamed(context, LoginPage.routename);
    } else {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      await provider.googleLogout();
      Navigator.pushReplacementNamed(context, LoginPage.routename);
      // final _firestore = FirebaseFirestore.instance;
      // final user_credentials =
      //     _firestore.collection("User-Data").doc('${user!.uid}');
      // debugPrint(user!.email);

      // user_credentials.get().then((docSnapshot) => {
      //       if (docSnapshot.exists)
      //         {
      //           Navigator.pushReplacementNamed(context, HomeScreen.routename)}
      //       else
      //         {Navigator.pushReplacementNamed(context, SignUpPage.routename)}
      //     });
    }
  }

  @override
  Widget build(BuildContext context) {
    // isUser(context);
    Future.delayed(Duration.zero, () async {
      isUser(context);
    });
    return Container(
      color: Colors.white,
      child: LoadingAnimationWidget.flickr(
          leftDotColor: const Color(0xFFd988a1).withOpacity(0.8),
          rightDotColor: const Color(0xFF50559a).withOpacity(0.8),
          size: 100),
    );
  }
}
