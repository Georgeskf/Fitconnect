import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/models/user.dart';
import 'package:hassan_mortada_social_fitness/providers/user_provider.dart';
import 'package:hassan_mortada_social_fitness/widgets/chat_list_item.dart';
import 'package:provider/provider.dart';

import '../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        uid: "VVOivXwo7xXMXzhjkoqVa4XeYwZ2",
        name: "Jane Russel",
        messageText: "Awesome Setup",
        imageURL: null,
        time: "Now"),
    ChatUsers(
        uid: "VVOivXwo7xXMXzhjkoqVa4XeYwZ2",
        name: "Glady's Murphy",
        messageText: "That's Great",
        imageURL: null,
        time: "Yesterday"),
    ChatUsers(
        name: "Jorge Henry",
        uid: "VVOivXwo7xXMXzhjkoqVa4XeYwZ2",
        messageText: "Hey where are you?",
        imageURL: null,
        time: "31 Mar"),
    ChatUsers(
        name: "Philip Fox",
        uid: "VVOivXwo7xXMXzhjkoqVa4XeYwZ2",
        messageText: "Busy! Call me in 20 mins",
        imageURL: null,
        time: "28 Mar"),
    ChatUsers(
        name: "Debra Hawkins",
        uid: "VVOivXwo7xXMXzhjkoqVa4XeYwZ2",
        messageText: "Thankyou, It's awesome",
        imageURL: null,
        time: "23 Mar"),
    ChatUsers(
        name: "Jacob Pena",
        uid: "VVOivXwo7xXMXzhjkoqVa4XeYwZ2",
        messageText: "will update you in evening",
        imageURL: null,
        time: "17 Mar"),
    ChatUsers(
        name: "Andrey Jones",
        messageText: "Can you please share the file?",
        imageURL: null,
        uid: "VVOivXwo7xXMXzhjkoqVa4XeYwZ2",
        time: "24 Feb"),
    ChatUsers(
        name: "John Wick",
        uid: "VVOivXwo7xXMXzhjkoqVa4XeYwZ2",
        messageText: "How are you?",
        imageURL: null,
        time: "18 Feb")
  ];

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Chats",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (builder, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.data()!["chats"].length == 0) {
            return const Center(child: Text("Wow look, nothing"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.data()!["chats"].length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatListItem(uid: user.chats[index]);
              },
            );
          }
        },
      ),
    );
  }
}
