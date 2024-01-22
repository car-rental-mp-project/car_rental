import 'package:car_rent/Screens/login/widgets/login_footer_widget.dart';
import 'package:car_rent/Screens/login/widgets/login_header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '';
import 'package:car_rent/utils/utils.dart';
import 'package:car_rent/utils/colors.dart' as app_colors;

import '../../utils/utils.dart';
import 'authentication_functions.dart';
import 'forget_password_mail.dart';
import 'widgets/login_form_widget.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(SigninController());

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePin = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoginHeaderWidget(size: size),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                    controller: controller.email,
                                    decoration: InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email),
                                        hintText: 'Enter your email',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),


                                        )
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your email';

                                      }
                                      return null;
                                    }
                                ),

                                SizedBox(height: 10,),
                                TextFormField(
                                    controller: controller.password,
                                    obscureText: _obscurePin,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock),
                                      hintText: 'Enter your password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),

                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePin ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePin = !_obscurePin;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    }
                                ),
                                SizedBox(height: 5,),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(onPressed: (){
                                    Get.to(()=> ForgetPasswordMailScreen());
                                    //todo: add forgot password
                                  },
                                      child: Text("Forgot password?",  style: GoogleFonts.poppins(
                                        color: Colors.blue,
                                      ),)),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(onPressed: (){


                                    //todo: add functionality to login
                                    if(_formKey.currentState!.validate()){
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      SigninController.instance.loginUser(controller.email.text.trim(), controller.password.text.trim());

                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },  child:_isLoading ? const CircularProgressIndicator():  Text("LOGIN", style: whiteHeading,),
                                      style: ButtonStyleConstants.primaryButtonStyle),
                                ),
                              ]
                          ),
                        )),
                  ),

                  LoginFooterWidget()

                ]
            ),

          )
      ),
    );
  }
}



class SigninController extends GetxController {

  static SigninController get instance => Get.find();


  final fullName = TextEditingController();
  final email = TextEditingController();
  final  phoneNumber = TextEditingController();
  final password = TextEditingController();


  //call this fn from design to register usr
  void loginUser (String email, String password) {

    //
    final auth = AuthenticationFunctions.instance;
    AuthenticationFunctions.instance.signInWithEmailAndPassword(email, password);

    AuthenticationFunctions.instance.setInitialScreen(auth.firebaseUser);
  }

}




