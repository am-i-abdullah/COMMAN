import 'package:comman/provider/token_provider.dart';
import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/employee%20organization/emp_org_main_page.dart';
import 'package:comman/widgets/organization/leave_organization.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeOrganizationCard extends ConsumerStatefulWidget {
  const EmployeeOrganizationCard({
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
  ConsumerState<EmployeeOrganizationCard> createState() =>
      _EmployeeOrganizationCardState();
}

class _EmployeeOrganizationCardState
    extends ConsumerState<EmployeeOrganizationCard> {
  var rank;
  var team;

  double getResponsiveFontSize(
      BuildContext context, double percentageOfScreenWidth) {
    return MediaQuery.of(context).size.width * percentageOfScreenWidth / 100;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    Dio dio = Dio();

    Map<String, String> body = {
      "Authorization": "Bearer ${ref.read(tokenProvider.state).state}",
    };

    try {
      // fetching rank
      var url =
          'http://$ipAddress:8000/hrm/employee/organization/${widget.id}/rank/';
      Response response = await dio.get(url, options: Options(headers: body));
      rank = response.data['name'];
      setState(() {});

      // fetching team
      url =
          'http://$ipAddress:8000/hrm/employee/organization/${widget.id}/team/';
      response = await dio.get(url, options: Options(headers: body));
      team = response.data['name'];

      setState(() {});
    } catch (error) {
      print('error');
      print(error);
    }
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmpOrgMainPage(
                orgId: widget.id,
                name: widget.organizationName,
                rank: rank,
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
                'Your Rank: ${rank ?? ''}',
                style: TextStyle(
                  fontSize:
                      getResponsiveFontSize(context, width > 700 ? 1.75 : 6),
                ),
              ),
              Text(
                widget.organizationName,
                style: GoogleFonts.inter(
                  fontSize:
                      getResponsiveFontSize(context, width > 700 ? 3.5 : 9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Team: ${team ?? ''}',
                style: const TextStyle(fontSize: 18),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: LeaveOrganization(
                          organizationName: widget.organizationName,
                          organizationId: widget.id,
                        ),
                      ),
                    );

                    widget.refresh();
                  },
                  child: Text(
                    "Leave Organization",
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(
                          context, width > 700 ? 1.3 : 4.5),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
