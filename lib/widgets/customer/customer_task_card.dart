import 'package:comman/widgets/customer/dismiss_customer_task.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerTaskCard extends StatelessWidget {
  const CustomerTaskCard({
    super.key,
    required this.id,
    required this.details,
    required this.name,
    required this.status,
    required this.updateTask,
    required this.deleteTask,
    required this.dueDate,
  });
  final String id;
  final String details;
  final String name;
  final String dueDate;
  final bool status;
  final void Function(int, bool) updateTask;
  final void Function(int) deleteTask;

  double getResponsiveFontSize(
      BuildContext context, double percentageOfScreenWidth) {
    return MediaQuery.of(context).size.width * percentageOfScreenWidth / 100;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white12
          : Colors.white54,
      shadowColor: Colors.black,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Date: $dueDate',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                name,
                softWrap: false,
                style: GoogleFonts.inter(
                  fontSize: width > 600 ? 35 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                details,
                style: TextStyle(
                  fontSize: width > 600 ? 20 : 15,
                ),
              ),
              Text(
                'Completion Status: ${status ? 'Completed' : 'Pending'}',
                style: const TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: status
                            ? const Color.fromARGB(150, 255, 235, 59)
                            : Colors.green[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          updateTask(int.parse(id), status);
                        },
                        child: Text(
                          status ? "Mark Pending" : "Mark Complete",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: DismissCustomerTask(
                                taskId: id,
                                deleteTask: deleteTask,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Dismiss Task",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
