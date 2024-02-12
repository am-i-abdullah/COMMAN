// ignore_for_file: use_build_context_synchronously
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewOrganizationEmployee extends ConsumerStatefulWidget {
  const NewOrganizationEmployee({
    super.key,
    required this.organizationId,
  });
  final String organizationId;

  @override
  ConsumerState<NewOrganizationEmployee> createState() =>
      _NewOrganizationEmployeeState();
}

class _NewOrganizationEmployeeState
    extends ConsumerState<NewOrganizationEmployee> {
  final formKey = GlobalKey<FormState>();
  Map<int, String> ranks = {};

  String usernameOrEmail = '';
  var rankId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRanks();
  }

  void loadRanks() async {
    Dio dio = Dio();

    try {
      // fetching total employees
      print('fetching ranks in org');
      var url = 'http://$ipAddress:8000/hrm/roles/';
      Response response = await dio.get(
        url,
        options: getOpts(ref),
      );

      print(response.data);
      print(ranks);

      response.data['results'].forEach((rank) {
        ranks[rank['id']] = "${rank['name']}";
      });
    } catch (error) {
      showSnackBar(context, 'Something went wrong');
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              "Kindly Fill the Employee Details",
              style: TextStyle(fontSize: 18),
            ),
            // Team Title input
            TextFormField(
              decoration:
                  const InputDecoration(hintText: "Username or Email: "),
              validator: (value) {
                if (value == null || value.trim().isEmpty || value.length < 2) {
                  return "Add something at least,...";
                }
                return null;
              },
              onSaved: (value) {
                usernameOrEmail = value!;
              },
            ),
            const SizedBox(height: 10),
            // team lead selection
            SizedBox(
              width: double.infinity,
              child: DropdownButton(
                padding: const EdgeInsets.all(5),
                borderRadius: BorderRadius.circular(10),
                value: ranks[rankId],
                isExpanded: true,
                hint: const Text("Select Rank: "),
                items: ranks.values
                    .map((username) => DropdownMenuItem<String>(
                          value: username,
                          child: Text(username),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {});
                  if (value == null) return;
                  for (int key in ranks.keys) {
                    if (ranks[key] == value) rankId = key;
                  }
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
                          print(rankId);
                          if (isValid) {
                            setState(() {
                              isLoading = true;
                            });
                            final body = {
                              'username': usernameOrEmail,
                              'organization_id':
                                  int.parse(widget.organizationId),
                              'rank_id': rankId,
                              'primary_team_id': null,
                              'contact_number': '019283013'
                            };

                            Dio dio = Dio();

                            try {
                              print('sending new employee');
                              var response = await dio.post(
                                'http://$ipAddress:8000/hrm/organization/employee/add/',
                                data: body,
                                options: getOpts(ref),
                              );

                              if (response.statusCode == 201 ||
                                  response.statusCode == 200) {
                                showSnackBar(context,
                                    'Employee Added Successfuly, Good Luck!');
                              }
                              Navigator.pop(context);
                            } catch (error) {
                              showSnackBar(context,
                                  'Oh...! Unlucky to Add Employee, Sorry :(');
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
