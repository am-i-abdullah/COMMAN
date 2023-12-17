import 'package:comman/widgets/crm.dart';
import 'package:comman/widgets/notifications.dart';
import 'package:comman/widgets/settings.dart';
import 'package:comman/widgets/team.dart';
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
  Widget content = const Center(child: Text('Team'));

  @override
  Widget build(BuildContext context) {
    // varying icon for theme
    var icon = (widget.currentTheme == ThemeMode.dark)
        ? Icons.light_mode
        : Icons.dark_mode;
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          toolbarHeight: 60,

          title: const Text(
            "COMMAN",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
            ),
          ),

          // for logo
          // title: Image.asset(
          //   ThemeMode.system == ThemeMode.dark
          //       ? 'assets/dark.png'
          //       : 'assets/dark.png',
          //   height: 25,
          // ),
          actions: width > 600
              // desktop view
              ? [
                  // team button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        content = const Team();
                      });
                    },
                    icon: const Icon(Icons.group),
                  ),
                  // CRM buttom
                  IconButton(
                    onPressed: () {
                      setState(() {
                        content = const CRM();
                      });
                    },
                    icon: const Icon(Icons.person),
                  ),
                  // notifications button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        content = const Notifications();
                      });
                    },
                    icon: const Icon(Icons.notifications),
                  ),

                  // user name
                  const SizedBox(width: 15),
                  const Text(
                    "User Name",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 15),
                  // change theme button
                  IconButton(
                    onPressed: () {
                      widget.changeTheme();
                    },
                    icon: Icon(icon),
                  ),
                  const SizedBox(width: 10),
                ]
              :
              // mobile view
              [
                  // change theme button
                  IconButton(
                    onPressed: () {
                      widget.changeTheme();
                    },
                    icon: Icon(icon),
                  ),
                  const SizedBox(width: 10),
                ],
          bottom: width < 600
              ? TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.group),
                      text: 'Team',
                      // iconMargin: EdgeInsets.all(3),
                    ),
                    Tab(
                      icon: Icon(Icons.person),
                      text: 'CRM',
                    ),
                    Tab(
                      icon: Icon(Icons.notifications),
                      text: 'Alerts',
                    ),
                    Tab(
                      icon: Icon(Icons.settings),
                      text: 'Setting',
                    ),
                  ],
                  onTap: (value) {
                    setState(() {
                      if (value == 0) content = const Team();
                      if (value == 1) content = const CRM();
                      if (value == 2) content = const Notifications();
                      if (value == 3) content = const Settings();
                    });
                  },
                )
              : const PreferredSize(
                  preferredSize: Size(0, 0),
                  child: SizedBox(),
                ),
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
        body: content,
      ),
    );
  }
}
