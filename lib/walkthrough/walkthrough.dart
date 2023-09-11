import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/Providers/authenticaation.dart';
import 'package:on_ways/authentication/login_PhoneNumber.dart';
import 'package:on_ways/authentication/login_google.dart';
import 'package:on_ways/screens/scaffold_screen.dart';
import 'package:provider/provider.dart';

class WalkThroughScreen extends StatelessWidget {
  WalkThroughScreen({super.key});

  static const routename = '/walkthrough';
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Register',
      onFinish: () async {
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
                {Navigator.pushReplacementNamed(context, HomeScreen.routename)}
              else
                {
                  Navigator.pushReplacementNamed(
                      context, PhoneAuthForm.routename)
                }
            });
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Color(0xFF1d2d59),
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF1d2d59),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF1d2d59),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.pushReplacementNamed(context, LoginPage.routename);
      },
      controllerColor: Color(0xFF1d2d59),
      totalPage: 4,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        Image.asset(
          'Assets/slide_1.jpg',
          height: 400,
        ),
        Image.asset(
          'Assets/slide_4.jpg',
          height: 400,
        ),
        Image.asset(
          'Assets/slide_3.png',
          height: 400,
        ),
        Image.asset(
          'Assets/slide_2.jpg',
          height: 400,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 390,
              ),
              Text(
                'Connect with People Around You',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1d2d59),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: const Text(
                  'Send friend requests to nearby users and expand your social circle. Discover new friendships right in your vicinity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 390,
              ),
              Text(
                'Instant Chatting at Your Fingertips',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1d2d59),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: const Text(
                  'Start conversations with your accepted friends. Enjoy real-time  messaging with an intuitive interface for smooth communication',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 390,
              ),
              Text(
                'Stay Updated with Feeds',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1d2d59),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: const Text(
                  'Explore a dynamic feeds screen that keeps you informed about your friends\' activities and posts. Engage, react, and comment to stay connected.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Start now!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1d2d59),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: const Text(
                  'If you are a New User create your account,else Login Directly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
