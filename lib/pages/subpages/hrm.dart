import 'package:comman/widgets/employee%20organization/hrm/emp_pending_tasks.dart';
import 'package:comman/widgets/employee%20organization/hrm/create_emp_org_task.dart';
import 'package:comman/widgets/employee%20organization/hrm/create_team.dart';
import 'package:comman/widgets/employee%20organization/hrm/emp_org_pending_tasks.dart';
import 'package:comman/widgets/employee%20organization/hrm/emp_own_team.dart';
import 'package:comman/widgets/employee%20organization/hrm/teams.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnerHRM extends StatefulWidget {
  const OwnerHRM({super.key, required this.orgId});
  final String orgId;
  @override
  State<OwnerHRM> createState() => _OwnerHRMState();
}

class _OwnerHRMState extends State<OwnerHRM> {
  void refresh() {}
  @override
  Widget build(BuildContext context) {
    // teams in hrm
    Widget teams = EmployeeOrgTeams(orgId: widget.orgId);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // tasks the user can manage
          Row(
            children: [
              Text(
                'Organization Tasks',
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Expanded(child: SizedBox()),
              const Text('Add Task  '),
              IconButton(
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: NewEmpOrgTask(
                          organizationId: widget.orgId,
                        ),
                      ),
                    );

                    setState(() {});
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          EmpOrgPendingTasks(id: widget.orgId),

          // teams the user can manage
          const SizedBox(height: 40),
          Row(
            children: [
              Text(
                'Teams',
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Expanded(child: SizedBox()),
              const Text('Add Team  '),
              IconButton(
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: NewTeam(
                          organizationId: widget.orgId,
                        ),
                      ),
                    );

                    setState(() {
                      teams = EmployeeOrgTeams(orgId: widget.orgId);
                    });
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          teams,
          const SizedBox(height: 40),

          // // team in which user is
          // Text(
          //   'Your Team',
          //   style: GoogleFonts.inter(
          //     fontSize: 30,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
          // EmpOwnTeam(organizationId: widget.orgId),

          // task user have
          const SizedBox(height: 40),
          Text(
            'Your Tasks',
            style: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          EmployeePendingTasks(id: widget.orgId),
        ],
      ),
    );
  }
}
