import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/employee%20organization/hrm/delete_team.dart';
import 'package:comman/widgets/employee%20organization/hrm/team_management_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmpOrgTeamCard extends ConsumerStatefulWidget {
  const EmpOrgTeamCard({
    super.key,
    required this.name,
    required this.id,
    required this.teamLead,
    required this.orgId,
    required this.refresh,
  });

  final String name;
  final int id;
  final String? teamLead;
  final int orgId;
  final void Function() refresh;

  @override
  ConsumerState<EmpOrgTeamCard> createState() => _EmpOrgTeamCardState();
}

class _EmpOrgTeamCardState extends ConsumerState<EmpOrgTeamCard> {
  var employees;
  var teamTasks;
  String totalEmployees = 'Loading...';
  String totalTasks = 'Loading...';
  @override
  void initState() {
    super.initState();
    loadTeamDetails();
  }

  void loadTeamDetails() async {
    Dio dio = Dio();
    String url = 'http://$ipAddress:8000/hrm/team/${widget.id}/employees/';

    try {
      Response response = await dio.get(
        url,
        options: getOpts(ref),
      );

      employees = response.data;
      totalEmployees = response.data.length.toString();

      url = 'http://$ipAddress:8000/hrm/team/${widget.id}/tasks/';
      response = await dio.get(
        url,
        options: getOpts(ref),
      );
      teamTasks = response.data;
      totalTasks = response.data.length.toString();

      setState(() {});
    } catch (error) {
      print('error');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TeamManagementPage(
                  employees: employees,
                  tasks: teamTasks,
                  id: widget.id,
                  orgId: widget.orgId,
                  teamLead: widget.teamLead,
                  teamName: widget.name,
                );
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () async {
                      await showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: DeleteEmpOrgTeam(
                            teamId: widget.id,
                          ),
                        ),
                      );

                      widget.refresh();
                    },
                    icon: const Icon(Icons.delete_forever),
                  )
                ],
              ),
              Text(
                'Lead: ${widget.teamLead}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Total Employees: $totalEmployees',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Total Tasks: $totalTasks',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
