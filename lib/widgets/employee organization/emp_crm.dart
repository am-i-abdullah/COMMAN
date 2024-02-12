import 'package:comman/charts/revenue.dart';
import 'package:comman/widgets/organization/manage_customers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // dashboard heading
            const SizedBox(height: 20),
            Text(
              'CRM Dashboard',
              style: GoogleFonts.inter(
                fontSize: 37.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            // manage customers
            const SizedBox(height: 20),
            Text(
              'Manage Customers',
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            ManageCustomers(id: widget.organizationId),

            // Revenue Growth
            const SizedBox(height: 20),
            Text(
              'Revenue Growth',
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w700,
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
