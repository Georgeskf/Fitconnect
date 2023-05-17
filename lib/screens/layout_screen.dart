import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/models/user.dart';
import 'package:hassan_mortada_social_fitness/providers/user_provider.dart';
import 'package:hassan_mortada_social_fitness/resources/auth_methods.dart';
import 'package:hassan_mortada_social_fitness/screens/activities_screen.dart';
import 'package:hassan_mortada_social_fitness/screens/add_post_screen.dart';
import 'package:hassan_mortada_social_fitness/screens/chats_screen.dart';
import 'package:hassan_mortada_social_fitness/screens/feed_screen.dart';
import 'package:hassan_mortada_social_fitness/screens/profile_screen.dart';
import 'package:hassan_mortada_social_fitness/screens/search_screen.dart';
import 'package:hassan_mortada_social_fitness/utils/colors.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    addData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int value) {
    setState(() {
      _page = value;
    });
  }

  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  void navigateTo(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          const ChatScreen(),
          const ActivitiesScreen(),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _page == 0 ? primaryColor : Colors.grey, size: 36),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : Colors.grey, size: 36),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outlined,
                  color: _page == 2 ? primaryColor : Colors.grey, size: 36),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat,
                  color: _page == 3 ? primaryColor : Colors.grey, size: 36),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.area_chart,
                  color: _page == 4 ? primaryColor : Colors.grey, size: 36),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _page == 5 ? primaryColor : Colors.grey, size: 36),
              label: ''),
        ],
        onTap: navigateTo,
      ),
    );
  }
}
