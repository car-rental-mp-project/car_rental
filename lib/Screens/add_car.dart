import 'dart:io';
import 'package:car_rent/Screens/cars_home_page.dart';
import 'package:car_rent/Screens/nav_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_rent/utils/colors.dart' as AppColors;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:car_rent/models/car_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import '../utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'login/authentication_functions.dart';
import 'login/user_functions.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {

  final _formKey = GlobalKey<FormState>();
  List<File> images = [];
  List<String> imagePaths = [];
  String? name;
  String? description;
  String? brand;
  String? power;
  String? range;
  String? seats;
  String? type;
  String? rating;
  late String? _email = "";
  late String _uniqueFileName = "";
  bool _isLoading = false;

  Future pickImages() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage(
        imageQuality: 80,
      );

      if (pickedImages == null) return;

      List<File> tempImages = [];
      List<String> tempImagePaths = [];

      for (final pickedImage in pickedImages) {
        final imageTemporary = File(pickedImage.path);
        print(pickedImage.path);

        // create unique name for image using timestamp
        _uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

        tempImages.add(imageTemporary);
        tempImagePaths.add(pickedImage.path);
      }

      setState(() {
        images = tempImages;
        imagePaths = tempImagePaths;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick images: $e');
      }
      // TODO
    }
  }

  verifyUser() {
    setState(() {
      _isLoading = true;
    });


    final _authFunctions = Get.put(AuthenticationFunctions());
    final _userFunctions = Get.put(UserFunctions());

    _email = _authFunctions.firebaseUser?.email;
    if (_email != null) {
      // return  _userFunctions.getUserDetails(email);
      submitData();
    } else {
      Get.snackbar("Error", "Login and Verify your Email to proceed");
    }

    setState(() {
      _isLoading = true;
    });
  }

  submitData() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final car = Car(
        name: name,
        description: description,
        imageUrls: [], // Initialize an empty list for image URLs
        power: power,
        range: range,
        seats: seats,
        brand: brand,
        rating: rating,
        type: type,
        ownerEmail: _email,
      );

      final carBox = Hive.box<Car>('car');
      carBox.add(car);

      // Create a new document reference in the "cars" collection
      final carRef = FirebaseFirestore.instance.collection('cars').doc();

      // Create a map of car data
      final carData = {
        'name': name,
        'description': description,
        'brand': brand,
        'power': power,
        'range': range,
        'seats': seats,
        'type': type,
        'rating': rating,
        'ownerEmail': _email,
        'image_urls': [], // Initialize an empty list for image URLs
      };

      // Save the car data to Firestore
      await carRef.set(carData);

      // Upload the image files to Firebase Storage
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

        // get a reference to storage root
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');

        // create a reference for the image to be stored
        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

        try {
          await referenceImageToUpload.putFile(File(image.path));
          final imageUrl = await referenceImageToUpload.getDownloadURL();

          // Add the image URL to the car document
          await carRef.update({'image_urls': FieldValue.arrayUnion([imageUrl])});
          print("Image stored");

        } catch (error) {
          print("Error uploading image: $error");
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NavPage()),
    );


  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Add a Car',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form (
              key: _formKey,
              child:Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the name ';
                    }

                    // additional validation logic for the phone number
                    return null;
                  },
                ),
                SizedBox(height: 5,),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  autocorrect: false,
                  minLines: 2,
                  maxLines: 10,
                  onChanged: (val) {
                    setState(() {
                      description = val;
                    });
                  },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the description ';
                      }

                      // additional validation logic for the phone number
                      return null;
                    }
                ),
                SizedBox(height: 5,),
                Row(

                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Engine capacity (cc)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        autocorrect: false,
                        onChanged: (val) {
                          setState(() {
                            power = val;
                          });

                        },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the cc ';
                            }

                            // additional validation logic for the phone number
                            return null;
                          }
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Price (Ksh)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          autocorrect: false,
                          onChanged: (val) {
                            setState(() {
                              range = val;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the price ';
                            }

                            // additional validation logic for the phone number
                            return null;
                          }
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 5,),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Seats',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() {
                      seats = val;
                    });
                  },
                ),
                SizedBox(height: 5,),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Type: Automatic/ Manual',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() {
                      type = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Please upload some images"),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: size.height*0.15,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    children: [
                      FloatingActionButton(
                        onPressed: pickImages,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.camera_enhance),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              images.length,
                                  (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  images[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed:(){
                    if(_formKey.currentState!.validate()){
                      _isLoading ? null : verifyUser();
                    }

                  } ,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save car'),
                  style: ButtonStyleConstants.primaryButtonStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
