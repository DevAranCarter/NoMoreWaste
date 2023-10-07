import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:no_more_waste/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: IntroductionScreen(
        scrollPhysics: const BouncingScrollPhysics(), //Default is BouncingScrollPhysics
        pages: [
          PageViewModel(
            title: 'Welcome', //Basic String Title
            //titleWidget: const Text('Welcome'), //If you want to use your own Widget
            body: 'Be part of a community with like-minded people looking to save on food wastage!', //Basic String Body
            //bodyWidget: const Text('Discover our free food marketplace where you can list your items or collect from someone else!'), //If you want to use your own Widget
            decoration: const PageDecoration(), //Page decoration Contain all page customizations
            image: Center(
              child: Image.asset("assets/images/logo_white.png"),
            ), //If you want to you can also wrap around Alignment
            reverse: false, //If widget Order is reverse - body before image
            footer: const Text(''), //You can add button here for instance
          ),
          PageViewModel(
            title: 'Marketplace', //Basic String Title
            //titleWidget: const Text('Welcome'), //If you want to use your own Widget
            body: 'Discover our free food marketplace where you can list your items or collect from someone else!', //Basic String Body
            //bodyWidget: const Text('Discover our free food marketplace where you can list your items or collect from someone else!'), //If you want to use your own Widget
            decoration:
            const PageDecoration(), //Page decoration Contain all page customizations
            image: Center(
              child: Image.asset("assets/images/introduction_people.png"),
            ), //If you want to you can also wrap around Alignment
            reverse: false, //If widget Order is reverse - body before image
            footer: const Text(''), //You can add button here for instance
          ),
          PageViewModel(
            title: 'Recycle', //Basic String Title
            //titleWidget: const Text('Welcome'), //If you want to use your own Widget
            body: 'Find alternatives, how and where to recycle.', //Basic String Body
            //bodyWidget: const Text('Discover our free food marketplace where you can list your items or collect from someone else!'), //If you want to use your own Widget
            decoration: const PageDecoration(), //Page decoration Contain all page customizations
            image: Center(
              child: Image.asset("assets/images/introduction_recycling.png"),
            ), //If you want to you can also wrap around Alignment
            reverse: false, //If widget Order is reverse - body before image
            footer: const Text(''), //You can add button here for instance
          ),
          PageViewModel(
            title: 'Food banks', //Basic String Title
            //titleWidget: const Text('Welcome'), //If you want to use your own Widget
            body: 'As well as helping out and donating to food banks!', //Basic String Body
            //bodyWidget: const Text('Discover our free food marketplace where you can list your items or collect from someone else!'), //If you want to use your own Widget
            decoration: const PageDecoration(), //Page decoration Contain all page customizations
            image: Center(
              child: Image.asset("assets/images/introduction_home.png"),
            ), //If you want to you can also wrap around Alignment
            reverse: false, //If widget Order is reverse - body before image
            footer: const Text(''), //You can add button here for instance
          ),
        ],
        rawPages: [
          //If you don't want to use PageViewModel you can use this
        ],
        //If you provide both rawPages and pages parameter, pages will be used.
        onChange: (e){
          // When something changes
        },
        onDone: () async {
          // Obtain shared preferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isfirstlaunch', false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const LoginPage();
              },
            ),
          );
        },
        onSkip: () {
          // You can also override onSkip callback
        },
        showSkipButton: false, //Is the skip button should be display
        skip: const Icon(Icons.skip_next),
        next: const Icon(Icons.forward),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),

        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}