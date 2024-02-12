import 'package:comman/provider/token_provider.dart';
import 'package:comman/provider/user_provider.dart';
import 'package:comman/widgets/employee%20organization/hrm/add_employee_organization.dart';
import 'package:comman/widgets/employee%20organization/hrm/create_team.dart';
import 'package:comman/widgets/employee%20organization/hrm/fire_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SideBar extends ConsumerStatefulWidget {
  const SideBar({super.key, required this.orgId});
  final String orgId;
  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  @override
  Widget build(BuildContext context) {
    var userDetails = ref.read(userProvider.state).state;
    final width = MediaQuery.of(context).size.width;

    return Drawer(
      width: width > 500 ? 350 : width * 0.875,
      child: Column(
        children: [
          Stack(
            children: [
              UserAccountsDrawerHeader(
                margin: const EdgeInsets.only(bottom: 0),
                accountName: Text(
                  '${userDetails.firstname} ${userDetails.lastname}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                accountEmail: Text(
                  userDetails.email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
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
                  color: Theme.of(context).colorScheme.onBackground,
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
              // visible only if CEO, CFO, CTO
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Add Employee"),
                onTap: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: NewOrganizationEmployee(
                        organizationId: widget.orgId,
                      ),
                    ),
                  );
                },
              ),
              // visible only if CEO, CFO, CTO
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text("Fire Employee"),
                onTap: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: FireEmployee(
                        organizationId: widget.orgId,
                      ),
                    ),
                  );
                },
              ),
              // visible only if CEO, CFO, CTO
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Add Team"),
                onTap: () async {
                  await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: NewTeam(
                        organizationId: widget.orgId,
                      ),
                    ),
                  );
                },
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

          const Expanded(child: SizedBox()),
          ListTile(
            trailing: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              ref.read(tokenProvider.state).state = null;
              await const FlutterSecureStorage()
                  .write(key: 'token', value: null);
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
