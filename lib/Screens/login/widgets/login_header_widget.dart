import 'package:flutter/cupertino.dart';

import '../../../utils/utils.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30,),
        Image(image: AssetImage(appLogo), height: size.height*0.2,),
        Text("Welcome Back,",style: bigHeading),
        SizedBox(height: 5,),
        Text("Let's get you a ride.", style: mainHeading,),
      ],
    );
  }
}
