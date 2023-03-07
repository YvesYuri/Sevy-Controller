import 'package:fluent_ui/fluent_ui.dart';

class MyAccountController extends ChangeNotifier {
  bool newUser = false;

  void changeNewUser(bool value) {
    newUser = value;
    notifyListeners();
  }
}
