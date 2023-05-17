import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/screens/details_screen.dart';

import '../utils/utils.dart';

class Steps extends StatelessWidget {
  const Steps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String steps = formatNumber(randBetween(3000, 6000));
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => DetailsScreen(steps: steps)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  steps,
                  style: const TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Total Steps',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5),
            const Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
