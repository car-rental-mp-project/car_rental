

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String? imageUrl;
  final String? role;
  final DateTime? createdAt;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
     this.imageUrl,
     this.role,
     this.createdAt,
  });


  toJson(){
    return {

      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'imageUrl': imageUrl,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),

    };
  }


  // map user fetched data

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    final createdAt = DateTime.parse(data['createdAt']);

    return UserModel(
      id: document.id,
      email: data['email'],
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      password: data['password'],
      imageUrl: data['imageUrl'],
      role: data['role'],
      createdAt: createdAt,
    );
  }



}


