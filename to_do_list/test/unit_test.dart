import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/services/authentication.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

final _mockUser = MockUser();

//mokamo authentication klasu ali ne nasu nego na firebase
//MockAuthFirebase sadrzi sve mockove
//klasa koju mokamo je FirebaseAuth
class MockAuthFirebase extends Mock implements FirebaseAuth {
  //overrideamo funkciju koju testiramo
  @override
  Stream<User?> authStateChanges() {
    // TODO: implement authStateChanges
    return Stream.fromIterable([
      //iteriramo kroz usere pa moramo da mockiramo i usere
      _mockUser
    ]);
  }
}

void main() {
  final MockAuthFirebase mockAuthFirebase = MockAuthFirebase();
  final Auth auth = Auth(auth: mockAuthFirebase);
  setUp(() {}); //runs before every test
  tearDown(() {}); //runs after every test

  test('emit occurrs', () async {
    //ocekujemo da user vrati stream svojih informacija
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  //ostali testovi
   test("Todo Added", () {
    _listController.addTodo(TodoModel("Get Groceries", false));
    expect(_listController.todoList.length, 1);
    expect(_listController.todoList[0].content, "Get Groceries");
  });
}
