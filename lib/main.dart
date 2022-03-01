import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'core/page_models/theme_provider.dart';
import 'core/services/localization/localization.dart';
import 'core/services/preference/preference.dart';
import 'core/utils/provider_setup.dart';
import 'ui/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preference.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  // MyApp();

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: providers,
        child: Consumer2<AppLanguageModel, ThemeProvider>(
          builder: (context, language, theme, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              home: Routes.splash,
              debugShowCheckedModeBanner: false,
              theme: theme.isDark ? theme.dark : theme.light,
              locale: language.appLocal,
              supportedLocales: [const Locale('en'), const Locale('ar')],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}
