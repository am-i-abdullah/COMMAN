import 'package:flutter/material.dart';

class Highlights extends StatelessWidget {
  const Highlights({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    var highlight = Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white12
          : Colors.white54,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'December 31st, 2023',
              style: TextStyle(fontSize: width < 600 ? 15 : 25),
            ),
            Text(
              'PKR 15.5M ',
              style: TextStyle(
                fontSize: width < 600 ? 20 : 45,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Salary Payment Left',
              style: TextStyle(
                fontSize: width < 600 ? 17 : 35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    return GridView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 600 ? 2 : 1,
        childAspectRatio: width < 600 ? 2 : 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 12,
      ),
      children: [highlight, highlight, highlight],
    );
  }
}
