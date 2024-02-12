// ignore_for_file: use_build_context_synchronously

import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NewEmpOrgTask extends ConsumerStatefulWidget {
  const NewEmpOrgTask({
    super.key,
    required this.organizationId,
  });
  final String organizationId;

  @override
  ConsumerState<NewEmpOrgTask> createState() => _NewTaskState();
}

class _NewTaskState extends ConsumerState<NewEmpOrgTask> {
  final formKey = GlobalKey<FormState>();

  String title = '';
  String details = '';

  // due date for new task
  DateTime dueDate = DateTime.now();
  final formatter = DateFormat('yyyy-MM-dd');

  bool isLoading = false;

  void datePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 10, now.month, now.day);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: lastDate,
    );

    setState(() {
      dueDate = selectedDate ?? DateTime.now();
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
              "Fill the form for new task",
              style: TextStyle(fontSize: 18),
            ),
            // Title input
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Title: "),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 2) {
                    return "Add something at least,...";
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
            ),

            // details input
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Details: "),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 4) {
                    return "Are these enough details? 🙄";
                  }
                  return null;
                },
                onSaved: (value) {
                  details = value!;
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(formatter.format(dueDate)),
                FormField(
                  builder: (context) {
                    return IconButton(
                      onPressed: datePicker,
                      icon: const Icon(Icons.calendar_month_sharp),
                    );
                  },
                )
              ],
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
                              'title': title,
                              'completion_status': false,
                              'details': details,
                              'date_due': formatter.format(dueDate),
                              'organization_id': widget.organizationId,
                            };

                            Dio dio = Dio();

                            try {
                              print('sending new task');
                              var response = await dio.post(
                                'http://$ipAddress:8000/hrm/tasks/',
                                data: body,
                                options: getOpts(ref),
                              );

                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                showSnackBar(context,
                                    "Task Added Successfully, Good Luck");
                              }

                              Navigator.pop(context);
                            } catch (error) {
                              showSnackBar(
                                  context, "Something went wrong.... :( ");
                              print(error);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Submit",
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
