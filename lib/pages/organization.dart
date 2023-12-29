import 'package:comman/pages/subpages/crm.dart';
import 'package:comman/pages/subpages/hrm.dart';
import 'package:comman/pages/subpages/notifications.dart';
import 'package:comman/widgets/organization/highlights.dart';
import 'package:comman/widgets/organization/manage_customers.dart';
import 'package:comman/widgets/organization/new_org_task.dart';
import 'package:comman/widgets/organization/pending_tasks.dart';
import 'package:comman/widgets/organization/team_activity_graph.dart';
import 'package:comman/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class Organization extends StatefulWidget {
  const Organization({
    super.key,
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  var home;
  var content;

  @override
  void initState() {
    super.initState();
    home = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // pending tasks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pending Tasks!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'New Task  ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: NewOrganizationTask(
                            organizationId: widget.id,
                          ),
                        ),
                      );
                      setState(() {
                        print('rebuilding');
                        PendingTasks(id: widget.id);
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          PendingTasks(id: widget.id),

          // team activity graph
          const SizedBox(height: 20),
          const Text(
            'Team Activity Graph!',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          const TeamActivityGraph(),

          // highlights
          const SizedBox(height: 20),
          const Text(
            'Highlights',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          const Highlights(),

          // manage customers
          const SizedBox(height: 20),
          const Text(
            'Manage Customers',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          ManageCustomers(id: widget.id),
        ],
      ),
    );
  }

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
                content = home;
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
                content = const HRM();
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
        ],
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: content ?? home,
    );
  }
}
