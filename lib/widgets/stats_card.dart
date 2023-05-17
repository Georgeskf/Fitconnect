import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/widgets/stats.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../screens/comment_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import 'nullable_avatar.dart';

class StatsCard extends StatefulWidget {
  final snap;

  const StatsCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  int _commentLen = 0;

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      _commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCommentLen();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  uid: widget.snap['uid'],
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  Avatar(radius: 16, imageURL: widget.snap["profImage"]),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: widget.snap['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: " wants to share their progress",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text("Total Steps: ${widget.snap['steps']}",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 10),
          Stats(
              time: widget.snap['time'],
              hrtRate: widget.snap['hrtRate'],
              energy: widget.snap['energy']),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await FirestoreMethods().likePost(
                      widget.snap['postId'], user.uid, widget.snap['likes']);
                },
                icon: widget.snap['likes'].contains(user!.uid)
                    ? const Icon(
                        Icons.thumb_up,
                        color: primaryColor,
                      )
                    : const Icon(
                        Icons.thumb_up_alt_outlined,
                      ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CommentsScreen(postId: widget.snap['postId'])));
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(' ${widget.snap['likes'].length} likes'),
                SizedBox(
                  width: double.infinity,
                  child: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black), children: []),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('View all $_commentLen comments',
                        style: const TextStyle(color: Colors.black)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(color: Colors.black)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
