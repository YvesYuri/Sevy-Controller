import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

import 'my_account_controller.dart';

class MyAccountView extends StatelessWidget {
  const MyAccountView({super.key});

  Widget newUserWidget() {
    return const Center(
      child: Text("New User"),
    );
  }

  Widget loginWidget() {
    return const Center(
      child: Text("My Account"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAccountController>(
        builder: (context, myAccountController, child) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: myAccountController.newUser
            ? ContentDialog(
                key: const Key('1'),
                title: const Text('Create Account'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    TextBox(
                      placeholder: 'Name',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    TextBox(
                      placeholder: 'Email',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    TextBox(
                      placeholder: 'Password',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    TextBox(
                      placeholder: 'Confirm Password',
                      onChanged: (value) {},
                    ),
                  ],
                ),
                actions: [
                  Button(
                    child: const Text('Back'),
                    onPressed: () {
                      myAccountController.changeNewUser(false);
                    },
                  ),
                  Button(
                    child: const Text('Cancel'),
                    onPressed: () {
                      myAccountController.changeNewUser(false);
                      Navigator.pop(context);
                    },
                  ),
                  FilledButton(
                    child: const Text('Create'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : ContentDialog(
                key: const Key('2'),
                title: const Text('Login'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    TextBox(
                      placeholder: 'Email',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    TextBox(
                      placeholder: 'Password',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AutoSizeText(
                          'New User? ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            myAccountController.changeNewUser(true);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: AutoSizeText(
                              'Create account!',
                              style: TextStyle(
                                color: SystemTheme.accentColor.accent,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                actions: [
                  Button(
                    child: const Text('Cancel'),
                    onPressed: () {
                      myAccountController.changeNewUser(false);
                      Navigator.pop(context);
                      // Delete file here
                    },
                  ),
                  FilledButton(
                    child: const Text('Login'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
      );
    });
  }
}
