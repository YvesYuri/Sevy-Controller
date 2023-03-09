import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:controller/src/modules/settings/settings_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../home/home_view.dart';
import '../my_account/my_account_view.dart';
import 'navigator_controller.dart';

class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  void showMyAccountPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyAccountView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final navigatorController =
    //     Provider.of(context).watch<NavigatorController>();
    return Consumer<NavigatorController>(
      builder: (context, navigatorController, child) {
        return NavigationView(
          // appBar: const NavigationAppBar(
          //   title: Text(
          //     "My Room",
          //     style: TextStyle(
          //       // color: Colors.white,
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          transitionBuilder: (child, animation) {
            return DrillInPageTransition(animation: animation, child: child);
          },
          pane: NavigationPane(
            displayMode: PaneDisplayMode.top,
            selected: navigatorController.currentPage,
            onChanged: (value) {
              navigatorController.changePage(value);
            },
            items: [
              PaneItem(
                  icon: const Icon(FluentIcons.home),
                  title: const Text("Home"),
                  body: HomeView()),
              PaneItem(
                  icon: const Icon(FluentIcons.play),
                  title: const Text("Scenarios"),
                  body: HomeView()),
              PaneItem(
                  icon: const Icon(FluentIcons.settings),
                  title: const Text("Settings"),
                  body: SettingsView()),
            ],
            footerItems: [
              PaneItemAction(
                icon: const Icon(FluentIcons.contact),
                title: const Text("My Account"),
                onTap: () {
                  showMyAccountPopUp();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
