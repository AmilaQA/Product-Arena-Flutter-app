import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/models/todo.dart';

//prije ovog creirati bazu na firebaseu
class Database {
  final FirebaseFirestore firestore;

  Database({required this.firestore});

  Stream<List<TodoModel>> streamTodos({required String uid}) {
    try {
      return firestore
          .collection("todos")
          .doc(uid)
          .collection("todos")
          .where("done", isEqualTo: false)
          .snapshots()
          .map((query) {
        final List<TodoModel> retVal = <TodoModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo({required String uid, required String content}) async {
    try {
      firestore.collection("todos").doc(uid).collection("todos").add({
        "content": content,
        "done": false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo({required String uid, required String todoId}) async {
    try {
      firestore
          .collection("todos")
          .doc(uid)
          .collection("todos") //todos za specific user
          .doc(todoId)
          .update({
        "done": true,
      });
    } catch (e) {
      rethrow;
    }
  }
}
