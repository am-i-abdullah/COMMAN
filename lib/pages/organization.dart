import 'package:comman/pages/subpages/crm.dart';
import 'package:comman/pages/subpages/hrm.dart';
import 'package:comman/pages/subpages/notifications.dart';
import 'package:comman/provider/theme_provider.dart';
import 'package:comman/widgets/organization/org_dashboard.dart';
import 'package:comman/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Organization extends ConsumerStatefulWidget {
  const Organization({
    super.key,
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  ConsumerState<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends ConsumerState<Organization> {
  var content;

  @override
  Widget build(BuildContext context) {
    var icon = (ref.watch(themeProvider)) ? Icons.light_mode : Icons.dark_mode;

    return Scaffold(
      drawer: SideBar(
        orgId: widget.id,
      ),
      appBar: AppBar(
        // page tiltle
        centerTitle: true,
        title: InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(
              () {
                content = OrganizationDashboard(id: widget.id);
              },
            );
          },
          child: Text(
            widget.name,
            style: const TextStyle(fontSize: 30),
          ),
        ),

        // remaining navigation buttons
        actions: [
          // Home/ dashboard button
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: const Icon(Icons.home),
          ),

          // HRM
          IconButton(
            onPressed: () {
              setState(() {
                content = OwnerHRM(
                  orgId: widget.id,
                );
              });
            },
            icon: const Icon(Icons.group),
          ),

          // CRM buttom
          IconButton(
            onPressed: () {
              setState(() {
                content = CRM(
                  organizationId: widget.id,
                );
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
          // change theme button
          IconButton(
            onPressed: () {
              toggleTheme(ref);
            },
            icon: Icon(icon),
          ),
          const SizedBox(width: 10),
        ],
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: content ?? OrganizationDashboard(id: widget.id),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.background
          : Colors.white54,
    );
  }
}
