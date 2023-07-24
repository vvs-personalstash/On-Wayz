import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:on_ways/authentication/login.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:on_ways/screens/scaffold_screen.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  void isUser(BuildContext context) async {
    print(user);
    if (user == null) {
      print(1);
      Navigator.pushReplacementNamed(context, LoginPage.routename);
    } else {
      Navigator.pushReplacementNamed(context, HomeScreen.routename);
    }
  }

  @override
  Widget build(BuildContext context) {
    // isUser(context);
    Future.delayed(Duration.zero, () async {
      isUser(context);
    });
    return Container(
      child: LoadingAnimationWidget.flickr(
          leftDotColor: const Color(0xFFd988a1).withOpacity(0.8),
          rightDotColor: const Color(0xFF50559a).withOpacity(0.8),
          size: 100),
    );
  }
}
