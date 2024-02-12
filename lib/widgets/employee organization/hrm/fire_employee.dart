// ignore_for_file: use_build_context_synchronously
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FireEmployee extends ConsumerStatefulWidget {
  const FireEmployee({
    super.key,
    required this.organizationId,
  });
  final String organizationId;

  @override
  ConsumerState<FireEmployee> createState() => _FireEmployeeState();
}

class _FireEmployeeState extends ConsumerState<FireEmployee> {
  final formKey = GlobalKey<FormState>();
  Map<int, String> employees = {};

  String teamName = '';
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
          'http://$ipAddress:8000/hrm/organization/${widget.organizationId}/employees/';
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
      height: 200,
      width: 300,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Text(
              "Fill the form for New Team",
              style: TextStyle(fontSize: 18),
            ),

            // select employee to fire
            SizedBox(
              width: double.infinity,
              child: (isLoading)
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Employee: "),
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
                      hint: const Text("Select Employee: "),
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

                            Dio dio = Dio();

                            print(employeeId);

                            try {
                              print('sending new team');
                              var response = await dio.delete(
                                'http://$ipAddress:8000/hrm/employee/$employeeId/',
                                options: getOpts(ref),
                              );

                              if (response.statusCode == 201 ||
                                  response.statusCode == 204 ||
                                  response.statusCode == 200) {
                                showSnackBar(
                                    context, 'Employee Fired, Das Sadddddddd');
                              }
                              Navigator.pop(context);
                            } catch (error) {
                              showSnackBar(context,
                                  'Oh...! Unlucky to Fire Employee, Sorry :(');
                              print(error);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Fire",
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
