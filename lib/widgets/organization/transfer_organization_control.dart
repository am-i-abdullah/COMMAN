import 'package:comman/provider/token_provider.dart';
import 'package:comman/utils/constants.dart';
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
  String newOwner = '';
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
              hint: const Text("Transfer ownership to: "),
              items: widget.employees.values
                  .map((username) => DropdownMenuItem<String>(
                        value: username,
                        child: Text(username),
                      ))
                  .toList(),
              onChanged: (value) {
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
