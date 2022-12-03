import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/screens/login.dart';
import 'package:to_do_list/screens/home.dart';
import 'package:to_do_list/services/authentication.dart';

Future<void> main() async {
  //zbog await
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

//firebase connection
class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
                body: Center(
              child: Text('Error'),
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return const Root();
          }

          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

//is the user authenticated or not
class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth(auth: _auth).user, //Auth Stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.uid == null) {
              //uuid null - nobody is logedin
              return Login(
                auth: _auth,
                firestore: _firestore,
              );
            } else {
              return Home(
                auth: _auth,
                firestore: _firestore,
              );
            }
          } else {
            return const Scaffold(
              body: Center(
                child: Text("Loading..."),
              ),
            );
          }
        }); //return either home or authenticate wideget
  }
}
