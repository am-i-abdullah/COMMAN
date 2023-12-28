import 'package:comman/api/data_fetching/org_pending_task.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PendingTasks extends ConsumerStatefulWidget {
  const PendingTasks({super.key});

  @override
  ConsumerState<PendingTasks> createState() => _PendingTasksState();
}

class _PendingTasksState extends ConsumerState<PendingTasks> {
  var tasks;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    tasks =
        await getOrgPendingTasks(token: ref.read(tokenProvider.state).state!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GridView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 600 ? 2 : 1,
        childAspectRatio: width > 600 ? 2 : 1.3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 12,
      ),
      children: (tasks != null && tasks.isNotEmpty)
          ? [
              for (final task in tasks)
                PendingTask(
                  title: task['title'],
                  width: width,
                  date: task['date_due'],
                  details: task['details'],
                ),
            ]
          : [const Center(child: CircularProgressIndicator())],
    );
  }
}

class PendingTask extends StatelessWidget {
  const PendingTask({
    super.key,
    required this.width,
    required this.title,
    required this.date,
    required this.details,
  });

  final double width;
  final String title;
  final String date;
  final String details;

  String convertDate() {
    String inputDate = date;
    DateTime dateTime = DateTime.parse(inputDate);
    return DateFormat('yyyy-MMMM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white12
          : Colors.white54,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              convertDate(),
              style: TextStyle(fontSize: width < 600 ? 15 : 20),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: width < 600 ? 20 : 35,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Detaisl: $details",
              style: TextStyle(
                fontSize: width < 600 ? 15 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    padding: EdgeInsets.all(width > 600 ? 5 : 0),
                    child: TextButton(
                      clipBehavior: Clip.none,
                      onPressed: () {},
                      child: const Text(
                        'Mark Completed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
