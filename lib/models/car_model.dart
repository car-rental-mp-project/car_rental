import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

part 'car_model.g.dart';

@HiveType(typeId: 0)
class Car {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  List<String>? imageUrls;

  @HiveField(3)
  String? power;

  @HiveField(4)
  String? range;

  @HiveField(5)
  String? seats;

  @HiveField(6)
  String? brand;

  @HiveField(7)
  String? rating;

  @HiveField(8)
  String? type;

  @HiveField(9)
  String? ownerEmail;

  @HiveField(10)
  String? id;

  Car({
    @required this.name,
    @required this.description,
    this.imageUrls,
    this.power,
     this.range,
    this.seats,
     this.brand,
     this.rating,
     this.type,
    @required this.ownerEmail,
    this.id,
  });



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image_urls': List<dynamic>.from(imageUrls ?? []),
      'power': power,
      'range': range,
      'seats': seats,
      'brand': brand,
      'rating': rating,
      'type': type,
      'ownerEmail': ownerEmail,
    };
  }


  factory Car.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return Car(
      id: document.id,
      name: data['name'],
      description: data['description'],
      imageUrls: List<String>.from(data['image_urls'] ?? []),
      power: data['power'],
      range: data['range'],
      seats: data['seats'],
      brand: data['brand'],
      rating: data['rating'],
      type: data['type'],
      ownerEmail: data['ownerEmail'],
    );
  }
}
