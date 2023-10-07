import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:no_more_waste/components/navigation_main_page.dart';
import 'package:no_more_waste/introduction_page.dart';
import 'package:no_more_waste/password_recovery_page.dart';
import 'package:no_more_waste/register_page.dart';
import 'package:no_more_waste/util/alert_util.dart';
import 'package:no_more_waste/util/password_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isFirstLaunch = false;
  final _auth = FirebaseAuth.instance;
  final textFieldFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    checkIsFirstLaunch();
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  checkIsFirstLaunch() async {
    // Obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'isfirstlaunch' key. If it doesn't exist, returns null.
    if (prefs.getBool('isfirstlaunch') == null) {
      // trigger UI update
      setState(() {
        isFirstLaunch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isFirstLaunch ? const IntroductionPage() : Scaffold(
        appBar: AppBar(
            title: const Text('Login'),
            automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  physics: const ClampingScrollPhysics(), // disable scroll animation
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'NoMoreWaste',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail, size: 24),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          labelText: 'E-Mail address',
                          contentPadding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscured,
                        focusNode: textFieldFocusNode,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              )
                          ),
                          prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(
                                _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //forgot password screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PasswordRecoveryPage(title: 'Reset password')),
                        );
                      },
                      child: const Text('Forgot Password',),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Login'),
                          onPressed: () async {
                            // login
                            print(emailController.text);
                            print(passwordController.text);
                            // send data to Firebase backend
                            try {
                              final user = await _auth.signInWithEmailAndPassword(
                                  email: emailController.text.trim(), password: passwordController.text).onError((error, stackTrace) => AlertUtil.showArbitraryDialog(context, error.toString() + stackTrace.toString()));
                              if (user != null && _auth.currentUser!.emailVerified) {
                                print('Successfully logged in');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NavigationMainPage()),
                                );
                              } else {
                                print('User is null or e-mail not verified');
                                PasswordUtil.showEmailNotVerifiedCode(context);
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        )
                    ),
                    Row(
                      children: <Widget>[
                        const Text('No account yet?'),
                        TextButton(
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GoogleAuthButton(
                        onPressed: () {},
                        darkMode: false, // if true second example
                      ),
                    ),
                  ],
                )
            )
        ));
  }
}
