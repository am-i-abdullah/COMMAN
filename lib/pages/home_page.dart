import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.changeTheme, required this.currentTheme});

  final void Function() changeTheme;
  final currentTheme;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void changeThemeAndIcons() {}
  @override
  Widget build(BuildContext context) {
    // varying icon for theme
    var icon = (widget.currentTheme == ThemeMode.dark)
        ? Icons.light_mode
        : Icons.dark_mode;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Image.asset(
          ThemeMode.system == ThemeMode.dark
              ? 'assets/dark.png'
              : 'assets/dark.png',
          height: 25,
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.changeTheme();
            },
            icon: Icon(icon),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        width: width > 600 ? width * 0.25 : width * 0.875,
        child: const Center(
          child: Text(
            "LOL 😂\nhold on buddy",
            style: TextStyle(
              fontSize: 20,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),

      // body of main page
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('abccc'),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("ccccc"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
