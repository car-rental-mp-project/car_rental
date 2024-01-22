import 'package:car_rent/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/car_model.dart';


//all firebase db user operations
class UserFunctions extends GetxController{
  static UserFunctions get instance => Get.find();


  //instance
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection("users").add(user.toJson()).whenComplete(
          () => Get.snackbar("Success", "Your account has been created",



        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,),
    )
        .catchError((e, stackTrace) {
      Get.snackbar("Error", "Something went wrong.Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,);
      print(
          e.toString());
    }
    );
  }


  //Fetch user data

  //single record
  Future<UserModel> getUserDetails(String email) async {

    final snapshot = await _db.collection("users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return  userData;

  }

// all records
  Future<List<UserModel>> getAllUserDetails() async {

    final snapshot = await _db.collection("users").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return  userData;

  }


  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("users").doc(user.id).update(user.toJson());


  }



  Future<void> deleteUserRecord(String userId) async {
    await _db.collection("users").doc(userId).delete();
  }



}


class CarFunctions extends GetxController {
  static CarFunctions get instance => Get.find();


  //instance
  final _db = FirebaseFirestore.instance;


  Future<List<Car>> getAllCarDetails() async {

    final snapshot = await _db.collection("cars").get();
    final carData = snapshot.docs.map((e) => Car.fromSnapshot(e)).toList();
    return  carData;

  }

// single user's cars

  Future<List<Car>> getCarDetails(String email) async {

    final snapshot = await _db.collection("cars").where("ownerEmail", isEqualTo: email).get();
    final carData = snapshot.docs.map((e) => Car.fromSnapshot(e)).toList();
    return  carData;

  }



}