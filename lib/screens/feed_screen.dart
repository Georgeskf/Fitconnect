import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/widgets/post_card.dart';

import '../widgets/stats_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Feed",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .orderBy("datePublished", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.data!.docs[index].data()["isPost"] == true) {
                    return PostCard(snap: snapshot.data!.docs[index].data());
                  } else {
                    return StatsCard(snap: snapshot.data!.docs[index].data());
                  }
                });
          }),
    );
  }
}
