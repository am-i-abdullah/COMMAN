// ignore_for_file: use_build_context_synchronously

import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _PassowrdChangeState();
}

class _PassowrdChangeState extends ConsumerState<ChangePassword> {
  final formKey = GlobalKey<FormState>();

  String oldPassword = '';
  String newPassword = '';

  bool isLoading = false;

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
            // old password input
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Old Password: "),
                validator: (value) {
                  if (value == null || value.trim().isEmpty || value.isEmpty) {
                    return "Can't be empty,...";
                  }
                  return null;
                },
                onSaved: (value) {
                  oldPassword = value!;
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
                    return "Should be of optimal length.";
                  }
                  return null;
                },
                onSaved: (value) {
                  newPassword = value!;
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
                              'old_password': oldPassword,
                              'new_password': newPassword,
                            };

                            Dio dio = Dio();

                            try {
                              print('sending new org task');
                              var response = await dio.patch(
                                'http://$ipAddress:8000/hrm/user/change-password/',
                                data: body,
                                options: getOpts(ref),
                              );

                              print(response.data);
                              print(response.statusCode);

                              showSnackBar(
                                  context, 'Password Changed Successfully.');
                              Navigator.pop(context);
                            } catch (error) {
                              showSnackBar(context,
                                  'Sorry, unable to change the password');
                              print('error');
                              print(error);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Change",
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
