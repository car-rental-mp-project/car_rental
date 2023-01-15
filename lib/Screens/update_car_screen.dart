import 'dart:io';

import 'package:car_rent/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_rent/models/car_model.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCarScreen extends StatefulWidget {
  final Car car;

  const UpdateCarScreen({required this.car});

  @override
  _UpdateCarScreenState createState() => _UpdateCarScreenState();
}

class _UpdateCarScreenState extends State<UpdateCarScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _powerController;
  late TextEditingController _rangeController;
  late TextEditingController _seatsController;
  late TextEditingController _brandController;
  late TextEditingController _ratingController;
  late TextEditingController _typeController;
  List<String> _imageUrls = [];
  List<File> images = [];
  List<String> imagePaths = [];
  late String _uniqueFileName = "";
  bool _isLoading = false;// New list to store multiple image URLs

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.car.name);
    _descriptionController = TextEditingController(text: widget.car.description);
    _powerController = TextEditingController(text: widget.car.power);
    _rangeController = TextEditingController(text: widget.car.range);
    _seatsController = TextEditingController(text: widget.car.seats);
    _brandController = TextEditingController(text: widget.car.brand);
    _ratingController = TextEditingController(text: widget.car.rating);
    _typeController = TextEditingController(text: widget.car.type);
    _imageUrls = List<String>.from(widget.car.imageUrls as Iterable); // Initialize the list with existing image URLs
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _powerController.dispose();
    _rangeController.dispose();
    _seatsController.dispose();
    _brandController.dispose();
    _ratingController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _updateCar() async {
    setState(() {
      _isLoading =true;
    });
    final updatedCar = Car(
      name: _nameController.text,
      description: _descriptionController.text,
      power: _powerController.text,
      range: _rangeController.text,
      seats: _seatsController.text,
      brand: _brandController.text,
      rating: _ratingController.text,
      type: _typeController.text,
      ownerEmail: widget.car.ownerEmail,
      id: widget.car.id,
      imageUrls: _imageUrls, // Include the updated image URLs
    );

    try {


      final carRef =  FirebaseFirestore.instance.collection('cars').doc(widget.car.id);
      await carRef.update(updatedCar.toMap());


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

      // Show success message or navigate back to the listing page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Car updated successfully!'),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      // Show error message
    }
    setState(() {
      _isLoading =false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios)),
        title: Text('Edit Car',  style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name', labelStyle: subHeading),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description', labelStyle: subHeading),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _powerController,
                    decoration: InputDecoration(labelText: 'Engine Capacity', labelStyle: subHeading,

                    ),

                  ),
                ),Expanded(
                  child: TextFormField(
                    controller: _rangeController,
                    decoration: InputDecoration(labelText: 'Range', labelStyle: subHeading,


                        ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _seatsController,
                    decoration: InputDecoration(labelText: 'Seats', labelStyle: subHeading,
                        ),
                  ),
                ),
              ],
            ),

            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Price', labelStyle: subHeading),
            ),

            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type', labelStyle: subHeading),
            ),


            SizedBox(height: 8),
            Text('Images:'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed:  () async {
                pickImages();
              },
              child: Text('Add Images', style: GoogleFonts.poppins(color: Colors.blue, fontSize: 24),),
              style: ButtonStyleConstants.secondaryButtonStyle,
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: size.height*0.2,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border:  Border.all(
                  color: Colors.blue,
                  width: 2,
                ),

              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(

                  children: _buildImageList(),
                ),
              ),
            ),

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null :_updateCar,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      :  Text('Update Listing', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
                    style: ButtonStyleConstants.smallButtonStyle,
                ),
                ElevatedButton(
                  onPressed: (){


                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Listing'),
                                content: const Text('Are you sure you want to delete this listing?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Delete the listing
                                      FirebaseFirestore.instance
                                          .collection('cars')
                                          .doc(widget.car.id)
                                          .delete();
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete',),
                                  ),
                                ],
                              );
                            },
                          );




                  },
                  child: Text('Delete Listing', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
                  style: ButtonStyleConstants.smallButtonStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildImageList() {
    return _imageUrls.map((url) {
      return Column(
        children: [
          Expanded(child: Image.network(url)),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _removeImage(url),
          ),
        ],
      );
    }).toList();
  }

    // TODO: Implement image upload logic and add the uploaded image URL to _imageUrls
    // You can use packages like image_picker or firebase_storage for image uploading.
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




  void _removeImage(String url) {
    setState(() {
      _imageUrls.remove(url);
    });
  }
}




