import 'package:flutter/material.dart';
import 'package:on_ways/Networking/image.dart';
import 'package:on_ways/Networking/location.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/authentication/login_PhoneNumber.dart';
import 'package:on_ways/authentication/otp.dart';
import 'package:on_ways/authentication/register.dart';
import 'package:on_ways/screens/blogscreen.dart';
import 'package:on_ways/screens/chatscreen.dart';
import 'package:on_ways/screens/editProfile_screen.dart';
import 'package:on_ways/screens/scaffold_screen.dart';
import 'package:on_ways/walkthrough/splash_screen.dart';
import 'package:on_ways/walkthrough/walkthrough.dart';
import 'authentication/login_google.dart';
import 'screens/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Providers/authenticaation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: ((context) => GoogleSignInProvider())),
            ChangeNotifierProvider(create: ((context) => Users())),
            ChangeNotifierProvider(
                create: ((create) => Location()), lazy: false),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              // dialogBackgroundColor: const Color.fromRGBO(37, 42, 52, 1),
              scaffoldBackgroundColor: Color.fromARGB(255, 247, 248, 255),
              primaryColor: Color.fromARGB(255, 223, 206, 152),
              appBarTheme: const AppBarTheme(
                color: Color.fromRGBO(255, 255, 255, 1),
                shadowColor: Colors.black87, // Change the AppBar color
                elevation: 8,
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Color.fromARGB(
                    255, 242, 209, 213), // Set the desired cursor color
              ),
              inputDecorationTheme: const InputDecorationTheme(
                // labelStyle: TextStyle(
                //   color: Color.fromARGB(
                //       255, 114, 122, 226), // Set the desired label color
                // ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 29, 45, 89),
                  ), // Set the desired underline color for active text fields
                ),
              ),
              dialogTheme: DialogTheme(
                backgroundColor: Color.fromARGB(
                    255, 255, 255, 255), //Color.fromARGB(255, 114, 122, 226),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Set the desired border radius here
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedIconTheme: IconThemeData(
                  color: Color(0xFF1d2d59),
                ),
                selectedItemColor: Color(0xFF1d2d59),
                backgroundColor: Color.fromRGBO(236, 234, 214, 1),
                elevation: 20,
              ),
              cardTheme: CardTheme(
                color: Color.fromARGB(255, 253, 253, 253),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              textTheme:
                  GoogleFonts.interTextTheme(ThemeData.light().textTheme),
              iconTheme: const IconThemeData(
                color: Color(0xFF1d2d59),
              ),
            ),
            routes: {
              '/': (context) => MyCustomSplashScreen(),
              LoadingScreen.routename: (context) => LoadingScreen(),
              LoginPage.routename: (context) => const LoginPage(),
              SignUpPage.routename: (context) => SignUpPage(),
              HomeScreen.routename: (context) => const HomeScreen(),
              ImageUploadScreen.routename: (context) => ImageUploadScreen(),
              BlogScreen.routeName: (context) => BlogScreen(),
              PhoneAuthForm.routename: (context) => PhoneAuthForm(),
              MyVerify.routename: (context) => MyVerify(),
              ChatScreen.id: (context) => ChatScreen(),
              WalkThroughScreen.routename: (context) => WalkThroughScreen(),
            },
          ));
}
