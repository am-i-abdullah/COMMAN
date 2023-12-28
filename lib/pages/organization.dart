import 'package:comman/widgets/organization/highlights.dart';
import 'package:comman/widgets/organization/manage_customers.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(storage: null),
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // pending tasks
            const Text(
              'Pending Tasks!',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            const PendingTasks(),

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
      ),
    );
  }
}
