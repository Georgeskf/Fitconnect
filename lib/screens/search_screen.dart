import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hassan_mortada_social_fitness/screens/profile_screen.dart';
import 'package:hassan_mortada_social_fitness/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool showUsers = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search For User',
            icon: Icon(Icons.search),
            fillColor: Color.fromARGB(100, 200, 200, 200),
            filled: true,
          ),
          onChanged: (String _) {
            setState(() {
              showUsers = _searchController.text.isNotEmpty;
            });
          },
        ),
      ),
      body: showUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where("name", isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(color: primaryColor));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: snapshot.data!.docs[index]['uid'],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: snapshot.data!.docs[index]["photoUrl"] ==
                                  null
                              ? CircleAvatar(
                                  radius: 18,
                                  child: SvgPicture.asset('assets/profile.svg'),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data!.docs[index]['photoUrl']
                                      .toString()),
                                  radius: 18,
                                ),
                          title: Text(snapshot.data!.docs[index]['name']),
                        ),
                      );
                    },
                  );
                }
              },
            )
          : const SizedBox(),
    );
  }
}
