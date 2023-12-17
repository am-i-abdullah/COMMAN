import 'package:comman/pages/home_page.dart';
import 'package:flutter/material.dart';
import './theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: HomePage(
        changeTheme: changeTheme,
        currentTheme: theme,
      ),
    );
  }
}
