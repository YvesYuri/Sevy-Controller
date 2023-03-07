import 'package:fluent_ui/fluent_ui.dart';

class NavigatorController extends ChangeNotifier {
  int currentPage = 0;

  void changePage(int index) {
    currentPage = index;
    notifyListeners();
  }

}
