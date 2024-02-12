// ignore_for_file: use_build_context_synchronously
import 'package:comman/api/data_fetching/org_pending_task.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTeamTask extends ConsumerStatefulWidget {
  const CreateTeamTask({
    super.key,
    required this.teamId,
    required this.orgId,
  });
  final String teamId;
  final String orgId;

  @override
  ConsumerState<CreateTeamTask> createState() => _CreateTeamTaskState();
}

class _CreateTeamTaskState extends ConsumerState<CreateTeamTask> {
  final formKey = GlobalKey<FormState>();
  Map<int, String> orgPendingTasks = {};
  var taskName;
  var responsibility;

  var projectId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      var response = await getOrgPendingTasks(
          token: ref.read(tokenProvider.state).state!, id: widget.orgId);

      print(response);
      print('fine till here');

      if (response != null) {
        for (var project in response) {
          orgPendingTasks[project['id']] = "${project['title']}";
        }
      }
    } catch (error) {
      showSnackBar(context, 'Something went wrong');
      print(error);
    }

    setState(() {
      isLoading = false;
    });
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
              "Create Task for the Team: ",
              style: TextStyle(fontSize: 18),
            ),
            // Task Title input
            TextFormField(
              decoration: const InputDecoration(hintText: "Task Name: "),
              validator: (value) {
                if (value == null || value.trim().isEmpty || value.length < 2) {
                  return "Add something at least,...";
                }
                return null;
              },
              onSaved: (value) {
                taskName = value!;
              },
            ),
            const SizedBox(height: 10),

            // Team Title input
            TextFormField(
              decoration:
                  const InputDecoration(hintText: "Team Responsibility: "),
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
              child: (isLoading || orgPendingTasks == {})
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Project: "),
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
                      value: orgPendingTasks[projectId],
                      isExpanded: true,
                      hint: const Text("Select Project: "),
                      items: orgPendingTasks.values
                          .map((username) => DropdownMenuItem<String>(
                                value: username,
                                child: Text(username),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {});
                        if (value == null) return;
                        for (int key in orgPendingTasks.keys) {
                          if (orgPendingTasks[key] == value) projectId = key;
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
                            final body = {
                              'team_id': int.parse(widget.teamId),
                              'task_id': projectId,
                              'responsibility': "$responsibility",
                            };

                            Dio dio = Dio();

                            try {
                              print('sending task to create for the team');
                              var response = await dio.post(
                                'http://$ipAddress:8000/hrm/tasks-team/',
                                data: body,
                                options: getOpts(ref),
                              );

                              if (response.statusCode == 201 ||
                                  response.statusCode == 200) {
                                showSnackBar(context,
                                    'Task Created for the Team Successfuly, Good Luck!');
                              }
                              Navigator.pop(context);
                            } catch (error) {
                              showSnackBar(context,
                                  'Oh...! Unlucky to Create Task for the Team, Sorry :(');
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
