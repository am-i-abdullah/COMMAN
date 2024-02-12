// ignore_for_file: use_build_context_synchronously

import 'package:comman/models/user_model.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/provider/user_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:comman/widgets/user/delete_account.dart';
import 'package:comman/widgets/user/password_change.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSettings extends ConsumerStatefulWidget {
  const UserSettings({super.key});

  @override
  ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userProvider.notifier).state;

    String username = '';
    String firstname = '';
    String lastname = '';
    // String password = '';
    String email = '';

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        width: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // username input
              TextFormField(
                initialValue: user.username,
                decoration: const InputDecoration(
                  label: Text("Username: "),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 6) {
                    return "Should be at least 6...";
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value!;
                },
              ),

              // firstname input
              TextFormField(
                initialValue: user.firstname,
                decoration: const InputDecoration(
                  label: Text("First Name: "),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Can't be empty...";
                  }
                  return null;
                },
                onSaved: (value) {
                  firstname = value!;
                },
              ),

              // lastname input
              TextFormField(
                initialValue: user.lastname,
                decoration: const InputDecoration(
                  label: Text("Last Name: "),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Can't be empty...";
                  }
                  return null;
                },
                onSaved: (value) {
                  lastname = value!;
                },
              ),

              // email input
              TextFormField(
                initialValue: user.email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("Email: "),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return "Enter valid email address.";
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),

              const SizedBox(height: 30),
              if (!isLoading)
                Column(
                  children: [
                    // update user details
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: TextButton(
                        child: const Text(
                          "Update My Details",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          bool isValid = formKey.currentState!.validate();
                          formKey.currentState!.save();

                          if (user.firstname == firstname &&
                              user.lastname == lastname &&
                              user.email == email &&
                              user.username == username) {
                            showSnackBar(context,
                                'Nothing Changed... :), Useless Request, Save Energy ');
                            return;
                          }

                          if (isValid) {
                            print('valid');
                            setState(() {
                              isLoading = true;
                            });
                            final body = {
                              'username': username,
                              'first_name': firstname,
                              'last_name': lastname,
                              'email': email,
                            };

                            Dio dio = Dio();

                            try {
                              print('sending user updated details');
                              var response = await dio.patch(
                                'http://$ipAddress:8000/hrm/user/${user.id}/',
                                data: body,
                                options: getOpts(ref),
                              );

                              if (response.statusCode == 200) {
                                user.email = email;
                                user.lastname = lastname;
                                user.firstname = firstname;
                                user.username = username;

                                showSnackBar(context,
                                    "Keep account info updated for smooth experience!");
                              }
                            } catch (error) {
                              print(error);
                              if (error.toString().contains('400')) {
                                showSnackBar(
                                    context, "Duplicate Username or Email :( ");
                              }
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // change password
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 252, 164, 3),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => const AlertDialog(
                              content: ChangePassword(),
                            ),
                          );
                        },
                        child: const Text(
                          "Change Password",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // delete Account
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: DeleteAccount(
                                userId: user.id,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // logout user
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          ref.read(tokenProvider.state).state = null;
                          await const FlutterSecureStorage()
                              .write(key: 'token', value: null);
                        },
                        child: const Text(
                          "Logout Account",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              if (isLoading)
                const Column(
                  children: [
                    SizedBox(height: 70),
                    CircularProgressIndicator(),
                    SizedBox(height: 70),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
