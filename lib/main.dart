import 'package:controller/firebase_options.dart';
import 'package:controller/src/data/models/user_model.dart';
import 'package:controller/src/data/services/authentication_service.dart';
import 'package:controller/src/modules/my_account/my_account_controller.dart';
import 'package:controller/src/modules/navigator/navigator_controller.dart';
import 'package:controller/src/modules/navigator/navigator_view.dart';
import 'package:controller/src/modules/settings/settings_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

import 'src/modules/home/home_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Lumitech());
}

class Lumitech extends StatelessWidget {
  const Lumitech({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigatorController>(
            create: (_) => NavigatorController()),
        ChangeNotifierProvider<HomeController>(create: (_) => HomeController()),
        ChangeNotifierProvider<MyAccountController>(
            create: (_) => MyAccountController()),
        ChangeNotifierProvider<SettingsController>(
            create: (_) => SettingsController()),
      ],
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        //color: SystemTheme.accentColor.accent.toAccentColor(),
        theme: FluentThemeData(
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: SystemTheme.accentColor.accent.toAccentColor(),
        ),
        darkTheme: FluentThemeData(
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: SystemTheme.accentColor.accent.toAccentColor(),
          scaffoldBackgroundColor: Colors.grey[210],
        ),
        themeMode: ThemeMode.light,
        home: const NavigatorView(),
      ),
    );
  }
}
