import 'package:cloud_firestore/cloud_firestore.dart';

class SharedStatsModel {
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String? profImage;
  final likes;
  final String steps;
  final String time;
  final String energy;
  final String hrtRate;

  SharedStatsModel({
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.profImage,
    required this.likes,
    required this.steps,
    required this.time,
    required this.energy,
    required this.hrtRate,
  });

  static SharedStatsModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    if (snapshot["isPost"] == true) {
      throw Exception("Must not be an image");
    }

    return SharedStatsModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      profImage: snapshot["profImage"],
      likes: snapshot["like"],
      time: snapshot["time"],
      hrtRate: snapshot["hrtRate"],
      energy: snapshot["energy"],
      steps: snapshot["steps"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
        "time": time,
        "energy": energy,
        "hrtRate": hrtRate,
        "steps": steps,
        "isPost": false
      };
}
