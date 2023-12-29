import 'package:comman/provider/token_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateOrganizationDetails extends ConsumerStatefulWidget {
  const UpdateOrganizationDetails({
    super.key,
    required this.organizationId,
  });
  final String organizationId;

  @override
  ConsumerState<UpdateOrganizationDetails> createState() => _NewTaskState();
}

class _NewTaskState extends ConsumerState<UpdateOrganizationDetails> {
  final formKey = GlobalKey<FormState>();

  String newName = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      height: 150,
      width: 300,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // Organizaion name input
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration:
                    const InputDecoration(hintText: "New Organization Name: "),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 2) {
                    return "Add something at least,...";
                  }
                  return null;
                },
                onSaved: (value) {
                  newName = value!;
                },
              ),
            ),

            const Expanded(child: SizedBox()),
            if (!isLoading)
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
                        bool isValid = formKey.currentState!.validate();
                        if (!isValid) return;
                        formKey.currentState!.save();
                        setState(() {
                          isLoading = true;
                        });

                        if (isValid) {
                          final body = {
                            'name': newName,
                          };

                          Dio dio = Dio();

                          try {
                            print('sending update name request... ');
                            var response = await dio.patch(
                              'http://$ipAddress:8000/hrm/organization/${widget.organizationId}/',
                              data: body,
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
                        "Update Name",
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

            if (isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
