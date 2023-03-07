import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
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
                  icon: const Icon(FluentIcons.lightbulb),
                  title: const Text("Devices"),
                  body: HomeView()),
            ],
            footerItems: [
              // PaneItem(
              //     icon: const Icon(FluentIcons.settings),
              //     title: const Text("Settings"),
              //     body: HomeView()),
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
