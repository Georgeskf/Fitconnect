import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hassan_mortada_social_fitness/models/post.dart';
import 'package:hassan_mortada_social_fitness/models/shared_stats.dart';
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

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      stdout.writeln(e.toString());
    }
  }

  Future<void> sendMessage(String content, String idFrom, String idTo) async {
    try {
      String chatId = (idFrom.hashCode <= idTo.hashCode)
          ? "$idFrom-$idTo"
          : "$idTo-$idFrom";

      DateTime now = DateTime.now();

      _firestore
          .collection('messages')
          .doc(chatId)
          .collection(chatId)
          .doc(now.microsecondsSinceEpoch.toString())
          .set({
        'content': content,
        'idFrom': idFrom,
        'idTo': idTo,
        'timeStamp': now.microsecondsSinceEpoch.toString()
      });

      DocumentSnapshot snap =
          await _firestore.collection('users').doc(idFrom).get();
      List chats = (snap.data()! as dynamic)['chats'];

      if (!chats.contains(idTo)) {
        await _firestore.collection('users').doc(idFrom).update({
          'chats': FieldValue.arrayUnion([idTo]),
        });

        await _firestore.collection('users').doc(idTo).update({
          'chats': FieldValue.arrayUnion([idFrom])
        });
      }
    } catch (e, stack) {
      stdout.writeln(stack);
    }
  }

  Future<Result> shareStats(UserModel user, String steps, String time,
      String hrtRate, String energy) async {
    try {
      String postId = const Uuid().v1();

      SharedStatsModel stats = SharedStatsModel(
          uid: user.uid,
          username: user.name,
          postId: postId,
          datePublished: DateTime.now(),
          profImage: user.photoUrl,
          likes: [],
          steps: steps,
          time: time,
          energy: energy,
          hrtRate: hrtRate);

      _firestore.collection("posts").doc(postId).set(stats.toJson());
    } catch (e, stack) {
      stdout.writeln(stack.toString());
      return Result(success: false, message: e.toString());
    }
    return Result(success: true, message: "Success");
  }
}
