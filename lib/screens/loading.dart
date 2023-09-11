import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:on_ways/Networking/location.dart';
import 'package:on_ways/authentication/login_google.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:on_ways/screens/scaffold_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_ways/authentication/register.dart';
import 'package:on_ways/Providers/authenticaation.dart';
import 'package:on_ways/walkthrough/walkthrough.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({super.key});
  static const routename = '/loading';
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () async {
      isUser();
    });
    // TODO: implement initState
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;

  void isUser() async {
    print(user);
    if (user == null) {
      print(1);
      Navigator.pushReplacementNamed(context, WalkThroughScreen.routename);
    } else {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      await provider.googleLogout();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, LoginPage.routename);
      });

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
    var dimensions = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: dimensions.height,
        width: dimensions.width,
        color: Colors.white,
        child: LoadingAnimationWidget.flickr(
            leftDotColor: const Color(0xFFd988a1).withOpacity(0.8),
            rightDotColor: Color(0xFF1d2d59),
            size: 100),
      ),
    );
  }
}
