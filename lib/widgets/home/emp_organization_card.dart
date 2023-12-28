import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class EmployeeOrganizationCard extends StatelessWidget {
  const EmployeeOrganizationCard({
    super.key,
    required this.id,
    required this.tagLine,
    required this.organizationName,
  });
  final String id;
  final String tagLine;
  final String organizationName;

  double getResponsiveFontSize(
      BuildContext context, double percentageOfScreenWidth) {
    return MediaQuery.of(context).size.width * percentageOfScreenWidth / 100;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final completionRate =
        (70 + Random().nextDouble() * (100 - 70)).toStringAsFixed(2);
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white12
          : Colors.white54,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tagLine,
              style: TextStyle(
                fontSize:
                    getResponsiveFontSize(context, width > 700 ? 1.75 : 6),
              ),
            ),
            Text(
              organizationName,
              style: GoogleFonts.inter(
                fontSize: getResponsiveFontSize(context, width > 700 ? 3.5 : 9),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Team: Machine Learning',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
