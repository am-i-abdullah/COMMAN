import 'package:comman/pages/organization.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/utils/responsive_font.dart';
import 'package:comman/widgets/organization/transfer_organization_control.dart';
import 'package:comman/widgets/organization/update_organization_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class OrganizationCard extends ConsumerStatefulWidget {
  const OrganizationCard({
    super.key,
    required this.id,
    required this.tagLine,
    required this.organizationName,
    required this.refresh,
  });
  final String id;
  final String tagLine;
  final String organizationName;
  final void Function() refresh;

  @override
  ConsumerState<OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends ConsumerState<OrganizationCard> {
  Map<int, String> orgEmployees = {};
  var totalOrgEmployees;

  double getResponsiveFontSize(
      BuildContext context, double percentageOfScreenWidth) {
    return MediaQuery.of(context).size.width * percentageOfScreenWidth / 100;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    Dio dio = Dio();

    Map<String, String> body = {
      "Authorization": "Bearer ${ref.read(tokenProvider.state).state}",
    };

    try {
      // fetching total employees
      var url =
          'http://$ipAddress:8000/hrm/organization/${widget.id}/employees/';
      Response response = await dio.get(url, options: Options(headers: body));

      print(response.data);

      response.data.forEach((emp) {
        orgEmployees[emp['user']['id']] = emp['user']['username'];
      });

      totalOrgEmployees = response.data.length;
      setState(() {});
    } catch (error) {
      print('error');
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final completionRate =
        (70 + Random().nextDouble() * (100 - 70)).toStringAsFixed(2);
    final revnue = (-100 + Random().nextDouble() * (500)).toStringAsFixed(2);

    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white12
          : Colors.white54,
      shadowColor: Colors.black,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Organization(
                id: widget.id,
                name: widget.organizationName,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Number of Employees: ${totalOrgEmployees ?? ''}',
                style: TextStyle(
                  fontSize:
                      getResponsiveFontSize(context, width > 700 ? 1.5 : 5),
                ),
              ),
              Text(
                'Last Quarter Revnue: \$${revnue}M USD',
                style: TextStyle(
                  fontSize:
                      getResponsiveFontSize(context, width > 700 ? 1.3 : 4),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.organizationName,
                softWrap: false,
                style: GoogleFonts.inter(
                  fontSize:
                      getResponsiveFontSize(context, width > 700 ? 3.5 : 9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Completion: $completionRate%',
                style: TextStyle(
                  fontSize:
                      getResponsiveFontSize(context, width > 700 ? 1.4 : 4.5),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(180, 102, 187, 106),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: UpdateOrganizationDetails(
                                organizationId: widget.id,
                              ),
                            ),
                          );

                          widget.refresh();
                        },
                        child: Text(
                          "Edit Details",
                          style: TextStyle(
                            fontSize: getResponsiveFontSize(
                                context, width > 700 ? 1.35 : 3.5),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: TransferOrganizationControl(
                                employees: orgEmployees,
                                organizationId: widget.id,
                              ),
                            ),
                          );

                          widget.refresh();
                        },
                        child: Text(
                          "Transfer Control",
                          style: TextStyle(
                            fontSize: getResponsiveFontSize(
                                context, width > 700 ? 1.35 : 3.5),
                            color: Colors.white,
                          ),
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
