import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_more_waste/about_us_page.dart';
import 'package:no_more_waste/dto/pantry_page_state.dart';
import 'package:no_more_waste/foodbanks_page.dart';
import 'package:no_more_waste/login_page.dart';
import 'package:no_more_waste/marketplace_page.dart';
import 'package:no_more_waste/pantry_page.dart';
import 'package:no_more_waste/product_add_page.dart';
import 'package:no_more_waste/recipes_screen.dart';
import 'package:no_more_waste/settings_page.dart';
import 'package:no_more_waste/style/constants.dart';
import 'package:no_more_waste/util/alert_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  ElevatedButton getButton(String text, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0))),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0.0)),
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(20, 15, 38, .64)),
      ),
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0)
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.comicNeue(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: Constants.BACKGROUND_GRADIENT_COLORS)
    ),
    child: Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // make this transparent
        elevation: 0.0,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.menu),
          onPressed: () {
              _key.currentState!.openDrawer();
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/drawer_header_background.png')
                  )
              ),
              child: Stack(
                  children: const <Widget>[
                    Positioned(
                        bottom: 12.0,
                        left: 16.0,
                        child: Text("NoMoreWaste",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500)
                        )
                    ),
                ]
              )
          ),
          ListTile(
            leading: Stack(
              children: <Widget>[
                const Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            title: const Text('Your Pantry'),
            onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PantryScreen(pantryPageState: PantryPageState.view)),
                );
              },
          ),
          ListTile(
            leading: const Icon(Icons.food_bank),
            title: const Text('Food Banks'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FoodbanksPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text('Generate Recipe'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipesPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_alert),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
              AlertUtil.showNotYetImplementedDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Places'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              AlertUtil.showNotYetImplementedDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              _auth.signOut();
              // The rootNavigator:true will get the highest root widget Scaffold or MaterialApp and avoid displaying the BottomNavigationBar
              Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 0, right: 50, bottom: 10, left: 50),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
                'Welcome to',
                maxLines: 1,
                style: GoogleFonts.comicNeue(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center
            ),
            Text(
                'NoMoreWaste!',
                maxLines: 1,
                style: GoogleFonts.comicNeue(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center
            ),
            const SizedBox(height: 30),
            Text(
                "You're joining a like-minded community of people looking to save on food wastage!",
                maxLines: 3,
                style: GoogleFonts.comicNeue(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    "About us",
                    maxLines: 3,
                    style: GoogleFonts.comicNeue(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center
                ),
              ),
            ),
            const SizedBox(height: 20),
            getButton("SCAN ITEM", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductAddPage()),
              );
            }),
            const SizedBox(height: 20),
            getButton("VIEW YOUR ITEMS", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantryScreen(pantryPageState: PantryPageState.view)),
              );
            }),
            const SizedBox(height: 20),
            getButton("DISCOVER", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarketplacePage()),
              );
            }),
          ],
        ),
      ),
    ));
  }
}