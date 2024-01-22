import 'package:car_rent/Screens/login/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:car_rent/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/form/form_header_widget.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: 50,),
              FormHeaderWidget(
                  size: size, image: password,
                  title: "Forgot Password?",
                  subtitle: "Worry not. Enter your Email to receive a reset OTP code",
                crossAxisAlignment: CrossAxisAlignment.center,
                textAlign: TextAlign.center,),
             
              SizedBox(height: 20,),
              Form(child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),

                      )
                    )
                  ),
                  SizedBox(height: 20,),
                  SizedBox(width: double.infinity,
                    child: ElevatedButton(onPressed: (){
                      Get.to(()=>OTPScreen());

                    }, child:Text(
                      'SEND',  style:whiteHeading,

                    ), style: ButtonStyleConstants.primaryButtonStyle,),
                  )
                ],

              ))
            ]
          )
        ),
      ),
    );
  }
}
