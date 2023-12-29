import 'package:comman/pages/subpages/notifications.dart';
import 'package:comman/widgets/employee%20organization/emp_crm.dart';
import 'package:comman/widgets/employee%20organization/emp_hrm.dart';

import 'package:comman/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class EmpOrgMainPage extends StatefulWidget {
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
  State<EmpOrgMainPage> createState() => _EmpOrgMainPageState();
}

class _EmpOrgMainPageState extends State<EmpOrgMainPage> {
  var content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(storage: null),
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
              widget.rank == 'Director' ||
              widget.rank == 'Assistant Director')
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
