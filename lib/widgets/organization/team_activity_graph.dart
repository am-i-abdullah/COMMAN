import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamActivityGraph extends StatelessWidget {
  const TeamActivityGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/chart.svg',
        height: 500,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
