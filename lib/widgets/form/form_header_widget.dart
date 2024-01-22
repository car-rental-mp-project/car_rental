import 'package:flutter/cupertino.dart';

import '../../../utils/utils.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    required this.size, required this.image, required this.title, required this.subtitle, required this.crossAxisAlignment, required this.textAlign,
  });

  final Size size;
  final String image, title, subtitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        SizedBox(height: 30,),
        Image(image: AssetImage(image), height: size.height*0.2,),
        Text(title,style: bigHeading),
        SizedBox(height: 10,),
        Text(subtitle, style: mainHeading, textAlign: textAlign,),
      ],
    );
  }
}
