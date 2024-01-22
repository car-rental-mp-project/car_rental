import 'package:car_rent/Screens/login/authentication_functions.dart';
import 'package:car_rent/Screens/login/login_screen.dart';
import 'package:car_rent/Screens/login/user_functions.dart';
import 'package:car_rent/widgets/form/form_header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/user_model.dart';
import '../../utils/utils.dart';

class SignUpScreen extends StatefulWidget {

  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController controller = Get.put(SignUpController());

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurepin = true;
  bool _obscureConfirmPin = true;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(SignUpController());
    // final _formKey = GlobalKey<FormState>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FormHeaderWidget(
                size: size, image: appLogo,
                title: "Get on Board!",
                subtitle: "Create your profile to start your Journey",
                crossAxisAlignment: CrossAxisAlignment.start,
                textAlign: TextAlign.start,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                            controller: controller.fullName,
                            decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person),
                                // hintText: 'Enter your full name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your full name';

                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                            controller: controller.email,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                                // hintText: 'Enter your full name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                            controller: controller.phoneNumber,
                            decoration: InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone),
                                // hintText: 'Enter your full name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                            controller: controller.password,
                            obscureText: _obscurepin,

                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              // hintText: 'Enter your full name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurepin ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurepin = !_obscurepin;
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
                        const SizedBox(height: 10),
                        TextFormField(

                            obscureText: _obscureConfirmPin,
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                // hintText: 'Enter your full name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPin ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPin = !_obscureConfirmPin;
                                  });
                                }
                              )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please confirm your password';
                              }  else if (value != controller.password.text) {
                                return 'Password does not match';
                              }
                              return null;
                            }

                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              //todo: add functionality to sign up
                              if (_formKey.currentState!.validate()) {
                                controller.createUser();
                                setState(() {
                                  _isLoading = false;
                                });
                              }

                              // if (_formKey.currentState!.validate()) {
                              //   SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                              // }
                            },
                            child: _isLoading ? CircularProgressIndicator() : Text("SIGN UP", style: whiteHeading,),
                            style: ButtonStyleConstants.primaryButtonStyle),
                      ],
                    )),
              ),
              Column(
                children: [
                  Text("OR", style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          //todo: add functionality to sign up with google
                        },
                        icon: Image.asset(
                          "assets/images/google_icon.png",
                          width: 20,
                        ),
                        label: Text("Sign in with Google",  style: GoogleFonts.poppins(
                          color: Colors.blue,
                        ),),
                        style: ButtonStyleConstants.secondaryButtonStyle,
                      )),
                  TextButton(
                      onPressed: () {
                        Get.to(
                              () => LoginScreen(),
                        );
                      },
                      child:  Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                            text: "Sign in",
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                            ))
                      ])))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final fullName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();

  //instance of userfns
  final userFunctions = Get.put(UserFunctions());

  //call this fn from design to register usr
  // void registerUser(String email, String password) {
  //   //
  //   String? error = AuthenticationFunctions.instance.createUserWithEmailAndPassword(email, password) as String?;
  //   if (error != null) {
  //     Get.showSnackbar(GetSnackBar(
  //       message: error.toString(),
  //     ));
  //   }
  // }

  // Future<void> createUser (UserModel user) async {
  //   await userFunctions.createUser(user);
  //   SignUpController.instance.registerUser(user.email.trim(), user.password.trim());
  // }




  Future<void> createUser()async{

    try{
      final user = UserModel(
        name: fullName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        password: password.text.trim(),
        createdAt: DateTime.now(),
      );

      final auth = AuthenticationFunctions.instance;
      await AuthenticationFunctions.instance.createUserWithEmailAndPassword(user.email, user.password);
      await UserFunctions.instance.createUser(user);
      auth.setInitialScreen(auth.firebaseUser);
    } catch (e){
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
      ));
    }
  }

}

// class SignUpController {
//   final fullName = TextEditingController();
//   final email = TextEditingController();
//   final phoneNumber = TextEditingController();
//   final password = TextEditingController();
//
//   final AuthenticationFunctions authFunctions;
//
//   SignUpController({required this.authFunctions});
//
//   void registerUser(String email, String password) {
//     authFunctions.createUserWithEmailAndPassword(email, password);
//   }
// }
