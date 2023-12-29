import 'package:comman/charts/revenue.dart';
import 'package:comman/widgets/organization/manage_customers.dart';
import 'package:flutter/material.dart';

class EmployeeCRM extends StatefulWidget {
  const EmployeeCRM({super.key, required this.organizationId});

  final String organizationId;

  @override
  State<EmployeeCRM> createState() => _EmployeeCRMState();
}

class _EmployeeCRMState extends State<EmployeeCRM> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // manage customers tasks
            const SizedBox(height: 20),
            const Text(
              'Manage Customers Tasks',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ManageCustomers(id: widget.organizationId),
            ),

            // Revenue Growth
            const SizedBox(height: 20),
            const Text(
              'Revenue Growth',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: SizedBox(
                height: 600,
                child: RevenueChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
