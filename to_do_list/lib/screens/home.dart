import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/services/authentication.dart';
import 'package:to_do_list/services/database.dart';
import 'package:to_do_list/models/todo.dart';
import 'package:to_do_list/widgets/todo_card.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Home({super.key, required this.auth, required this.firestore});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _todoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("ToDo App"), centerTitle: true, actions: [
        IconButton(
          onPressed: () {
            Auth(auth: widget.auth).signOut();
          },
          icon: const Icon(Icons.exit_to_app),
        )
      ]),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Add ToDo Here:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: ValueKey("addField"),
                      controller: _todoController,
                    ),
                  ),
                  IconButton(
                    key: ValueKey("addButton"),
                    onPressed: () {
                      if (_todoController.text != "") {
                        setState(() {
                          Database(firestore: widget.firestore).addTodo(
                              uid: widget.auth.currentUser!.uid,
                              content: _todoController.text);
                          _todoController.clear();
                        });
                      }
                    },
                    icon: Icon(Icons.add),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Your Todos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Database(firestore: widget.firestore)
                  .streamTodos(uid: widget.auth.currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TodoModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        return TodoCard(
                          firestore: widget.firestore,
                          uid: widget.auth.currentUser!.uid,
                          todo: snapshot.data![index],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text("You dont have any unfinished todos"),
                  );
                } else {
                  return const Center(
                    child: Text("loading.."),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
