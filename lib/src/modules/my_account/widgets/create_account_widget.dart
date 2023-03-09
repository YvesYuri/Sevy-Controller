import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../my_account_controller.dart';

class CreateAccountWidget extends StatelessWidget {
  final MyAccountController? myAccountController;
  const CreateAccountWidget({super.key, this.myAccountController});

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
      key: const Key('3'),
      title: const Text('Create Account'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          TextBox(
            controller: myAccountController!.displayNameController,
            placeholder: 'Name',
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 10),
          TextBox(
            placeholder: 'Email',
            controller: myAccountController!.emailController,
          ),
          const SizedBox(height: 10),
          TextBox(
            controller: myAccountController!.passwordController,
            placeholder: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 10),
          TextBox(
            controller: myAccountController!.confirmPasswordController,
            placeholder: 'Confirm Password',
            obscureText: true,
          ),
        ],
      ),
      actions: [
        Button(
          child: const Text('Back'),
          onPressed: () {
            myAccountController!.clearControllers();
            myAccountController!.changeNewUser(false);
          },
        ),
        Button(
          child: const Text('Cancel'),
          onPressed: () {
            myAccountController!.changeNewUser(false);
            Navigator.pop(context);
          },
        ),
        FilledButton(
          child: const Text('Create'),
          onPressed: () async {
            if (myAccountController!.validateSignUp()) {
              var result = await myAccountController!.signUp();
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
                  'Please provide a name with at least 4 characters, a valid email address, and a password with at least 6 characters to proceed.',
                  InfoBarSeverity.error);
            }
          },
        ),
      ],
    );
  }
}
