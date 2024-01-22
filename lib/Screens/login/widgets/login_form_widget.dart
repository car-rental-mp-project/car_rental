// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:car_rent/utils/utils.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// import '../authentication_functions.dart';
//
// class LoginForm extends StatelessWidget {
//   final controller = Get.put(SigninController());
//   // final _formKey = GlobalKey<FormState>();
//    LoginForm({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // final controller = Get.put(SigninController());
//     final _formKey = GlobalKey<FormState>();
//
//     return Form(
//       key: _formKey,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: controller.email,
//                     decoration: InputDecoration(
//                         labelText: 'Email',
//                         prefixIcon: Icon(Icons.email),
//                         hintText: 'Enter your email',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//
//                         )
//                     )
//                 ),
//
//                 SizedBox(height: 20,),
//                 TextFormField(
//                   controller: controller.password,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       prefixIcon: Icon(Icons.lock),
//                       hintText: 'Enter your password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//
//                       ),
//                       suffixIcon: IconButton(
//                         onPressed: null,
//                         //todo: add functionality to show/hide password
//                         icon: Icon(Icons.remove_red_eye),
//
//                       ),
//                     )
//                 ),
//                 SizedBox(height: 20,),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(onPressed: (){
//                     //todo: add forgot password
//                   },
//                       child: Text("Forgot password?")),
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(onPressed: (){
//                     //todo: add functionality to login
//                     if(_formKey.currentState!.validate()){
//                       SigninController.instance.loginUser(controller.email.text.trim(), controller.password.text.trim());
//                     }
//                   }, child: const Text("LOGIN"),
//                   style: ButtonStyleConstants.primaryButtonStyle),
//                 ),
//               ]
//           ),
//         ));
//   }
// }
//
// class SigninController extends GetxController {
//
//   static SigninController get instance => Get.find();
//
//
//   final fullName = TextEditingController();
//   final email = TextEditingController();
//   final  phoneNumber = TextEditingController();
//   final password = TextEditingController();
//
//
//   //call this fn from design to register usr
//   void loginUser (String email, String password) {
//
//     //
//     AuthenticationFunctions.instance.signInWithEmailAndPassword(email, password);
//   }
//
// }