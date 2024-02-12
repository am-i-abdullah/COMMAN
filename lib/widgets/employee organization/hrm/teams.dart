// ignore_for_file: use_build_context_synchronously

import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/employee%20organization/hrm/emp_org_team.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeOrgTeams extends ConsumerStatefulWidget {
  const EmployeeOrgTeams({super.key, required this.orgId});
  final String orgId;
  @override
  ConsumerState<EmployeeOrgTeams> createState() => _EmployeeOrgTeamsState();
}

class _EmployeeOrgTeamsState extends ConsumerState<EmployeeOrgTeams> {
  var teams;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  void loadTeams() async {
    Dio dio = Dio();
    String url =
        'http://$ipAddress:8000/hrm/organization/${widget.orgId}/teams/';

    try {
      Response response = await dio.get(
        url,
        options: getOpts(ref),
      );

      teams = response.data;
    } catch (error) {
      showSnackBar(context, 'Something went wrong');
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: (teams != null && teams.isNotEmpty)
          ? [
              for (final team in teams)
                EmpOrgTeamCard(
                  name: team['name'],
                  id: team['id'],
                  teamLead: team['team_lead'] != null
                      ? "${team['team_lead']['user']['first_name']} ${team['team_lead']['user']['last_name']}"
                      : 'None',
                  orgId: team['organization']['id'],
                  refresh: loadTeams,
                )
            ]
          : isLoading
              ? [const Center(child: CircularProgressIndicator())]
              : [
                  const SizedBox(height: 20),
                  const Text(
                    'No Teams in the Organization',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  )
                ],
    );
  }
}
