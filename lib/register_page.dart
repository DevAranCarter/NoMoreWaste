import 'package:flutter/material.dart';
import 'package:no_more_waste/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:no_more_waste/util/password_util.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordReenterController = TextEditingController();
  final passwordFieldFocusNode = FocusNode();
  final passwordReenterFieldFocusNode = FocusNode();
  bool _obscuredPassword = true;
  bool _obscuredPasswordReenter = true;

  void _toggleObscuredPassword() {
    setState(() {
      _obscuredPassword = !_obscuredPassword;
      if (passwordFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      passwordFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  void _toggleObscuredPasswordReenter() {
    setState(() {
      _obscuredPasswordReenter = !_obscuredPasswordReenter;
      if (passwordReenterFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      passwordReenterFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Sign up"),
            automaticallyImplyLeading: false
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
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
                          'Register',
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
                              )
                          ),
                          labelText: 'E-Mail address',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscuredPassword,
                        focusNode: passwordFieldFocusNode,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              )
                          ),
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscuredPassword,
                              child: Icon(
                                _obscuredPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        controller: passwordReenterController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscuredPasswordReenter,
                        focusNode: passwordReenterFieldFocusNode,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              )
                          ),
                          labelText: 'Repeat password',
                          prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscuredPasswordReenter,
                              child: Icon(
                                _obscuredPasswordReenter ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Register'),
                          onPressed: () async {
                            print("E-Mail: " + emailController.text);
                            print("Password: " + passwordController.text);
                            print("Password repeat: " + passwordReenterController.text);

                            // check if password and re-entered password match
                            if (passwordController.text == passwordReenterController.text) {
                              try {
                                final newUser = await _auth
                                    .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                                print('User successfully created' +
                                    newUser.toString());

                                // send confirmation e-mail
                                print('Send confirmation email');
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null && !user.emailVerified) {
                                  await user.sendEmailVerification();
                                }

                                // Show alert to indicate that registration was successful
                                PasswordUtil.showSuccessfullyRegisteredDialog(context);
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              // if passwords do not match
                              print('Passwords do not match');
                              PasswordUtil.showPasswordsNotMatchDialog(context);
                            }
                          },
                        )
                    ),
                    Row(
                      children: <Widget>[
                        const Text('Already have an account?'),
                        TextButton(
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                )
            )
        ));
  }
}
