import 'package:firedart/firedart.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  Future signInState() async {
    return _firebaseAuth.isSignedIn;
  }
  

  Future currentUser() async {
    var user = await _firebaseAuth.getUser();
    // String localId = user.id;
    // String? email = user.email;
    return user;
  }

  Future signUp(String email, String pass, String displayName) async {
    try {
      await _firebaseAuth.signUp(email, pass);
      await _firebaseAuth.updateProfile(displayName: displayName);
      var user = await _firebaseAuth.getUser();
      return user;
    } catch(e) {
      return e.toString();
    }
  }

  Future signIn(String email, String pass) async {
    try {
      await _firebaseAuth.signIn(email, pass);
      var user = await _firebaseAuth.getUser();
      return user;
    } catch(e) {
      return e.toString();
    }
  }

  Future signOut() async {
    return _firebaseAuth.signOut();
  }
}