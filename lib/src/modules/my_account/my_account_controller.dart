import 'package:controller/src/data/services/authentication_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../data/models/user_model.dart';

enum MyAccountState {
  initial,
  loading,
  success,
  error,
}

class MyAccountController extends ChangeNotifier {
  final authenticationService = AuthenticationService();

  Stream<UserModel?> get authStateChanges =>
      authenticationService.authStateChanges();

  var state = MyAccountState.initial;
  bool newUser = false;
  bool passwordLoginVisible = false;
  TextEditingController displayNameController = TextEditingController(text: "Yves");
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController(text: "123456");
  TextEditingController confirmPasswordController = TextEditingController(text: "123456");

  void changeNewUser(bool value) {
    newUser = value;
    notifyListeners();
  }

  void clearControllers() {
    displayNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  bool validateLogin() {
    bool emailIsValid = emailController.text.isNotEmpty && EmailValidator.validate(emailController.text);
    bool passwordIsValid = passwordController.text.isNotEmpty && passwordController.text.length >= 6;
    bool loginIsValid = emailIsValid && passwordIsValid;
    return loginIsValid;
  }

  bool validateSignUp() {
    bool displayNameIsValid = displayNameController.text.isNotEmpty && displayNameController.text.length >= 4;
    bool emailIsValid = emailController.text.isNotEmpty && EmailValidator.validate(emailController.text);
    bool passwordIsValid = passwordController.text.isNotEmpty && passwordController.text.length >= 6;
    bool confirmPasswordIsValid = confirmPasswordController.text.isNotEmpty && confirmPasswordController.text == passwordController.text;
    bool signUpIsValid = displayNameIsValid && emailIsValid && passwordIsValid && confirmPasswordIsValid;
    return signUpIsValid;
  }

  void changePasswordLoginVisible() {
    passwordLoginVisible = !passwordLoginVisible;
    notifyListeners();
  }

  Future<String> signIn() async {
    state = MyAccountState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      String result = await authenticationService.signIn(
          emailController.text, passwordController.text);
      clearControllers();
      state = MyAccountState.success;
      notifyListeners();
      return result;
    } catch (e) {
      state = MyAccountState.error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> signUp() async {
    state = MyAccountState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
       var result = await authenticationService.signUp(
          displayNameController.text,
          emailController.text,
          passwordController.text);
      clearControllers();
      state = MyAccountState.success;
      notifyListeners();
      return result;
    } catch (e) {
      state = MyAccountState.error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> signOut() async {
    state = MyAccountState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    await authenticationService.signOut();
    clearControllers();
    state = MyAccountState.success;
    notifyListeners();
  }
}
