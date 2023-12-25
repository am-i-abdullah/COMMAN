import 'package:comman/widgets/update_card.dart';
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
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome, Taimoor Ikram!',
              textAlign: TextAlign.start,
              style: GoogleFonts.lato(
                fontSize: 22,
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
            const SizedBox(height: 30),
            Text(
              'Some Member Statistics',
              style: GoogleFonts.lato(
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
