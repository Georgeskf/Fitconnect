import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hassan_mortada_social_fitness/models/user.dart';
import 'package:hassan_mortada_social_fitness/providers/user_provider.dart';
import 'package:hassan_mortada_social_fitness/resources/firestore_methods.dart';
import 'package:hassan_mortada_social_fitness/resources/method_result.dart';
import 'package:hassan_mortada_social_fitness/utils/colors.dart';
import 'package:hassan_mortada_social_fitness/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }
  void postImage(UserModel? user) async {
    setState(() {
      isLoading = true;
    });
    Result res = await FirestoreMethods()
        .uploadPost(_captionController.text, _file!, user!);
    if (res.success) {
      showSnackBar("Successfully Posted Image", context);
      setState(() {
        _file = null;
      });
    } else {
      showSnackBar(res.message, context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              title: const Text(
                "Upload",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  SimpleDialogOption(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: const [
                        Icon(Icons.camera_alt),
                        Padding(padding: EdgeInsets.all(10)),
                        Text("Take a photo"),
                      ],
                    ),
                    onPressed: () async {
                      Uint8List? file = await pickImage(ImageSource.camera);
                      setState(() {
                        _file = file;
                      });
                    },
                  ),
                  SimpleDialogOption(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: const [
                        Icon(Icons.photo_library),
                        Padding(padding: EdgeInsets.all(10)),
                        Text("Choose From Library"),
                      ],
                    ),
                    onPressed: () async {
                      Uint8List? file = await pickImage(ImageSource.gallery);
                      setState(() {
                        _file = file;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _file = null;
                  });
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              title: const Text(
                "Upload",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      postImage(user!);
                    },
                    child: const Text("Post"))
              ],
            ),
            body: Column(
              children: [
                isLoading ? const LinearProgressIndicator() : Container(),
                const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _captionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: MemoryImage(_file!),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
