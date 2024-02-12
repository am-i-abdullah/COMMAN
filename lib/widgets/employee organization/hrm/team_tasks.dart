// ignore_for_file: use_build_context_synchronously

import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/employee%20organization/hrm/delete_team_task.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TeamTasks extends ConsumerStatefulWidget {
  const TeamTasks({super.key, required this.tasks});
  final tasks;

  @override
  ConsumerState<TeamTasks> createState() => _TeamTasksState();
}

class _TeamTasksState extends ConsumerState<TeamTasks> {
  var content;

  @override
  void initState() {
    super.initState();

    if (widget.tasks.toString() == "[]") {
      content = const Center(
        child: Text(
          "Nothing Pending!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 19),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GridView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 1100
            ? 3
            : width > 700
                ? 2
                : 1,
        childAspectRatio: width < 500 ? 1.25 : 1.75,
        crossAxisSpacing: 0,
        mainAxisSpacing: 12,
      ),
      children: (widget.tasks != null && widget.tasks.isNotEmpty)
          ? [
              for (final task in widget.tasks)
                TeamTask(
                  id: task['id'].toString(),
                  project: task['task']['title'],
                  width: width,
                  date: task['task']['date_due'],
                  status: task['completion_status'],
                  responsibility: task['responsibility'],
                ),
            ]
          : width > 800
              ? [const SizedBox(), content]
              : [content],
    );
  }
}

class TeamTask extends ConsumerWidget {
  const TeamTask({
    super.key,
    required this.id,
    required this.project,
    required this.date,
    required this.responsibility,
    required this.status,
    required this.width,
  });

  final double width;
  final String project;
  final String date;
  final String responsibility;
  final bool status;
  final String id;

  double getResponsiveFontSize(
      BuildContext context, double percentageOfScreenWidth) {
    return MediaQuery.of(context).size.width * percentageOfScreenWidth / 100;
  }

  String convertDate() {
    String inputDate = date;
    DateTime dateTime = DateTime.parse(inputDate);
    return DateFormat('yyyy-MMMM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white12
          : Colors.white54,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              convertDate(),
              style: TextStyle(fontSize: width < 600 ? 14 : 18),
            ),
            Text(
              project,
              softWrap: false,
              style: TextStyle(fontSize: width < 600 ? 20 : 35),
            ),
            Text(
              "Details: $responsibility",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: width < 600 ? 12 : 15),
            ),
            Text(
              'Completion Status: ${status ? 'Completed' : 'Pending'}',
              style: const TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: status
                          ? const Color.fromARGB(150, 255, 235, 59)
                          : Colors.green[400],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Dio dio = Dio();

                        try {
                          print('updating the organization task');
                          var response = await dio.patch(
                            'http://$ipAddress:8000/hrm/task-team/$id/',
                            options: getOpts(ref),
                            data: {
                              'completion_status': !status,
                            },
                          );
                          showSnackBar(context, 'Task Updated Successfully!');
                        } catch (error) {
                          showSnackBar(context,
                              'Sorry, unable to change status, something went wrong.');
                          print('error');
                          print(error);
                        }
                      },
                      child: Text(
                        status ? "Mark Pending" : "Mark Complete",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: DismissTeamTask(
                              taskId: id,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Dismiss Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
