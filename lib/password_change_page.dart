import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:no_more_waste/util/password_util.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({Key? key}) : super(key: key);

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reenterNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Change password')
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
                          'NoWaste App',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Change password',
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: oldPasswordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Old password',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New password',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        controller: reenterNewPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Repeat new password',
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Change password'),
                          onPressed: () async {
                            print("Old password: " + oldPasswordController.text);
                            print("Password: " + newPasswordController.text);
                            print("Password repeat: " + reenterNewPasswordController.text);

                            // check if password and re-entered password match
                            if (newPasswordController.text == reenterNewPasswordController.text) {
                              try {
                                final User? user = await FirebaseAuth.instance.currentUser;

                                //Pass in the password to updatePassword.
                                user!.updatePassword(newPasswordController.text).then((_) {
                                  print("Successfully changed password");
                                }).catchError((error) {
                                  print("Password can't be changed" + error.toString());
                                  //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                                });

                                print('User successfully changed');
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
                  ],
                )
            )
        ));
  }
}
