import 'dart:async';

import 'package:car_rent/Screens/login/authentication_functions.dart';
import 'package:car_rent/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/utils.dart';

class MailVerification extends StatelessWidget {
  const MailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(

          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 60,),
            Icon(Icons.mail_outline_outlined, size: 100, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Verify your Email',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,

            ),
            SizedBox(height: 20),
            Text(
              'We have sent you an email to verify your email address. Please click on the link to verify your email address.\n If not auto redirected after verification, click on the Continue button.', textAlign: TextAlign.center, style: bodyText,

            ),
            SizedBox(height: 20),
            ElevatedButton(child: Text('Continue', style: mainHeading,), style: ButtonStyleConstants.secondaryButtonStyle,
              onPressed: () => controller.manuallyCheckEmailVerificationStatus()),

            SizedBox(height: 20,),
            TextButton(onPressed: ()=>controller.sendVerificationEmail(), child: Text("Resend Email link", style: GoogleFonts.poppins(color: Colors.blue),)),

            TextButton(onPressed: () => AuthenticationFunctions.instance.signOut(), child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 10),
                Text('Back to login', style: GoogleFonts.poppins(color: Colors.red),)
              ]
            ))



          ]
        )
      ),
    );
  }
}



class MailVerificationController extends GetxController {


  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedirect();
  }


  //send or resend verification email
  Future<void> sendVerificationEmail() async {
try {
  await AuthenticationFunctions.instance.sendEmailVerification();

}catch (e){
  Get.snackbar("Error", e.toString());
    }



  }


//set timer to check if verification complete then redirect user


  void setTimerForAutoRedirect() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if(user!.emailVerified){
        timer.cancel();
        AuthenticationFunctions.instance.setInitialScreen(user);
      }
    });

  }

  void manuallyCheckEmailVerificationStatus() {
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if(user!.emailVerified){
      AuthenticationFunctions.instance.setInitialScreen(user);
    }

  }
}



// manually check if verification is complete then redirect
