import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertUtil {
  static showNotYetImplementedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            margin: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Lottie.asset('assets/lottie/robot_anim.json'),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Material(child: Text("We're working on it"),
                      textStyle: TextStyle(color: Colors.amber, fontSize: 40)),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.green, primary: Colors.green
                    ),
                    child: const Text("Close", style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
          );
        }
    );
  }

  static showArbitraryDialog(BuildContext context, String text) {

    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Notification"),
      content: Container(
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}