import 'package:comman/api/data_fetching/get_emp_orgs.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/widgets/home/emp_organization_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeOrganizations extends ConsumerStatefulWidget {
  const EmployeeOrganizations({super.key});

  @override
  ConsumerState<EmployeeOrganizations> createState() =>
      _UserOrganizationsState();
}

class _UserOrganizationsState extends ConsumerState<EmployeeOrganizations> {
  var orgs;
  var content;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    content = const Center(child: CircularProgressIndicator());
    orgs = await getEmployeeOrgs(token: ref.read(tokenProvider.state).state!);
    if (orgs.toString() == '[]') {
      content = const Center(
        child: Text(
          "Not a part of any, \nWhen you join other organizations, \nyou'll see those here!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 19),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GridView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 1100
            ? 3
            : width > 720
                ? 2
                : 1,
        childAspectRatio: width < 500 ? 1.6 : 1.75,
        crossAxisSpacing: 0,
        mainAxisSpacing: 12,
      ),
      children: (orgs != null && orgs.isNotEmpty)
          ? [
              for (final org in orgs)
                EmployeeOrganizationCard(
                  id: org['id'].toString(),
                  tagLine: "rank",
                  organizationName: org['name'],
                  refresh: loadData,
                ),
            ]
          : [if (width > 700) const SizedBox(), content],
    );
  }
}
