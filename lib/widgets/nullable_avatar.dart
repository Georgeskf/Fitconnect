import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final String? imageURL;

  const Avatar({Key? key, required this.radius, required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageURL == null
        ? CircleAvatar(
            radius: radius,
            backgroundColor: primaryColor,
            child: SvgPicture.asset('assets/profile.svg'),
          )
        : CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(imageURL!),
          );
  }
}
