import 'package:fluent_ui/fluent_ui.dart';


class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Text(
          "Settings",
          style: TextStyle(
            // color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      content: Container(),
    );
  }
}