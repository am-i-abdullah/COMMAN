import 'package:flutter/material.dart';

class UpdateCard extends StatelessWidget {
  const UpdateCard({super.key, required this.color});
  final color;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 3,
      color: color,
      child: Container(
        width: width > 600 ? width * 0.45 : double.infinity,
        padding: const EdgeInsets.only(
          left: 20,
          top: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '20-Dec-2023',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'XXX-234',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Customers Services Left',
              style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '10% more than last month.',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
