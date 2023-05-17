import 'package:flutter/material.dart';

class RecentActivities extends StatelessWidget {
  RecentActivities({Key? key}) : super(key: key);

  final List activities = [
    'Running',
    'Swimming',
    'Hiking',
    'Walking',
    'Cycling'
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) => ActivityItem(
                activity: activities[index],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class ActivityItem extends StatelessWidget {
  String activity;

  ActivityItem({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 0, 255, 255),
            ),
            height: 55,
            width: 55,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/running.jpg'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          const SizedBox(width: 20),
          Text(
            activity,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Expanded(child: SizedBox()),
          const Icon(Icons.timer, size: 16),
          const SizedBox(width: 5),
          const Text(
            '30min',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.wb_sunny_outlined, size: 16),
          const SizedBox(width: 5),
          const Text(
            '55kcal',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
