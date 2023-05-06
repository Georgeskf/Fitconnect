import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final List followers;
  final List following;

  UserModel(
      {required this.uid,
      required this.email,
      required this.name,
      required this.photoUrl,
      required this.followers,
      required this.following});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot["name"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "uid": uid,
    "email": email,
    "photoUrl": photoUrl,
    "followers": followers,
    "following": following,
  };
}
