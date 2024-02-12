// ignore_for_file: use_build_context_synchronously

import 'package:comman/api/auth/user_auth.dart';
import 'package:comman/models/user_model.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/provider/user_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeleteAccount extends ConsumerStatefulWidget {
  const DeleteAccount({
    super.key,
    required this.userId,
  });
  final int userId;
  @override
  ConsumerState<DeleteAccount> createState() => _UserAccountState();
}

class _UserAccountState extends ConsumerState<DeleteAccount> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordVisible = true;
  String password = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      height: 150,
      width: 300,
      child: Column(
        children: [
          const Text(
            'Enter Password to Delete Account?',
            style: TextStyle(fontSize: 17),
          ),
          Form(
            key: formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password can't be empty!";
                }
                return null;
              },
              onSaved: (value) {
                password = value!;
              },
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: isPasswordVisible,
            ),
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
                      bool isValid = formKey.currentState!.validate();
                      formKey.currentState!.save();

                      if (isValid) {
                        setState(() {
                          isLoading = true;
                        });

                        print('sending delete account request... ');

                        try {
                          // verifying user via password

                          var result = await userAuth(
                              username: ref.read(userProvider).username,
                              password: password);

                          if (result.isEmpty) {
                            showSnackBar(context, 'Wrong Passowrd');
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          Dio dio = Dio();

                          Response response = await dio.delete(
                            'http://$ipAddress:8000/hrm/user/${widget.userId}/',
                            options: getOpts(ref),
                          );

                          // upon deleted successfully
                          if (response.statusCode == 204) {
                            Navigator.pop(context);
                            const FlutterSecureStorage()
                                .write(key: 'token', value: null);
                            ref.watch(tokenProvider.notifier).state = null;
                            ref.read(userProvider.notifier).state = User();
                            showSnackBar(context,
                                'Farewell for now; may your path be filled with joy.');
                          }
                        } catch (error) {
                          showSnackBar(context, 'Something went wrong!');
                          print('error');
                          print(error);
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }

                      setState(() {
                        isLoading = false;
                      });
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
