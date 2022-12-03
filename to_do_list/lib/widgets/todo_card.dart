import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/models/todo.dart';
import 'package:to_do_list/services/database.dart';

class TodoCard extends StatefulWidget {
  final TodoModel todo;
  final FirebaseFirestore firestore;
  final String uid;

  const TodoCard(
      {required this.todo,
      required this.firestore,
      required this.uid,
      super.key});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(children: [
          Expanded(
            child: Text(
              widget.todo.content,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Checkbox(
              value: widget.todo.done,
              onChanged: (newValue) {
                setState(() {});
                Database(firestore: widget.firestore)
                    .updateTodo(uid: widget.uid, todoId: widget.todo.todoId);
              })
        ]),
      ),
    );
  }
}
