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

  Future<Result> uploadPost(
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
      return Result(success: false, message: err.toString());
    }
    return Result(success: true, message: "Success");
  }

  Future<Result> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      stdout.writeln(err.toString());
      return Result(success: true, message: err.toString());
    }
    return Result(success: true, message: 'Success');
  }

  Future<Result> postComment(String postId, String text, UserModel user) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': user.photoUrl,
          'name': user.name,
          'uid': user.uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        return Result(success: false, message: 'Please enter text');
      }
    } catch (err) {
      return Result(success: false, message: err.toString());
    }
    return Result(success: true, message: 'Success');
  }
}
