import 'package:comman/provider/token_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NewTask extends ConsumerStatefulWidget {
  const NewTask({
    super.key,
    required this.organizationId,
    required this.customerId,
  });
  final String organizationId;
  final int customerId;

  @override
  ConsumerState<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends ConsumerState<NewTask> {
  final formKey = GlobalKey<FormState>();

  String title = '';
  String details = '';

  // due date for new task
  DateTime? dueDate;
  final formatter = DateFormat('yyyy-MM-dd');

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
      dueDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      height: 250,
      width: 300,
      child: Form(
        key: formKey,
        child: Column(
          children: [
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
                Text(dueDate == null
                    ? 'Select Date'
                    : formatter.format(dueDate!)),
                FormField(
                  validator: (value) {
                    if (value == null) {
                      return "Due date can't be null";
                    }
                    return null;
                  },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 120,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      bool isValid = true;
                      // bool isValid = formKey.currentState!.validate();
                      formKey.currentState!.save();

                      if (isValid) {
                        final body = {
                          'title': title,
                          'completion_status': false,
                          'details': details,
                          'date_due': formatter.format(dueDate!),
                          'organization_id': 3,
                        };

                        Dio dio = Dio();

                        try {
                          print('sending new task');
                          var response = await dio.post(
                            'http://$ipAddress:8000/hrm/tasks/',
                            data: body,
                            options: Options(
                              headers: {
                                "Authorization":
                                    "Bearer ${ref.read(tokenProvider.state).state}",
                              },
                            ),
                          );

                          await dio.post(
                            'http://$ipAddress:8000/crm/tasks/',
                            data: {
                              'customer_id': widget.customerId.toString(),
                              'task_id': response.data['id'].toString(),
                            },
                            options: Options(
                              headers: {
                                "Authorization":
                                    "Bearer ${ref.read(tokenProvider.state).state}",
                              },
                            ),
                          );

                          print(response);
                          Navigator.pop(context);
                        } catch (error) {
                          print('error');
                          print(error);
                        }
                      }
                    },
                    child: const Text(
                      "Submit Task",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 120,
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
          ],
        ),
      ),
    );
  }
}


    // await showDialog<void>(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Stack(
    //       clipBehavior: Clip.none,
    //       children: [
    //         Positioned(
    //           right: -40,
    //           top: -40,
    //           child: InkResponse(
    //             onTap: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const CircleAvatar(
    //               backgroundColor: Colors.red,
    //               child: Icon(Icons.close),
    //             ),
    //           ),
    //         ),
    //         Form(
    //           key: formKey,
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(8),
    //                 child: TextFormField(
    //                   decoration: const InputDecoration(hintText: "Title: "),
    //                   validator: (value) {
    //                     if (value == null ||
    //                         value.trim().isEmpty ||
    //                         value.length < 4) {
    //                       return "Add something at least,...";
    //                     }
    //                     return null;
    //                   },
    //                   onSaved: (value) {
    //                     title = value!;
    //                   },
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8),
    //                 child: TextFormField(
    //                   decoration: const InputDecoration(hintText: "Details: "),
    //                 ),
    //               ),

    //               // Calendar Stuff
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   Text(
    //                     dueDate == null
    //                         ? 'Select Date:'
    //                         : formatter.format(dueDate!),
    //                   ),
    //                   // Calendar Button
    //                   IconButton(
    //                     onPressed: () {
    //                       datePicker();
    //                     },
    //                     icon: const Icon(
    //                       Icons.calendar_month,
    //                     ),
    //                   )
    //                 ],
    //               ),

    //               // form submit button
    //               Padding(
    //                 padding: const EdgeInsets.all(8),
    //                 child: ElevatedButton(
    //                   child: const Text('Submitß'),
    //                   onPressed: () {
    //                     if (formKey.currentState!.validate()) {
    //                       formKey.currentState!.save();

    //                       print(title);
    //                       print(formatter.format(dueDate!));
    //                     }
    //                   },
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );