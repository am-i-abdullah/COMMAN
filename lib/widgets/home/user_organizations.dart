import 'package:comman/api/data_fetching/get_user_orgs.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/widgets/home/organization_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserOrganizations extends ConsumerStatefulWidget {
  const UserOrganizations({super.key});

  @override
  ConsumerState<UserOrganizations> createState() => _UserOrganizationsState();
}

class _UserOrganizationsState extends ConsumerState<UserOrganizations> {
  var orgs;
  var content;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() async {
    content = const Center(child: CircularProgressIndicator());
    orgs =
        await getUserOrganizations(token: ref.read(tokenProvider.state).state!);

    if (orgs.toString() == '[]') {
      content = const Center(
        child: Text(
          "You don't own any Organization, \nEscape the matrix soon and, \nyou'll see a list here!",
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
        childAspectRatio: width < 500 ? 1.4 : 1.75,
        crossAxisSpacing: 0,
        mainAxisSpacing: 12,
      ),
      children: (orgs != null && orgs.isNotEmpty)
          ? [
              for (final org in orgs)
                OrganizationCard(
                  id: org['id'].toString(),
                  tagLine: "We'll find the best for you.",
                  organizationName: org['name'],
                  refresh: loadData,
                ),
            ]
          : [if (width > 700) const SizedBox(), content],
    );
  }
}
