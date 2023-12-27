import 'package:comman/widgets/organization_card.dart';
import 'package:flutter/material.dart';

class UserOrganizations extends StatefulWidget {
  const UserOrganizations({super.key});

  @override
  State<UserOrganizations> createState() => _UserOrganizationsState();
}

class _UserOrganizationsState extends State<UserOrganizations> {
  @override
  void initState() {
    super.initState();

    print('Init method called');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GridView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 900
            ? 3
            : width > 700
                ? 2
                : 1,
        childAspectRatio: width < 500 ? 1.25 : 1.75,
        crossAxisSpacing: 0,
        mainAxisSpacing: 12,
      ),
      children: const [
        OrganizationCard(
            tagLine: "We'll find the best for you.",
            organizationName: 'PriceGram'),
        OrganizationCard(
            tagLine: "We'll find the best for you.",
            organizationName: 'PriceGram'),
        OrganizationCard(
            tagLine: "We'll find the best for you.",
            organizationName: 'PriceGram'),
        OrganizationCard(
            tagLine: "We'll find the best for you.",
            organizationName: 'PriceGram'),
        OrganizationCard(
            tagLine: "We'll find the best for you.",
            organizationName: 'PriceGram'),
        OrganizationCard(
            tagLine: "We'll find the best for you.",
            organizationName: 'PriceGram'),
        OrganizationCard(
            tagLine: "We'll find the best for you.",
            organizationName: 'PriceGram'),
      ],
    );
  }
}
