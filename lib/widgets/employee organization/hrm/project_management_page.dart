import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectManagementPage extends ConsumerStatefulWidget {
  const ProjectManagementPage({
    super.key,
    required this.id,
    required this.teamLead,
    required this.teamName,
    required this.employees,
  });

  final String? teamLead;
  final String teamName;
  final employees;
  final int id;
  @override
  ConsumerState<ProjectManagementPage> createState() =>
      _ProjectManagementPageState();
}

class _ProjectManagementPageState extends ConsumerState<ProjectManagementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Text('Team Lead ${widget.teamLead}'),
          const Text('All Employees'),
        ],
      ),
    );
  }
}
