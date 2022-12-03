import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Login({super.key, required this.auth, required this.firestore});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Builder(builder: (BuildContext context) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    key: ValueKey("username"),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: "Username"),
                    controller: _emailController,
                  ),
                  TextFormField(
                    key: ValueKey("password"),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: "Password"),
                    controller: _passwordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    key: const ValueKey("signIn"),
                    onPressed: () async {
                      final String retVal = await Auth(auth: widget.auth)
                          .signIn(
                              email: _emailController.text,
                              password: _passwordController.text);

                      if (retVal == "Success") {
                        _emailController.clear();
                        _passwordController.clear();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(retVal)));
                      }
                    },
                    child: const Text('SingIn'),
                  ),
                  ElevatedButton(
                    key: const ValueKey("register"),
                    onPressed: () async {
                      final String retValue = await Auth(auth: widget.auth)
                          .createAccount(
                              email: _emailController.text,
                              password: _passwordController.text);

                      if (retValue == "Success") {
                        _emailController.clear();
                        _passwordController.clear();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(retValue)));
                      }
                    },
                    child: const Text('Create Account'),
                  ),
                ]);
          }),
        ),
      ),
    );
  }
}
