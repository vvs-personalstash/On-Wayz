import 'package:flutter/material.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:provider/provider.dart';

class ProfileStackDesign extends StatelessWidget {
  const ProfileStackDesign({super.key});

  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context, listen: false);
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          height: screenHeight * 0.26,
        ),
        Container(
          height: screenHeight * 0.2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1d2d59),
                  Colors.pink.shade200,
                  Colors.white,
                  //50559a
                ]),
            borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width, 250.0)),
          ),
        ),
        Positioned(
          top: screenHeight * 0.11,
          left: screenHeight * 0.168,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.white),
              color: Color.fromARGB(255, 201, 200, 200),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 8)
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.image),
              backgroundColor: Color(0xFFfafafa),
              radius: 60,
            ),
          ),
        ),
        // Positioned(
        //   top: screenHeight * 0.115,
        //   left: screenHeight * 0.170,
        //   child: Center(
        //     child: CircleAvatar(
        //       backgroundImage: NetworkImage(user.image),
        //       radius: 55,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
