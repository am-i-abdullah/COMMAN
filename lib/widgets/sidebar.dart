import 'package:comman/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key, required this.storage});
  final storage;
  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Drawer(
      width: width > 600 ? width * 0.25 : width * 0.875,
      child: ListView(
        children: [
          Stack(
            children: [
              UserAccountsDrawerHeader(
                margin: const EdgeInsets.only(bottom: 0),
                accountName: const Text('Taimoor Ikram'),
                accountEmail: const Text('timmmy@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      'https://media.licdn.com/dms/image/D4D03AQFaMHvTCjiEPg/profile-displayphoto-shrink_200_200/0/1695290361023?e=1709164800&v=beta&t=LzFLLrKE542wKEr6Eta6HufzGqtEpXamSNIeoJ3nX8E',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/cover.jpg'),
                    opacity: 0.3,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // HRM Button
          ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: const Icon(Icons.group),
            title: const Text('HRM'),
            children: [
              ListTile(
                leading: const Icon(Icons.bluetooth),
                title: const Text("one"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.wifi),
                title: const Text("two"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.three_g_mobiledata),
                title: const Text("three"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.four_g_mobiledata),
                title: const Text("four"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.five_g),
                title: const Text("five"),
                onTap: () {},
              ),
            ],
          ),

          // CRM Buttons
          ExpansionTile(
            leading: const Icon(Icons.group),
            title: const Text('CRM'),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ListTile(
                leading: const Icon(Icons.three_g_mobiledata),
                title: const Text("three"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.four_g_mobiledata),
                title: const Text("four"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.five_g),
                title: const Text("five"),
                onTap: () {},
              ),
            ],
          ),

          // notifications
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () {},
          ),

          IconButton(
            onPressed: () async {
              ref.read(tokenProvider.state).state = null;
              await widget.storage.write(key: 'token', value: null);

              print('logged out successfully');
              print(widget.storage.read(key: 'token'));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
