import 'package:comman/provider/rank_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/employee%20organization/hrm/add_employee_team.dart';
import 'package:comman/widgets/employee%20organization/hrm/assign_employee_task.dart';
import 'package:comman/widgets/employee%20organization/hrm/create_team_task.dart';
import 'package:comman/widgets/employee%20organization/hrm/delete_employee_team.dart';
import 'package:comman/widgets/employee%20organization/hrm/team_tasks.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamManagementPage extends ConsumerStatefulWidget {
  const TeamManagementPage({
    super.key,
    required this.id,
    required this.orgId,
    required this.teamLead,
    required this.teamName,
    required this.employees,
    required this.tasks,
  });

  final String? teamLead;
  final String teamName;
  final employees;
  final tasks;
  final int id;
  final int orgId;
  @override
  ConsumerState<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends ConsumerState<TeamManagementPage> {
  var isLoading = true;
  var teamTasks;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              'Team Lead: ${widget.teamLead}',
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),

            // all employees in the team
            const SizedBox(height: 40),
            Row(
              children: [
                Text(
                  'Employees',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Expanded(child: SizedBox()),
                const Text('Add Employee  ', style: TextStyle(fontSize: 20)),
                IconButton(
                    onPressed: () async {
                      await showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: AddEmployeeInTeam(
                            teamId: widget.id.toString(),
                            orgId: widget.orgId.toString(),
                          ),
                        ),
                      );
                      setState(() {});
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: (widget.employees != null &&
                      widget.employees.isNotEmpty)
                  ? [
                      for (final employee in widget.employees)
                        Card(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name: ${employee['user']['first_name']} ${employee['user']['last_name']}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await showDialog<void>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: AssignEmployeeTask(
                                              employeeId:
                                                  employee['id'].toString(),
                                              orgId: widget.orgId.toString(),
                                              teamId: widget.id.toString(),
                                            ),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      child: const Text("Assign Task"),
                                    ),
                                    if (['CEO', 'CFO', 'CTO'].contains(
                                        ref.read(rankProvider.notifier).state))
                                      TextButton(
                                        onPressed: () async {
                                          Dio dio = Dio();
                                          var body = {
                                            'team_lead_id': employee['id'],
                                          };

                                          try {
                                            dio.patch(
                                              'http://$ipAddress:8000/hrm/team/${widget.id}/',
                                              options: getOpts(ref),
                                              data: body,
                                            );
                                            showSnackBar(context,
                                                'Made him/her Team Lead Successfully');
                                          } catch (error) {
                                            print(error);
                                            showSnackBar(context,
                                                'Sorry, Unable to Make Team Lead');
                                          }
                                        },
                                        child: const Text("Make Lead"),
                                      ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed: () async {
                                        await showDialog<void>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: RemoveTeamEmployee(
                                              orgId: widget.orgId,
                                            ),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete_forever),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    ]
                  : [
                      const SizedBox(height: 20),
                      const Text(
                        'No Members in the team so far!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      )
                    ],
            ),

            // all the tasks team has to do
            const SizedBox(height: 40),
            Row(
              children: [
                Text(
                  'Team Tasks',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Expanded(child: SizedBox()),
                const Text('Add Task  ', style: TextStyle(fontSize: 20)),
                IconButton(
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: CreateTeamTask(
                          orgId: widget.orgId.toString(),
                          teamId: widget.id.toString(),
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.add),
                )
              ],
            ),
            TeamTasks(tasks: widget.tasks),
          ],
        ),
      ),
    );
  }
}
