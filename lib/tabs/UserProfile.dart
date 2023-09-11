import 'package:flutter/material.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/Providers/authenticaation.dart';
import 'package:on_ways/authentication/login_google.dart';
import 'package:on_ways/models/popupchoices.dart';
import 'package:on_ways/screens/editProfile_screen.dart';
import 'package:on_ways/screens/loading.dart';
import 'package:on_ways/utilities/profilestackdesign.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with AppCloser {
  final List<PopupChoices> choices = <PopupChoices>[
    PopupChoices(title: 'Log out', icon: Icons.exit_to_app),
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Users user = Provider.of<Users>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.vertical(
                bottom: new Radius.circular(15),
              ),
            ),
            elevation: 0,
            title: Text(
              '@${user.UserName}',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            actions: <Widget>[
              buildPopupMenu(context)
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(Icons.settings,
              //       size: 40, color: const Color.fromARGB(255, 255, 174, 201)),
              // )
            ]),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileStackDesign(),
              Container(
                  padding: EdgeInsets.only(right: 0, bottom: 5, left: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "${user.name}, ${user.age} years",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(right: 5, left: 25),
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Icon(Icons.email_outlined,
                        size: 14, color: Color(0xFF1d2d59)),
                    SizedBox(width: 2),
                    Text(
                      "${user.email}",
                      style: TextStyle(fontSize: 12, color: Color(0xFF1d2d59)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Color(0xFF1d2d59)),
                      Text(
                        "${user.PhoneNumber}",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 64, 111, 241)),
                      ),
                    ],
                  )),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(image: user.image)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void onItemMenuPress(PopupChoices choice) {
    if (choice.title == 'Log out') {}
  }

  Widget buildPopupMenu(context) {
    return PopupMenuButton<PopupChoices>(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.settings,
            size: 40, color: const Color.fromARGB(255, 255, 174, 201)),
      ),
      onSelected: (PopupChoices choice) async {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        await provider.googleLogout();
        closeApp();
      },
      itemBuilder: (BuildContext context) {
        return choices.map((PopupChoices choice) {
          return PopupMenuItem<PopupChoices>(
              value: choice,
              child: Row(
                children: <Widget>[
                  Icon(
                    choice.icon,
                    color: Color(0xFF1d2d59),
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    choice.title,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ));
        }).toList();
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.iconColor,
  });
  final String title, subtitle;
  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: ListTile(
        leading: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              iconData,
              size: 30,
              color: iconColor.withOpacity(0.6),
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

mixin AppCloser {
  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
// const SizedBox(
//                     height: 20,
//                   ),
//                   CustomListTile(
//                     title: 'email',
//                     subtitle: user.email,
//                     iconData: Icons.mail_outline,
//                     iconColor: Colors.blue,
//                   ),
//                   CustomListTile(
//                       title: 'Name',
//                       subtitle: user.name,
//                       iconData: Icons.person,
//                       iconColor: Colors.amber),
//                   CustomListTile(
//                       title: 'UserName',
//                       subtitle: user.UserName,
//                       iconData: Icons.call,
//                       iconColor: Colors.purple),
//                   CustomListTile(
//                       title: 'Phone',
//                       subtitle: user.PhoneNumber,
//                       iconData: Icons.contact_phone_outlined,
//                       iconColor: Colors.pinkAccent),
// Container(
//                 margin: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           blurRadius: 5,
//                           spreadRadius: 2),
//                     ])),
                
//                       Container(
//                           width: size.width,
//                           height: size.height - 200,
//                           decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                   colors: [
//                                 Colors.black.withOpacity(0.25),
//                                 Colors.black.withOpacity(0),
//                               ],
//                                   end: Alignment.topCenter,
//                                   begin: Alignment.bottomCenter)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Text('${user.name}, ${user.age}',
//                                     style: Theme.of(context) //3
//                                         .textTheme
//                                         .titleMedium!
//                                         .copyWith(
//                                             fontSize: 24,
//                                             fontWeight: FontWeight.w700,
//                                             color: Colors.white)),
//                                 Row(
//                                   children: [
//                                     Text('@${user.UserName}',
//                                         style: Theme.of(context) //3
//                                             .textTheme
//                                             .titleMedium!
//                                             .copyWith(
//                                                 fontSize: 18,
//                                                 fontStyle: FontStyle.italic,
//                                                 fontWeight: FontWeight.w400,
//                                                 color: const Color.fromARGB(
//                                                     255, 112, 111, 111)))
//                                   ],
//                                 ),
//                                 CustomListTile(
//                                   title: 'email',
//                                   subtitle: user.email,
//                                   iconData: Icons.mail_outline,
//                                   iconColor: Colors.blue,
//                                 ),
//                                 CustomListTile(
//                                     title: 'UserName',
//                                     subtitle: user.UserName,
//                                     iconData: Icons.call,
//                                     iconColor: Colors.purple),
//                                 CustomListTile(
//                                     title: 'Phone',
//                                     subtitle: user.PhoneNumber,
//                                     iconData: Icons.contact_phone_outlined,
//                                     iconColor: Colors.pinkAccent),
//                               ],
//                             ),
//                           )),
              
                  
              
//             ElevatedButton(
//               onPressed: () {},
//               child: Text('Update Profile', style: TextStyle(fontSize: 12)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF1d2d59), // background (button) color
//                 foregroundColor: Colors.white, // foreground (text) color
//               ),
            