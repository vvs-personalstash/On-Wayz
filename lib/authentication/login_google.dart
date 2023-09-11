import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/authentication/login_PhoneNumber.dart';
import 'package:on_ways/authentication/register.dart';
import 'package:on_ways/screens/scaffold_screen.dart';
import 'package:on_ways/utilities/custom_button.dart';
import 'package:on_ways/Providers/authenticaation.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static const routename = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController controller1;

  late AnimationController controller2;

  late Animation<double> animation1;

  late Animation<double> animation2;

  late Animation<double> animation3;

  late Animation<double> animation4;
  // late Image image1;
  @override
  void initState() {
    super.initState();
    // image1 = Image.asset("assets/background1.jpg");
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation3 = Tween<double>(begin: .41, end: .38).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Timer(Duration(milliseconds: 2500), () {
      controller1.forward();
    });

    controller2.forward();
  }

  // @override
  // void didChangeDependencies() {
  //   precacheImage(image1.image, context);
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1d2d59),
            // image: DecorationImage(
            //  image: image1.image,
            //   fit: BoxFit.fitHeight,
            // ),
          ),
          child: Stack(children: [
            Positioned(
              top: dimensions.height * (animation2.value + .58),
              left: dimensions.width * .21,
              child: CustomPaint(
                painter: MyPainter(50),
              ),
            ),
            Positioned(
              top: dimensions.height * .98,
              left: dimensions.width * .1,
              child: CustomPaint(
                painter: MyPainter(animation4.value - 30),
              ),
            ),
            Positioned(
              top: dimensions.height * .5,
              left: dimensions.width * (animation2.value + .8),
              child: CustomPaint(
                painter: MyPainter(30),
              ),
            ),
            Positioned(
              top: dimensions.height * animation3.value,
              left: dimensions.width * (animation1.value + .1),
              child: CustomPaint(
                painter: MyPainter(60),
              ),
            ),
            Positioned(
              top: dimensions.height * .1,
              left: dimensions.width * .8,
              child: CustomPaint(
                painter: MyPainter(animation4.value),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: SizedBox(
                    width: dimensions.width * 0.9,
                    height: dimensions.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: dimensions.width * .15,
                              bottom: dimensions.width * 0.1),
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.8)),
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                          image: "Assets/google.png",
                          dimensions: dimensions,
                          label: 'Login with Google',
                          action: () async {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            await provider.googleLogin();
                            final user = FirebaseAuth.instance.currentUser;
                            final _firestore = FirebaseFirestore.instance;
                            final user_credentials = _firestore
                                .collection("User-Data")
                                .doc('${user!.uid}');
                            Provider.of<Users>(context, listen: false)
                                .updateDetails();
                            user_credentials.get().then((docSnapshot) => {
                                  if (docSnapshot.exists)
                                    {
                                      Navigator.pushReplacementNamed(
                                          context, HomeScreen.routename)
                                    }
                                  else if (user.phoneNumber == null)
                                    {
                                      Navigator.pushReplacementNamed(
                                          context, PhoneAuthForm.routename)
                                    }
                                  else
                                    {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          SignUpPage.routename,
                                          (route) => false)
                                    }
                                });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: dimensions.width * 0.4,
                            ),
                            Text('Create a new account',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))
                          ],
                          crossAxisAlignment: CrossAxisAlignment.end,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                left: dimensions.width * .38,
                top: dimensions.height * 0.17,
                child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(child: Text('Your App Logo'))))
          ])),
    ));
  }
}

class MyPainter extends CustomPainter {
  final double radius;

  MyPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
              colors: [
            Colors.pink.shade100,
            Color(0xffC43990)
          ], //Color(0xffFD5E3D)
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
          .createShader(Rect.fromCircle(
        center: Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
