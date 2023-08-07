import 'package:flutter/material.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image(
                    image: NetworkImage(user.image),
                    // height: 200,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    height: 50, // Height of the gradient area (last 50 pixels)
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors
                              .transparent, // Start with transparent color at the top
                          Colors
                              .white, // Gradually merge with white at the bottom
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomListTile(
                title: 'email',
                subtitle: user.email,
                iconData: Icons.mail_outline,
                iconColor: Colors.blue,
              ),
              CustomListTile(
                  title: 'Name',
                  subtitle: user.name,
                  iconData: Icons.person,
                  iconColor: Colors.amber),
              CustomListTile(
                  title: 'UserName',
                  subtitle: user.UserName,
                  iconData: Icons.call,
                  iconColor: Colors.purple),
              CustomListTile(
                  title: 'Phone',
                  subtitle: user.PhoneNumber,
                  iconData: Icons.contact_phone_outlined,
                  iconColor: Colors.pinkAccent),
              ElevatedButton(
                onPressed: () {},
                child: Text('Update Profile', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF1d2d59), // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
              ),
            ],
          ),
        ),
      ),
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
