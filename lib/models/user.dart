import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final List followers;
  final List following;
  final List chats;

  UserModel(
      {required this.uid,
      required this.email,
      required this.name,
      required this.photoUrl,
      required this.followers,
      required this.following,
      required this.chats});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        name: snapshot["name"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        followers: snapshot["followers"],
        following: snapshot["following"],
        chats: snapshot["chats"]);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "followers": followers,
        "following": following,
        "chats": chats
      };
}
