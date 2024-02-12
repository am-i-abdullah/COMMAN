import 'package:comman/api/data_fetching/emp_pending_task.dart';
import 'package:comman/provider/rank_provider.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/provider/user_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/employee%20organization/hrm/team_management_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmpOwnTeam extends ConsumerStatefulWidget {
  const EmpOwnTeam({super.key, required this.organizationId});
  final String organizationId;

  @override
  ConsumerState<EmpOwnTeam> createState() => _EmpOwnTeamState();
}

class _EmpOwnTeamState extends ConsumerState<EmpOwnTeam> {
  bool isloading = true;
  var employeeDetails;
  var totalPendingTasks = 5;
  var teamTasks;
  var teamEmployees;

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  void loadDetails() async {
    Dio dio = Dio();
    String url =
        'http://$ipAddress:8000/hrm/organization/${widget.organizationId}/employees/me';

    try {
      Response response = await dio.get(
        url,
        options: getOpts(ref),
      );

      employeeDetails = response.data;
      var x = await getEmpPendingTasks(
          token: ref.read(tokenProvider.state).state!,
          id: widget.organizationId);

      totalPendingTasks = x!.length;
      setState(() {
        isloading = false;
      });
      print(employeeDetails);

      if (employeeDetails['primary_team'] != null) {
        response = await dio.get(
          'http://$ipAddress:8000/hrm/team/${employeeDetails['primary_team']['id']}/tasks/',
          options: getOpts(ref),
        );

        teamTasks = response.data;

        response = await dio.get(
          'http://$ipAddress:8000/hrm/team/${employeeDetails['primary_team']['id']}/employees/',
          options: getOpts(ref),
        );

        teamEmployees = response.data;
      }

      setState(() {
        isloading = false;
      });
    } catch (error) {
      print('error');
      print(error);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (ref.read(rankProvider.notifier).state == 'Team Lead' &&
            employeeDetails['primary_team'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return TeamManagementPage(
                employees: teamEmployees,
                tasks: teamTasks,
                id: employeeDetails['primary_team']['id'],
                orgId: int.parse(widget.organizationId),
                teamLead: ref.read(userProvider).firstname,
                teamName: employeeDetails['primary_team']['name'],
              );
            }),
          );
        }
      },
      child: Card(
        // Define the shape of the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        // Define how the card's content should be clipped
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // Define the child widget of the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add padding around the row widget
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add an image widget to display an image
                  Image.asset(
                    'assets/cover.jpg',
                    filterQuality: FilterQuality.low,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  // Add some spacing between the image and the text
                  Container(width: 20),
                  // Add an expanded widget to take up the remaining horizontal space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add some spacing between the top of the card and the title
                        Container(height: 5),
                        // Add a title widget
                        Text(
                          !isloading
                              ? "Job Title: ${employeeDetails['rank']['name']}"
                              : 'Job Title: Loading...',
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        // Add some spacing between the title and the subtitle
                        Container(height: 5),
                        // Add a subtitle widget
                        if (!isloading &&
                            employeeDetails['primary_team'] != null)
                          Text(
                            !isloading
                                ? "Team: ${employeeDetails['primary_team']['name']}"
                                : 'Team: Loading...',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                        if (!isloading &&
                            employeeDetails['primary_team'] == null)
                          Text(
                            !isloading ? "Team: None" : 'Team: Loading...',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                        // Add some spacing between the subtitle and the text
                        Container(height: 10),
                        // Add a text widget to display some text
                        Text(
                          !isloading
                              ? "Your Pending Tasks: $totalPendingTasks"
                              : 'Your Pending Tasks: Loading...',
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
