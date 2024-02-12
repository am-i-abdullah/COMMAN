// ignore_for_file: use_build_context_synchronously

import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferOrganizationControl extends ConsumerStatefulWidget {
  const TransferOrganizationControl({
    super.key,
    required this.organizationId,
    required this.employees,
  });
  final String organizationId;
  final Map<int, String> employees;

  @override
  ConsumerState<TransferOrganizationControl> createState() => _NewTaskState();
}

class _NewTaskState extends ConsumerState<TransferOrganizationControl> {
  var newOwner;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      height: 150,
      width: 300,
      child: Column(
        children: [
          // Organizaion name input
          SizedBox(
            width: double.infinity,
            child: DropdownButton(
              padding: const EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(10),
              value: newOwner,
              isExpanded: true,
              hint: const Text("Transfer ownership to: "),
              items: widget.employees.values
                  .map((username) => DropdownMenuItem<String>(
                        value: username,
                        child: Text(username),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {});
                if (value == null) return;
                newOwner = value;
              },
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
                      if (newOwner == '' || newOwner.isEmpty) return;
                      showSnackBar(context, 'Select valid Owner');
                      setState(() {
                        isLoading = true;
                      });

                      print('sending transfer control request... ');
                      int id = widget.employees.keys.firstWhere(
                          (element) => widget.employees[element] == newOwner);

                      final body = {
                        'owner_id': id,
                      };

                      Dio dio = Dio();

                      try {
                        var response = await dio.patch(
                          'http://$ipAddress:8000/hrm/organization/${widget.organizationId}/',
                          data: body,
                          options: getOpts(ref),
                        );
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          showSnackBar(
                              context, 'Good Luck for your next Endeavours');
                        }
                        Navigator.pop(context);
                      } catch (error) {
                        showSnackBar(
                            context, 'Good Luck for your next Endeavours');
                        print('error');
                        print(error);
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: const Text(
                      "Transfer",
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
