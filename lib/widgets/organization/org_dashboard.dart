import 'package:comman/charts/revenue.dart';
import 'package:comman/charts/team_graph.dart';
import 'package:comman/widgets/home/update_card.dart';
import 'package:comman/widgets/organization/manage_customers.dart';
import 'package:comman/widgets/organization/new_org_task.dart';
import 'package:comman/widgets/organization/pending_tasks.dart';
import 'package:flutter/material.dart';

class OrganizationDashboard extends StatefulWidget {
  const OrganizationDashboard({super.key, required this.id});

  final String id;

  @override
  State<OrganizationDashboard> createState() => _OrganizationDashboardState();
}

class _OrganizationDashboardState extends State<OrganizationDashboard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
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
            'Team Activity Completion %',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 40),

          const SizedBox(
            height: 300,
            width: double.infinity,
            child: TeamGraph(),
          ),

          // team activity graph
          const SizedBox(height: 60),
          const Text(
            'Revenue Generation!',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: SizedBox(
              height: 500,
              child: RevenueChart(),
            ),
          ),

          // highlights
          // const SizedBox(height: 40),
          const Text(
            'Highlights',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 20),
          // update cards
          if (width > 600)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: UpdateCard(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(100, 255, 0, 0)
                          : const Color.fromARGB(255, 241, 108, 108)),
                ),
                Expanded(
                  child: UpdateCard(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(100, 0, 255, 0)
                          : const Color.fromARGB(255, 106, 235, 150)),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UpdateCard(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(100, 255, 0, 0)
                        : const Color.fromARGB(255, 241, 108, 108)),
                const SizedBox(height: 20),
                UpdateCard(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(100, 0, 255, 0)
                        : const Color.fromARGB(255, 106, 235, 150)),
              ],
            ),

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
}
