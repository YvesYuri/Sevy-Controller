import 'package:controller/src/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AuthenticationService {
  static final AuthenticationService instance =
      AuthenticationService._internal();

  factory AuthenticationService() {
    return instance;
  }

  AuthenticationService._internal();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<UserModel?> authStateChanges() =>
      firebaseAuth.userChanges().map((event) => event == null
          ? UserModel()
          : UserModel(
              email: event.email,
              displayName: event.displayName,
              registerDate: DateFormat("dd/MM/yyyy")
                  .format(event.metadata.creationTime!)));

  Future<String> signIn(String email, String password) async {
    UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user!;
    return user.email!;
  }

  Future<String> signUp(
      String displayName, String email, String password) async {
    UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user!;
    var currentUser = firebaseAuth.currentUser;
    await user.reload();
    user.updateDisplayName(displayName);
    user.sendEmailVerification();
    return user.email!;
  }

  Future<void> signOut() async {
    try {
      return await firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
