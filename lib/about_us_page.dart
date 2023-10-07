import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_more_waste/style/constants.dart';

class AboutUsPage extends StatelessWidget {

  const AboutUsPage({Key? key}) : super(key: key);

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
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: Colors.black, // set color of back button
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40.0),
                  Text(
                      'About us',
                      maxLines: 1,
                      style: GoogleFonts.comicNeue(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 0.0, left: 20.0, right: 20.0),
                    alignment: Alignment.center,
                    child: const Text("Welcome to NoMoreWaste an app that can"
                        " save you money and help the community around you. "
                        "Our aim is to ensure that we can reduce as much food waste as possible. As eco conscious"
                        " individuals we have found we are missing ways to use up the food in our fridges and cupboards"
                        " that we don't know what to do with."
                        "\n"
                        "\n"
                        "This is why we thought users would love to be able to generate their own recipes"
                        " or be able to share their food with others or give it to a food bank.",
                        style: TextStyle(fontSize: 18.0)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    constraints: const BoxConstraints.expand(
                      height: 300.0,
                    ),
                    //decoration: BoxDecoration(color: Colors.white),
                    child: Image.asset(
                      "assets/images/logo_white.png",
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            )
        ),
    );
  }
}