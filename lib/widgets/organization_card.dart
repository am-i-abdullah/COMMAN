import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class OrganizationCard extends StatelessWidget {
  const OrganizationCard({
    super.key,
    required this.tagLine,
    required this.organizationName,
  });

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
            Text(
              'Completion: $completionRate%',
              style: const TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Edit Details",
                        style: TextStyle(color: Colors.white),
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
                      onPressed: () {},
                      child: const Text(
                        "Transfer Control",
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
    );
  }
}
