// ignore_for_file: use_build_context_synchronously

import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DismissTeamTask extends ConsumerStatefulWidget {
  const DismissTeamTask({
    super.key,
    required this.taskId,
  });
  final String taskId;
  @override
  ConsumerState<DismissTeamTask> createState() => _DismissTeamTaskState();
}

class _DismissTeamTaskState extends ConsumerState<DismissTeamTask> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      height: 100,
      width: 300,
      child: Column(
        children: [
          const Text(
            'Are you sure want to delete?',
            style: TextStyle(fontSize: 20),
          ),
          const Expanded(child: SizedBox()),
          if (!isLoading)
            Row(
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
                      setState(() {
                        isLoading = true;
                      });

                      print('sending delete task request... ');

                      try {
                        Dio dio = Dio();
                        await dio.delete(
                          'http://$ipAddress:8000/hrm/task-team/${widget.taskId}/',
                          options: getOpts(ref),
                        );
                        showSnackBar(context, 'Task deleted from the list.');
                        Navigator.pop(context);
                      } catch (error) {
                        showSnackBar(context, 'Sorry, something went wrong.');
                        print(error);
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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
          if (isLoading) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
