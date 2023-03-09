import 'package:auto_size_text/auto_size_text.dart';
import 'package:controller/src/core/theme/theme.dart';
import 'package:controller/src/data/models/user_model.dart';
import 'package:controller/src/modules/my_account/widgets/create_account_widget.dart';
import 'package:controller/src/modules/my_account/widgets/login_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:system_theme/system_theme.dart';

import 'my_account_controller.dart';

class MyAccountView extends StatelessWidget {
  const MyAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAccountController>(
        builder: (context, myAccountController, child) {
      return StreamBuilder<UserModel?>(
          stream: myAccountController.authStateChanges,
          builder: (context, snapshot) {
            return Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: !snapshot.hasData
                      ? Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 60,
                          width: 60,
                          child: const FittedBox(
                            fit: BoxFit.fill,
                            child: ProgressRing(
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : (snapshot.hasData && snapshot.data!.email != null
                          ? ContentDialog(
                              key: const Key('1'),
                              title: const Text('My Account'),
                              content: Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Row(
                                  children: [
                                    QrImage(
                                      foregroundColor:
                                          FluentTheme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                      data: snapshot.data!.email!,
                                      version: QrVersions.auto,
                                      size: 70,
                                      gapless: false,
                                      padding: const EdgeInsets.only(
                                        left: 0,
                                        right: 0,
                                        top: 2,
                                        bottom: 0,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(
                                          "Name: ${snapshot.data!.displayName!}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        AutoSizeText(
                                          "Email: ${snapshot.data!.email!}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        AutoSizeText(
                                          "Member since: ${snapshot.data!.registerDate!}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        // const SizedBox(height: 10),
                                        // Row(
                                        //   children: [
                                        //     const Text('Dark Mode: '),
                                        //     Switch(
                                        //       value: SystemTheme.isDarkMode,
                                        //       onChanged: (value) {
                                        //         SystemTheme.setTheme(value
                                        //             ? SystemThemeMode.dark
                                        //             : SystemThemeMode.light);
                                        //       },
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                Button(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FilledButton(
                                  child: const Text('Logout'),
                                  onPressed: () {
                                    myAccountController.signOut();
                                  },
                                ),
                              ],
                            )
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: myAccountController.newUser
                                  ? CreateAccountWidget(
                                      myAccountController: myAccountController,
                                    )
                                  : LoginWidget(
                                      myAccountController: myAccountController,
                                    ))),
                ),
                Visibility(
                  visible: myAccountController.state == MyAccountState.loading,
                  child: Container(
                    // height: 60,
                    // width: 60,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 60,
                      width: 60,
                      child: const FittedBox(
                        fit: BoxFit.fill,
                        child: ProgressRing(
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    });
  }
}
