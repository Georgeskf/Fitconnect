import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/models/user.dart';
import 'package:hassan_mortada_social_fitness/resources/auth_result.dart';
import 'package:hassan_mortada_social_fitness/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async{
    DocumentSnapshot snap = await _firestore.collection("users").doc(_auth.currentUser!.uid).get();

    return UserModel.fromSnap(snap);
  }


  Future<AuthResult> signUpUser(
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

      UserModel user = UserModel(uid: credential.user!.uid, email: email, name: name, photoUrl: photoUrl!, followers: [], following: []);

      await _firestore.collection("users").doc(credential.user!.uid).set(user.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
      stdout.writeln(res);
      return AuthResult(success: false, message: res);
    }
    return AuthResult(success: true, message: "Success");
  }

  Future<AuthResult> loginUser({required String email, required String password}) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return AuthResult(success: true, message: "Result");
    }catch(err){
      return AuthResult(success: false, message: err.toString());
    }
  }
}
