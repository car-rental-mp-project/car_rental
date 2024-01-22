import 'package:car_rent/Screens/cars_home_page.dart';
import 'package:car_rent/Screens/login/mail_verification.dart';
import 'package:car_rent/Screens/nav_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'login_screen.dart';

class AuthenticationFunctions extends GetxController {
  static AuthenticationFunctions get instance => Get.find();

  final _auth = FirebaseAuth.instance;

  //changes (convert to stream using getX)
  late final Rx<User?> _firebaseUser;


  //getters

  User? get firebaseUser => _firebaseUser.value;



//redirect already logged in users

  //on ready is called when authfns are ready after being called in main.dart

  @override
  void onReady() {
    // Future.delayed(const Duration(seconds: 6));
    _firebaseUser = Rx<User?>(_auth.currentUser);

    //give user stream to fetch any firebase changes
    _firebaseUser.bindStream(_auth.userChanges());
    //FlutterNativeSplash.remove();
    //ever(firebaseUser, _setInitialScreen);
    setInitialScreen(_firebaseUser.value);
  }

  setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => LoginScreen())
        : user.emailVerified
            ? Get.offAll(() => const NavPage())
            : Get.offAll(const MailVerification());
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      firebaseUser!= null ? Get.offAll(() => const NavPage()) : Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Weak Password", "The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Email already in use", "The account already exists for that email");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser!= null ? Get.offAll(() => const NavPage()) : Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("User not found", "No user found for that email");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Wrong Password", "Wrong password provided for that user");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => LoginScreen());

  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("User not found", "No user found for that email");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

// import 'package:car_rent/Screens/cars_home_page.dart';
// import 'package:car_rent/Screens/nav_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'login_screen.dart';
//
// class AuthenticationFunctions {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Redirect already logged in users
//   Future<void> checkInitialScreen(BuildContext context) async {
//     final User? user = _auth.currentUser;
//     if (user == null) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     } else {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const NavPage()),
//       );
//     }
//   }
//
//   Future<void> createUserWithEmailAndPassword(
//       String email, String password, BuildContext context) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       final User? user = _auth.currentUser;
//       if (user != null) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const NavPage()),
//         );
//       } else {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("The password provided is too weak")),
//         );
//       } else if (e.code == 'email-already-in-use') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("The account already exists for that email")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     }
//   }
//
//   Future<void> signInWithEmailAndPassword(
//       String email, String password, BuildContext context) async {
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       final User? user = _auth.currentUser;
//       if (user != null) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const NavPage()),
//         );
//       } else {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("No user found for that email")),
//         );
//       } else if (e.code == 'wrong-password') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Wrong password provided for that user")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     }
//   }
//
//   Future<void> signOut(BuildContext context) async {
//     await _auth.signOut();
//   }
// }
