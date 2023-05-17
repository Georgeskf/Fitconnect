import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String uid;
  final String caption;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String? profImage;
  final likes;

  PostModel(
      {required this.uid,
      required this.caption,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.likes});

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    if (snapshot["isPost"] == false) {
      throw Exception("Must be an image");
    }

    return PostModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      caption: snapshot["caption"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot["postUrl"],
      profImage: snapshot["profImage"],
      likes: snapshot["like"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "caption": caption,
        "postId": postId,
        "postUrl": postUrl,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
        "isPost": true
      };
}
