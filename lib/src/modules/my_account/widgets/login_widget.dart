import 'package:controller/src/modules/my_account/my_account_controller.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:system_theme/system_theme.dart';

class LoginWidget extends StatelessWidget {
  final MyAccountController? myAccountController;
  const LoginWidget({super.key, this.myAccountController});

  void showMessage(BuildContext context, String title, String message,
      InfoBarSeverity severity) {
    displayInfoBar(
      context,
      builder: (context, close) {
        return InfoBar(
          title: Text(title),
          content: Text(message),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: severity,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      key: const Key('2'),
      title: const Text('Login'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          TextBox(
            controller: myAccountController!.emailController,
            keyboardType: TextInputType.emailAddress,
            placeholder: 'Email',
          ),
          const SizedBox(height: 10),
          TextBox(
            controller: myAccountController!.passwordController,
            keyboardType: TextInputType.text,
            obscureText:
                myAccountController!.passwordLoginVisible ? false : true,
            placeholder: 'Password',
            suffix: IconButton(
              icon: Icon(
                myAccountController!.passwordLoginVisible
                    ? FluentIcons.hide3
                    : FluentIcons.view,
              ),
              onPressed: () {
                myAccountController!.changePasswordLoginVisible();
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'New User? ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              GestureDetector(
                onTap: () {
                  myAccountController!.changeNewUser(true);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    'Create account!',
                    style: TextStyle(
                      color: FluentTheme.of(context).accentColor,
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
            myAccountController!.changeNewUser(false);
            Navigator.pop(context);
            // Delete file here
          },
        ),
        FilledButton(
          child: const Text('Login'),
          onPressed: () async {
            if (myAccountController!.validateLogin()) {
              var result = await myAccountController!.signIn();
              if (myAccountController!.state == MyAccountState.error) {
                showMessage(context, 'Error', result, InfoBarSeverity.error);
              } else if (myAccountController!.state == MyAccountState.success) {
                showMessage(
                    context, 'Success', result, InfoBarSeverity.success);
              }
            } else {
              showMessage(
                  context,
                  'Error',
                  'Please provide a valid email address and a password with at least 6 characters to proceed.',
                  InfoBarSeverity.error);
            }
          },
        ),
      ],
    );
  }
}
