import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hassan_mortada_social_fitness/models/post.dart';
import 'package:hassan_mortada_social_fitness/models/user.dart';
import 'package:hassan_mortada_social_fitness/resources/method_result.dart';
import 'package:hassan_mortada_social_fitness/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MethodResult> uploadPost(
      String caption, Uint8List file, UserModel user) async {
    try {
      String photoUrl = await StorageMethods().uploadImage('posts', file, true);

      String postId = const Uuid().v1();

      PostModel post = PostModel(
          uid: user.uid,
          caption: caption,
          username: user.name,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: user.photoUrl,
          likes: []);

      _firestore.collection("posts").doc(postId).set(post.toJson());
    } catch (err) {
      stdout.writeln(err.toString());
      return MethodResult(success: false, message: err.toString());
    }
    return MethodResult(success: true, message: "Success");
  }
}
