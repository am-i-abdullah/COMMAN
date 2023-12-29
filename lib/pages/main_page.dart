import 'package:comman/api/data_fetching/get_user.dart';
import 'package:comman/pages/user_settings.dart';
import 'package:comman/provider/user_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/pages/subpages/notifications.dart';
import 'package:comman/pages/subpages/home.dart';
import 'package:comman/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage(
      {super.key,
      required this.changeTheme,
      required this.currentTheme,
      required this.storage});

  final void Function() changeTheme;
  final currentTheme;
  final storage;
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Widget content = const Home();

  @override
  Widget build(BuildContext context) {
    // *** *** *** *** *** //
    ref.watch(userProvider);
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
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(() {
                getUser(token: tokenToken);
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
          actions: width > 700
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
                  // Notifications button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        content = const Notifications();
                      });
                    },
                    icon: const Icon(Icons.notifications),
                  ),
                  // user settings button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        content = const UserSettings();
                      });
                    },
                    icon: const Icon(Icons.settings),
                  ),

                  // user name
                  const SizedBox(width: 15),
                  Text(
                    '${ref.watch(userProvider).firstname} ${ref.watch(userProvider).lastname}',
                    style: const TextStyle(fontSize: 20),
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
          bottom: width < 700
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
                      icon: Icon(Icons.settings),
                      text: 'Settings',
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
        drawer: SideBar(storage: widget.storage),

        // body of main page
        body: width > 700
            ? content // web view
            : const TabBarView(children: [
                // mobile view
                Home(),
                UserSettings(),
                Notifications(),
              ]),
      ),
    );
  }
}
