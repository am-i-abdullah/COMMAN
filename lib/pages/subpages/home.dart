import 'package:comman/widgets/home/employee_organizations.dart';
import 'package:comman/widgets/home/update_card.dart';
import 'package:comman/widgets/home/user_organizations.dart';
import 'package:comman/widgets/user/user_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // user all notifications
            Text(
              'Recent Notifications',
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            const UserNotifications(only3: true),

            // organizations owned by the user
            const SizedBox(height: 20),
            Text(
              'Your Organizations',
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            const UserOrganizations(),

            // oranizations in which user is employed
            const SizedBox(height: 40),
            Text(
              'Employed in ',
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20),

            const EmployeeOrganizations(),
            const SizedBox(height: 40),

            Text(
              'Your Success Rate',
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20),

            // update cards
            if (width > 600)
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: UpdateCard(color: Color.fromARGB(100, 255, 0, 0)),
                  ),
                  Expanded(
                    child: UpdateCard(color: Color.fromARGB(100, 0, 255, 0)),
                  ),
                ],
              )
            else
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UpdateCard(color: Color.fromARGB(100, 255, 0, 0)),
                  SizedBox(height: 20),
                  UpdateCard(color: Color.fromARGB(100, 0, 255, 0)),
                ],
              ),

            // Member Statistics
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
