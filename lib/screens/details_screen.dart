import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/models/user.dart';
import 'package:hassan_mortada_social_fitness/providers/user_provider.dart';
import 'package:hassan_mortada_social_fitness/resources/firestore_methods.dart';
import 'package:hassan_mortada_social_fitness/resources/method_result.dart';
import 'package:hassan_mortada_social_fitness/widgets/dates.dart';
import 'package:hassan_mortada_social_fitness/widgets/graph.dart';
import 'package:hassan_mortada_social_fitness/widgets/stats.dart';
import 'package:hassan_mortada_social_fitness/widgets/steps_view.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class DetailsScreen extends StatelessWidget {
  String steps;

  DetailsScreen({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    String timeMin = formatNumber(randBetween(0, 60));
    String timeSec = formatNumber(randBetween(0, 60));
    String hrtRate = formatNumber(randBetween(0, 300));
    String energy = formatNumber(randBetween(0, 300));
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Steps",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Result res = await FirestoreMethods()
                  .shareStats(user!, steps, "$timeMin:$timeSec", hrtRate, energy);
              if (res.success) {
                showSnackBar("Successfuly shared", context);
              } else {
                showSnackBar(res.message, context);
              }
            },
            icon: const Icon(
              Icons.share,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Dates(),
          StepsView(steps: steps),
          const Graph(),
          Stats(time: "$timeMin:$timeSec", energy: energy, hrtRate: hrtRate),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
