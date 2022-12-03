import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String todoId = "";
  String content = "";
  bool done = false;

  TodoModel({
    required this.todoId,
    required this.content,
    required this.done,
  });

  TodoModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    todoId = documentSnapshot.id;
    content = documentSnapshot.get(content);
    done = documentSnapshot.get(done);
  }
}
