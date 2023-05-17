import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/widgets/recent_activities.dart';
import 'package:hassan_mortada_social_fitness/widgets/steps.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Activities",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Steps(),
          RecentActivities(),
        ],
      ),
    );
  }
}
