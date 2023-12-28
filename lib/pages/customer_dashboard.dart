import 'package:comman/provider/token_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/customer/customer_task_card.dart';
import 'package:comman/widgets/customer/new_task.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomerDashboard extends ConsumerStatefulWidget {
  const CustomerDashboard({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.organizationId,
    required this.customerId,
  });

  final String firstname;
  final String lastname;
  final String organizationId;
  final int customerId;

  @override
  ConsumerState<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends ConsumerState<CustomerDashboard> {
  var tasks;
  bool isEmpty = true;
  var content;
  // due date for new task
  DateTime? dueDate;
  final formatter = DateFormat('yyyy-MM-dd').format;

  @override
  void initState() {
    super.initState();
    content = const Center(child: CircularProgressIndicator());
    readTask();
  }

  void readTask() async {
    content = const Center(child: CircularProgressIndicator());
    Dio dio = Dio();
    tasks = '[]';

    try {
      print('getting all tasks');
      var response = await dio.get(
        'http://$ipAddress:8000/crm/customer/tasks/${widget.customerId}/',
        options: Options(
          headers: {
            "Authorization": "Bearer ${ref.read(tokenProvider.state).state}",
          },
        ),
      );

      print(response.data);
      if (response.data.toString() == '[]') {
        content = Center(
          child: TextButton(
            onPressed: createTask,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(15),
              child: const Text(
                "There are no Tasks, \nClick me to Add new Task",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }
      tasks = response.data;
      if (response.data == []) tasks = null;
    } catch (error) {
      print('error');
      print(error);
    }

    setState(() {});
  }

  // adding task
  void createTask() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: NewTask(
          organizationId: widget.organizationId,
          customerId: widget.customerId,
        ),
      ),
    );

    readTask();
    setState(() {});
  }

  void deleteTask(int id) async {
    Dio dio = Dio();

    try {
      print('deleting the task');
      var response = await dio.delete(
        'http://$ipAddress:8000/hrm/task/$id/',
        options: Options(
          headers: {
            "Authorization": "Bearer ${ref.read(tokenProvider.state).state}",
          },
        ),
      );

      print(response.data);
      tasks = response.data;
    } catch (error) {
      print('error');
      print(error);
    }

    tasks = '[]';
    readTask();
    setState(() {});
  }

  void updateTask(int id, bool status) async {
    Dio dio = Dio();

    try {
      print('updating the task');
      var response = await dio.patch(
        'http://$ipAddress:8000/hrm/task/$id/',
        options: Options(
          headers: {
            "Authorization": "Bearer ${ref.read(tokenProvider.state).state}",
          },
        ),
        data: {
          'completion_status': !status,
        },
      );

      print(response.data);
      tasks = response.data;
    } catch (error) {
      print('error');
      print(error);
    }
    tasks = '[]';
    readTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.firstname} ${widget.lastname}"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: createTask,
            icon: const Icon(
              Icons.add,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          GridView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width > 900
                  ? 3
                  : width > 700
                      ? 2
                      : 1,
              childAspectRatio: width < 500 ? 1.25 : 1.75,
              crossAxisSpacing: 0,
              mainAxisSpacing: 12,
            ),
            children: (tasks.toString() != '[]')
                ? [
                    for (final task in tasks)
                      CustomerTaskCard(
                        id: task['id'].toString(),
                        details: task['details'],
                        name: task['title'],
                        status: task['completion_status'],
                        dueDate: task['date_due'],
                        updateTask: updateTask,
                        deleteTask: deleteTask,
                      ),
                  ]
                : [if (width > 700) const SizedBox(), content],
          ),
        ],
      ),
    );
  }
}
