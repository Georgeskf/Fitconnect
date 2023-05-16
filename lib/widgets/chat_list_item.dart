import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/models/user.dart';
import 'package:hassan_mortada_social_fitness/widgets/nullable_avatar.dart';

import '../screens/chat_details.dart';

class ChatListItem extends StatefulWidget {
  String uid;

  ChatListItem({super.key, required this.uid});

  @override
  _ChatListItemState createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  String? image;
  String name = "";
  String lastMessage = "";
  String time = "";

  getUser() async {
    String idFrom = FirebaseAuth.instance.currentUser!.uid;
    String idTo = widget.uid;
    String chatId =
        (idFrom.hashCode <= idTo.hashCode) ? "$idFrom-$idTo" : "$idTo-$idFrom";

    UserModel user = UserModel.fromSnap(await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get());

    var message = (await FirebaseFirestore.instance
            .collection("messages")
            .doc(chatId)
            .collection(chatId)
            .get())
        .docs
        .last
        .data();
    setState(() {
      image = user.photoUrl;
      name = user.name;
      lastMessage = message["content"];
      DateTime messageTime =
          DateTime.fromMicrosecondsSinceEpoch(int.parse(message["timeStamp"].toString()));
      var now = DateTime.now();
      if (DateTime(messageTime.year, messageTime.month, messageTime.day) ==
          DateTime(now.year, now.month, now.day)) {
        time = "${messageTime.hour}:${messageTime.minute}";
      } else {
        time = "${messageTime.day}/${messageTime.month}/${messageTime.year}";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage(uid: widget.uid);
        }));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Avatar(radius: 30, imageURL: image),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            lastMessage,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
