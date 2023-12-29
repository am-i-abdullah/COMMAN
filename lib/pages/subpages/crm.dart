import 'package:comman/charts/revenue.dart';
import 'package:comman/widgets/organization/manage_customers.dart';
import 'package:flutter/material.dart';

class CRM extends StatefulWidget {
  const CRM({super.key, required this.organizationId});

  final String organizationId;

  @override
  State<CRM> createState() => _CRMState();
}

class _CRMState extends State<CRM> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            ManageCustomers(id: widget.organizationId),

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
            const RevenueChart(),
          ],
        ),
      ),
    );
  }
}
