import 'package:comman/pages/subpages/notifications.dart';
import 'package:comman/provider/rank_provider.dart';
import 'package:comman/provider/theme_provider.dart';
import 'package:comman/widgets/employee%20organization/emp_crm.dart';
import 'package:comman/widgets/employee%20organization/emp_hrm.dart';
import 'package:comman/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmpOrgMainPage extends ConsumerStatefulWidget {
  const EmpOrgMainPage({
    super.key,
    required this.orgId,
    required this.name,
    required this.rank,
  });

  final String orgId;
  final String name;
  final String rank;

  @override
  ConsumerState<EmpOrgMainPage> createState() => _EmpOrgMainPageState();
}

class _EmpOrgMainPageState extends ConsumerState<EmpOrgMainPage> {
  var content;

  @override
  void initState() {
    super.initState();
    setRank();
  }

  void setRank() async {
    ref.read(rankProvider.notifier).state = widget.rank;
  }

  @override
  Widget build(BuildContext context) {
    var icon = (ref.watch(themeProvider)) ? Icons.light_mode : Icons.dark_mode;

    return Scaffold(
      drawer: SideBar(orgId: widget.orgId),
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
                content = EmployeeHRM(orgId: widget.orgId);
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
                content = EmployeeHRM(
                  orgId: widget.orgId,
                );
              });
            },
            icon: const Icon(Icons.group),
          ),

          // CRM buttom
          if (widget.rank == 'CFO' ||
              widget.rank == 'CEO' ||
              widget.rank == 'CTO')
            IconButton(
              onPressed: () {
                setState(() {
                  content = EmployeeCRM(
                    organizationId: widget.orgId,
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
      body: content ?? EmployeeHRM(orgId: widget.orgId),
    );
  }
}
