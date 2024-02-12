// ignore_for_file: use_build_context_synchronously
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeInTeam extends ConsumerStatefulWidget {
  const AddEmployeeInTeam({
    super.key,
    required this.teamId,
    required this.orgId,
  });
  final String teamId;
  final String orgId;

  @override
  ConsumerState<AddEmployeeInTeam> createState() => _AddEmployeeInTeamState();
}

class _AddEmployeeInTeamState extends ConsumerState<AddEmployeeInTeam> {
  final formKey = GlobalKey<FormState>();
  Map<int, String> employees = {};

  var employeeId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  void loadEmployees() async {
    Dio dio = Dio();

    try {
      // fetching total employees
      print('fetching employees in org');
      var url =
          'http://$ipAddress:8000/hrm/organization/${widget.orgId}/employees/';
      Response response = await dio.get(
        url,
        options: getOpts(ref),
      );

      print(response.data);
      print(employees);

      response.data.forEach((emp) {
        employees[emp['id']] =
            "${emp['user']['first_name']} ${emp['user']['last_name']} \nEmail: ${emp['user']['email']}";
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
              "Add Employee in Team: ",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),
            // team lead selection
            SizedBox(
              width: double.infinity,
              child: (isLoading)
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Employee to Add: "),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : DropdownButton(
                      padding: const EdgeInsets.all(5),
                      borderRadius: BorderRadius.circular(10),
                      value: employees[employeeId],
                      isExpanded: true,
                      hint: const Text("Select Employee to Add: "),
                      items: employees.values
                          .map((username) => DropdownMenuItem<String>(
                                value: username,
                                child: Text(username),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {});
                        if (value == null) return;
                        for (int key in employees.keys) {
                          if (employees[key] == value) employeeId = key;
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

                          if (isValid) {
                            setState(() {
                              isLoading = true;
                            });
                            final body = {
                              'primary_team_id': int.parse(widget.teamId),
                            };

                            Dio dio = Dio();

                            try {
                              print('sending employee to add in team');
                              var response = await dio.patch(
                                'http://$ipAddress:8000/hrm/employee/$employeeId/',
                                data: body,
                                options: getOpts(ref),
                              );

                              if (response.statusCode == 201 ||
                                  response.statusCode == 200) {
                                showSnackBar(context,
                                    'Added to the Team Successfuly, Good Luck!');
                              }
                              Navigator.pop(context);
                            } catch (error) {
                              showSnackBar(context,
                                  'Oh...! Unlucky to Add to the Team, Sorry :(');
                              print(error);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Done",
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
