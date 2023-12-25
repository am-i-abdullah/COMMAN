import 'package:comman/widgets/crm.dart';
import 'package:comman/widgets/notifications.dart';
import 'package:comman/widgets/hrm.dart';
import 'package:comman/widgets/home.dart';
import 'package:comman/widgets/sidebar.dart';
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
  Widget content = const Home();

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

          title: InkWell(
            highlightColor: null,
            onTap: () {
              setState(() {
                content = const Home();
              });
            },
            child: const Text(
              "COMMAN",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
              ),
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
                  // Home/ dashboard button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        content = const Home();
                      });
                    },
                    icon: const Icon(Icons.home),
                  ),

                  // HRM
                  IconButton(
                    onPressed: () {
                      setState(() {
                        content = const HRM();
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
                    icon: const Icon(Icons.widgets),
                  ),

                  // Notifications button
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
              ? const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.home),
                      text: 'Home',
                    ),
                    Tab(
                      icon: Icon(Icons.group),
                      text: 'HRM',
                    ),
                    Tab(
                      icon: Icon(Icons.widgets),
                      text: 'CRM',
                    ),
                    Tab(
                      icon: Icon(Icons.notifications),
                      text: 'Alerts',
                    ),
                  ],
                )
              : const PreferredSize(
                  preferredSize: Size(0, 0),
                  child: SizedBox(),
                ),
        ),
        drawer: const SideBar(),

        // body of main page
        body: width > 600
            ? content // web view
            : const TabBarView(children: [
                // mobile view
                Home(),
                HRM(),
                CRM(),
                Notifications(),
              ]),
      ),
    );
  }
}
