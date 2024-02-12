import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Getting Info...  ',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(width: 5),
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
