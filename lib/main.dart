// ignore_for_file: unused_import

import 'package:comman/pages/auth.dart';
import 'package:comman/pages/main_page.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // accessing local storage
  final storage = const FlutterSecureStorage();
  var isTokenAvailable = true;

  // initial theme
  var theme = ThemeMode.dark;
  // changing the theme of app
  void changeTheme() {
    setState(() {
      if (theme == ThemeMode.dark) {
        theme = ThemeMode.light;
      } else {
        theme = ThemeMode.dark;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    loadToken();
  }

  void loadToken() async {
    var token = await storage.read(key: 'token');
    if (token == null) isTokenAvailable = false;

    print('token $token');
    print(isTokenAvailable);

    if (isTokenAvailable) {
      ref.read(tokenProvider.state).state = token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COMMAN',

      // Dark Mode theme
      darkTheme: darkModeTheme,
      // Light Mode Theme
      theme: lightModeTheme,
      //initial theme
      themeMode: theme,

      // body of the main page
      home: Consumer(
        builder: (context, ref, child) {
          final token = ref.watch(tokenProvider);

          if (token == null) {
            return AuthScreen(
              changeTheme: changeTheme,
              currentTheme: theme,
              storage: storage,
            );
          } else {
            return HomePage(
              changeTheme: changeTheme,
              currentTheme: theme,
              storage: storage,
            );
          }
        },
      ),
    );
  }
}
