import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Sign up
  Future<String> signUpUser(
      {required String email,
      required String name,
      required String password,
      Uint8List? file}) async {
    String res = "An Error has Occured";
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String? photoUrl;

      if (file != null) {
        photoUrl = await StorageMethods().uploadImage("profilePics", file, false);
      }
      stdout.writeln(credential.user!.uid);
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'name': name,
        'uid': credential.user!.uid,
        'email': email,
        'followers': [],
        'following': [],
        'photoUrl': photoUrl
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
