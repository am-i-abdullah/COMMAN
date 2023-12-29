import 'package:comman/widgets/employee%20organization/emp_pending_tasks.dart';
import 'package:flutter/material.dart';

class EmployeeHRM extends StatefulWidget {
  const EmployeeHRM({super.key, required this.orgId});
  final String orgId;
  @override
  State<EmployeeHRM> createState() => _EmployeeHRMState();
}

class _EmployeeHRMState extends State<EmployeeHRM> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        EmployeePendingTasks(id: widget.orgId),
        const Text('teams you can manage'),
        const Text('tasks you can manage'),
        const Text('team you are in'),
        const Text('tasks pending'),
      ]),
    );
  }
}
