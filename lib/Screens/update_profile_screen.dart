import 'dart:io';

import 'package:car_rent/Screens/login/authentication_functions.dart';
import 'package:car_rent/Screens/login/user_functions.dart';
import 'package:car_rent/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils.dart';
import 'login/login_screen.dart';

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserFunctions _userFunctions = Get.find();
  final AuthenticationFunctions _authFunctions = Get.find();

  UserModel? _currentUser;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = _authFunctions.firebaseUser;
    if (currentUser != null) {
      final userData = await _userFunctions.getUserDetails(currentUser.email!);
      setState(() {
        _currentUser = userData;
        _usernameController.text = userData.name;
        _emailController.text = userData.email;
        _phoneNumberController.text = userData.phoneNumber;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_currentUser != null) {
      final password = _passwordController.text.trim();

      // Check if the password is empty
      if (password.isEmpty) {
        // Display an error message to the user
        Get.snackbar(
          'Error',
          'Please enter your password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        return; // Stop further execution
      }

      // Check if the entered password matches the current user's password
      if (password != _currentUser!.password) {
        // Display an error message to the user
        Get.snackbar(
          'Error',
          'Password does not match',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        return; // Stop further execution
      }

      // Proceed with updating the profile
      final updatedUser = UserModel(
        id: _currentUser!.id,
        name: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        createdAt: _currentUser!.createdAt,
        password: password,
      );


      await _userFunctions.updateUserRecord(updatedUser);
      _uploadImage(_currentUser!.id!);

      // Show success message to the user
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _deleteProfile() async {
    if (_currentUser != null) {
      // Show a confirmation dialog to the user
      final confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Profile'),
          content: Text('Are you sure you want to delete your profile?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true to confirm delete
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false to cancel delete
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
          ],
        ),
      );

      if (confirmDelete == true) {
        // Proceed with deleting the profile
        await _userFunctions.deleteUserRecord(_currentUser!.id!);

        // Log out the user after deleting the profile
        await _authFunctions.signOut();

        // Show a success message and navigate to the login screen
        Get.offAll(LoginScreen(), arguments: () {
          Get.snackbar(
            'Profile Deleted',
            'Your profile has been successfully deleted.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
          );
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;

      });

    }
  }

  Future<void> _uploadImage(String userId) async {
    if (_pickedImage != null) {
      final fileName = 'profile_$userId.jpg';

      // Upload the image file to Firebase Storage
      final storageReference = FirebaseStorage.instance.ref().child(fileName);
      await storageReference.putFile(_pickedImage!);

      // Get the image URL
      final imageUrl = await storageReference.getDownloadURL();

      // Update the user record with the image URL
      final updatedUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phoneNumber: _currentUser!.phoneNumber,
        createdAt: _currentUser!.createdAt,
        password: _currentUser!.password,
        imageUrl: imageUrl,
      );

      await _userFunctions.updateUserRecord(updatedUser);

      // Show success message to the user
      Get.snackbar(
        'Success',
        'Profile image updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          'Update Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.transparent, // Set the background color to transparent
                      child: ClipOval(
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: _pickedImage != null
                              ? Image.file(
                            _pickedImage!,
                            fit: BoxFit.contain,
                          )
                              : (_currentUser?.imageUrl != null &&
                              _currentUser!.imageUrl!.isNotEmpty
                              ? Image.network(
                            _currentUser!.imageUrl!,
                            fit: BoxFit.contain,
                          )
                              : Icon(
                            Icons.person,
                            size: 70,
                          )),
                        ),
                      ),
                    ),



                    // if (_currentUser?.imageUrl == null || _currentUser!.imageUrl!.isEmpty || _pickedImage == null)
                    //   Icon(
                    //     Icons.person,
                    //     size: 70,
                    //   ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Pick an option'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text('Gallery'),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          _pickImage(ImageSource.gallery);
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        child: Text('Camera'),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          _pickImage(ImageSource.camera);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.white)),
                  ),
                )
              ],
            ),
            Text(
              'Username',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Email',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Phone Number',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Enter your password before editing your profile",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: subHeading,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value != _currentUser?.password) {
                    return 'Password does not match';
                  }
                  return null;
                }),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text(
                'Update',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyleConstants.primaryButtonStyle,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Member Since: ${_currentUser?.createdAt?.day}/${_currentUser?.createdAt?.month}/${_currentUser?.createdAt?.year}",
                  style: bodyText,
                ),
                ElevatedButton(
                  onPressed: _deleteProfile,
                  child: Text(
                    "Delete Profile",
                    style: whiteHeading,
                  ),
                  style: ButtonStyleConstants.smallButtonStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
