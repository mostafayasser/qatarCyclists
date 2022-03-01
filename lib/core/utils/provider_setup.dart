// provider_setup.dart
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/core/services/notification/notification_service.dart';

import '../../core/page_models/theme_provider.dart';
import '../../core/services/connectivity/connectivity_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<ConnectivityService>(
      create: (context) => ConnectivityService()),
  Provider<HttpApi>(create: (c) => HttpApi(c)),
  Provider<NotificationService>(create: (c) => NotificationService()),
];

List<SingleChildWidget> dependentServices = [
  // ProxyProvider<HttpApi, AuthenticationService>(update: (context, api, authenticationService) => AuthenticationService(api: api)),

  ChangeNotifierProvider<AuthenticationService>(
      create: (c) => AuthenticationService(api: Provider.of(c, listen: false))),
];

List<SingleChildWidget> uiConsumableProviders = [
  ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
  ChangeNotifierProvider<AppLanguageModel>(create: (_) => AppLanguageModel()),

  ChangeNotifierProvider<CategoriesProvider>(
      create: (c) => CategoriesProvider(api: Provider.of(c, listen: false))),
  // StreamProvider<User>(create: (context) => Provider.of<AuthenticationService>(context, listen: false).user),
];

class CategoriesProvider extends ChangeNotifier {
  final HttpApi api;
  List<dynamic> appData;

  CategoriesProvider({this.api});

  fetchCategories() {}
}
