// ignore_for_file: use_build_context_synchronously

import 'package:comman/api/data_fetching/emp_pending_task.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/employee%20organization/hrm/dismiss_employee_task.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EmployeePendingTasks extends ConsumerStatefulWidget {
  const EmployeePendingTasks({super.key, required this.id});
  final String id;

  @override
  ConsumerState<EmployeePendingTasks> createState() => _PendingTasksState();
}

class _PendingTasksState extends ConsumerState<EmployeePendingTasks> {
  var tasks;
  var content;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    content = const Center(child: CircularProgressIndicator());
    tasks = await getEmpPendingTasks(
      token: ref.read(tokenProvider.state).state!,
      id: widget.id,
    );

    if (tasks.toString() == '[]') {
      content = const Center(
        child: Text(
          "Nothing pending..., \nEnjoy!",
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
      children: (tasks != null && tasks.isNotEmpty)
          ? [
              for (final task in tasks)
                EmployeePendingTask(
                  id: task['id'].toString(),
                  title: task['task']['responsibility'],
                  width: width,
                  date: task['date_due'],
                  details: task['details'],
                  status: task['completion_status'],
                  refresh: getData,
                ),
            ]
          : width > 800
              ? [const SizedBox(), content]
              : [content],
    );
  }
}

class EmployeePendingTask extends ConsumerWidget {
  const EmployeePendingTask({
    super.key,
    required this.id,
    required this.width,
    required this.title,
    required this.date,
    required this.details,
    required this.status,
    required this.refresh,
  });

  final double width;
  final String title;
  final String date;
  final String details;
  final bool status;
  final String id;
  final void Function() refresh;

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
              title,
              softWrap: false,
              style: TextStyle(fontSize: width < 600 ? 20 : 35),
            ),
            Text(
              "Details: $details",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: width < 600 ? 12 : 17),
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
                            'http://$ipAddress:8000/hrm/duty/$id/',
                            options: getOpts(ref),
                            data: {
                              'completion_status': !status,
                            },
                          );
                          showSnackBar(
                              context, 'Task Status Updated Successfully');
                          refresh();
                        } catch (error) {
                          showSnackBar(context, 'Sorry, something went wrong');
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
                            content: DismissEmployeeTask(
                              taskId: id,
                            ),
                          ),
                        );

                        refresh();
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
