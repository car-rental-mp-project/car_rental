import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../sign_up.dart';
import 'package:get/get.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("OR",  style: GoogleFonts.poppins(
          color: Colors.black,
        ),),
        SizedBox(height: 10,),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image.asset("assets/images/google_icon.png", width: 20,),
            onPressed: (){}, label: Text("Sign in with Google",  style: GoogleFonts.poppins(
            color: Colors.blue,
          ),),
            style: ButtonStyleConstants.secondaryButtonStyle,
          ),
        ),
        SizedBox(height: 10,),
        TextButton(onPressed: (){
          // Navigator.pushNamed(context, "/sign_up");
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          Get.to(
                () => SignUpScreen(),
          );
          //todo: add functionality to signup
        },
            child:  Text.rich(
                TextSpan(
                    text: "Don't have an account? ", style: GoogleFonts.poppins(
                  color: Colors.black,
                ),

                    children: [
                      TextSpan(
                        text: "Sign up",
                        style:  GoogleFonts.poppins(
                        color: Colors.blue,
    ),
                      )
                    ]
                )))

      ],
    );
  }
}
