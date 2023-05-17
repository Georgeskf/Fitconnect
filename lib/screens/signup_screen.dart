import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hassan_mortada_social_fitness/resources/auth_methods.dart';
import 'package:hassan_mortada_social_fitness/resources/method_result.dart';
import 'package:hassan_mortada_social_fitness/screens/layout_screen.dart';
import 'package:hassan_mortada_social_fitness/screens/login_screen.dart';
import 'package:hassan_mortada_social_fitness/utils/utils.dart';
import 'package:hassan_mortada_social_fitness/widgets/text_feild_input.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void selectImage(ImageSource source) async {
    Uint8List image = await pickImage(source);
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    Result res = await AuthMethods().signUpUser(
        email: _emailController.text,
        name: _nameController.text,
        password: _passwordController.text,
        file: _image);

    if (res.success) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LayoutScreen()));
    } else {
      showSnackBar(res.message, context);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Flexible(flex: 2, child: Container()),
                  SvgPicture.asset(
                    "assets/LOGO.svg",
                    height: 96,
                  ),
                  const SizedBox(
                    height: 64,
                    child: Text(
                      'Welcome to ActivPal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: _image == null
                            ? const CircleAvatar(
                                radius: 64,
                                child: Icon(
                                  Icons.person,
                                  size: 64,
                                ),
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () {
                            selectImage(ImageSource.gallery);
                          },
                          icon: const Icon(Icons.photo_library),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        right: 80,
                        child: IconButton(
                          onPressed: () {
                            selectImage(ImageSource.camera);
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ),
                      _image != null
                          ? Positioned(
                              top: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outlined,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFieldInput(
                    textEditingController: _nameController,
                    hintText: 'Enter Your Name',
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Enter Your Email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Enter Your Password',
                    textInputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {
                      if (!isLoading) signUpUser();
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: Color.fromARGB(255, 0, 255, 255),
                      ),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Already Have An Account?"),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (builder) => const LoginScreen()),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 255, 255)),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
