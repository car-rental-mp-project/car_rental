import 'package:car_rent/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,


            children: [
              Text("CO\nDE",style: GoogleFonts.montserrat( fontSize: 80, fontWeight: FontWeight.bold,)),
              Text("Verification", style: mainHeading,),
              SizedBox(height: 10,),
              Text("Enter the verification code sent", textAlign: TextAlign.center, style: subHeading,),
              SizedBox(height: 20,),

              OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                onSubmit: (code){

                  print("OTP is" + code);

                },

              ),
              SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(onPressed: (){}, child: Text("NEXT", style: whiteHeading,),
                    style: ButtonStyleConstants.blackButtonStyle,)),


            ],

          )

      )
    );
  }
}
