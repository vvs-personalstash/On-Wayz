import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_ways/authentication/login.dart';
import 'package:on_ways/tabs/Chats.dart';
import 'package:on_ways/tabs/Maps.dart';
import 'package:on_ways/tabs/UserProfile.dart';
import 'package:on_ways/tabs/communitytab.dart';
import 'package:provider/provider.dart';
import 'package:on_ways/authentication/authenticaation.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routename = '/homepage';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              await provider.googleLogin();
              Navigator.popAndPushNamed(context, LoginPage.routename);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            'On Wayz',
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 8),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              elevation: 100,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color(0xFF243154),
              currentIndex: selectedIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.globe),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_2_square_stack),
                  label: '  Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: const [
            MapScreen(),
            CommunityTab(),
            ChatScreen(),
            UserProfile(),
          ],
        ),
      ),
    );
  }
}
