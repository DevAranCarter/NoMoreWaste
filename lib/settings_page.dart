import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_more_waste/password_change_page.dart';
import 'package:no_more_waste/style/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  ElevatedButton getButton(String text, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0))),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0.0)),
      ),
      child: Ink(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff374ABE), Color(0xff64B6FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent, // make this transparent
            elevation: 0.0,
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(50),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                getButton("Change password", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PasswordChangePage()),
                  );
                }),
              ],
            ),
          ),
        )
    );
  }
}
