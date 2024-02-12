// ignore_for_file: use_build_context_synchronously

import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignEmployeeTask extends ConsumerStatefulWidget {
  const AssignEmployeeTask({
    super.key,
    required this.teamId,
    required this.orgId,
    required this.employeeId,
  });
  final String teamId;
  final String orgId;
  final String employeeId;

  @override
  ConsumerState<AssignEmployeeTask> createState() => _AssignEmployeeTaskState();
}

class _AssignEmployeeTaskState extends ConsumerState<AssignEmployeeTask> {
  final formKey = GlobalKey<FormState>();
  Map<int, String> teamProjects = {};
  var taskName;
  var responsibility;
  var projects;
  var teamTaskId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    Dio dio = Dio();
    String url = 'http://$ipAddress:8000/hrm/team/${widget.teamId}/tasks/';

    try {
      Response response = await dio.get(
        url,
        options: getOpts(ref),
      );

      response = await dio.get(
        url,
        options: getOpts(ref),
      );
      projects = response.data;
      response.data.forEach((teamTask) {
        teamProjects[teamTask['id']] = "${teamTask['responsibility']}";
      });

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('error');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      height: 300,
      width: 300,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Text(
              "Assign Task to the Employee: ",
              style: TextStyle(fontSize: 18),
            ),

            // Task Title input
            TextFormField(
              decoration:
                  const InputDecoration(hintText: "Task Responsibility: "),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    value.length < 10) {
                  return "Add something at least,...";
                }
                return null;
              },
              onSaved: (value) {
                responsibility = value!;
              },
            ),
            const SizedBox(height: 10),
            // team lead selection
            SizedBox(
              width: double.infinity,
              child: (isLoading || teamProjects == {})
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Team Project: "),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : DropdownButton(
                      padding: const EdgeInsets.all(5),
                      borderRadius: BorderRadius.circular(10),
                      value: teamProjects[teamTaskId],
                      isExpanded: true,
                      hint: const Text("Select Team Project: "),
                      items: teamProjects.values
                          .map((username) => DropdownMenuItem<String>(
                                value: username,
                                child: Text(username),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {});
                        if (value == null) return;
                        for (int key in teamProjects.keys) {
                          if (teamProjects[key] == value) teamTaskId = key;
                        }
                      },
                    ),
            ),

            const Expanded(child: SizedBox()),
            if (!isLoading)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: width < 500 ? 110 : 120,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          bool isValid = formKey.currentState!.validate();
                          formKey.currentState!.save();

                          if (isValid) {
                            setState(() {
                              isLoading = true;
                            });

                            print(widget.teamId);
                            print(teamTaskId);
                            print(widget.employeeId);

                            final body = {
                              'team_id': int.parse(widget.teamId),
                              'task_id': teamTaskId,
                              'employee_id': int.parse(widget.employeeId),
                              'details': "$responsibility",
                              'completion_status': false,
                              'date_due': '2024-01-03',
                            };

                            Dio dio = Dio();

                            try {
                              print('sending task to create for the employee');
                              var response = await dio.post(
                                'http://$ipAddress:8000/hrm/duties/',
                                data: body,
                                options: getOpts(ref),
                              );

                              if (response.statusCode == 201 ||
                                  response.statusCode == 200) {
                                showSnackBar(context,
                                    'Task Created for the Employee Successfuly, Good Luck!');
                              }
                              Navigator.pop(context);
                            } catch (error) {
                              showSnackBar(context,
                                  'Oh...! Unlucky to Create Task for the Employee, Sorry :(');
                              print(error);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width < 500 ? 5 : 20),
                    Container(
                      width: width < 500 ? 110 : 120,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
