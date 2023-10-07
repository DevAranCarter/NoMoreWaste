import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_more_waste/components/navigation_main_page.dart';
import 'package:no_more_waste/dto/pantry_page_state.dart';
import 'package:no_more_waste/foodbanks_page.dart';
import 'package:no_more_waste/home_page.dart';
import 'package:no_more_waste/login_page.dart';
import 'package:no_more_waste/pantry_page.dart';
import 'package:no_more_waste/product_add_page.dart';
import 'package:no_more_waste/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(const NoWasteApp());
}

class NoWasteApp extends StatefulWidget {
  const NoWasteApp({Key? key}) : super(key: key);

  @override
  State<NoWasteApp> createState() => _NoWasteAppState();
}

class _NoWasteAppState extends State<NoWasteApp> {

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoWaste App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<User?>(
          future: Future.value(_auth.currentUser),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {

            if (snapshot == null) {
              return const LoginPage();
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data == null) {
                    return const LoginPage();
                  } else {
                    return const NavigationMainPage();
                  }
                }
            }

          }
      ),
      routes: {
        '/login' : (context) => const LoginPage(),
        '/register' : (context) => const RegisterPage(),
        '/home' : (context) => const HomePage(),
        '/pantry' : (context) => const PantryScreen(pantryPageState: PantryPageState.view),
        '/scanitem' : (context) => const ProductAddPage(),
        '/foodbanks' : (context) => const FoodbanksPage(),
      },
    );
  }

}
