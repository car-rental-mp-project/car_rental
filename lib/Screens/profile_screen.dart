import 'package:car_rent/Screens/update_profile_screen.dart';
import 'package:car_rent/main.dart';
import 'package:car_rent/models/user_model.dart';
import 'package:car_rent/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'MyListingsScreen.dart';
import 'login/authentication_functions.dart';
import 'login/user_functions.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(ProfileController());
    final _authFunctions = Get.put(AuthenticationFunctions());


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white)),
        title: Text('Profile', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.getUserData(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData){
              UserModel userData = snapshot.data as UserModel;
              return  Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(

                  children: [
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),

                      ),
                      height: size.height * 0.2,
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  // backgroundImage: NetworkImage(userData.imageUrl ?? ''),
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // border: Border.all(
                                      //   color: Colors.white,
                                      //   width: 2.0,
                                      // ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        userData.imageUrl ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),



                                if (userData.imageUrl == null || userData.imageUrl!.isEmpty)
                                  Icon(
                                    Icons.person,
                                    size: 70,
                                  ),
                              ],
                            ),

                            SizedBox(width: 20,),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(userData.name ?? '', style: mainHeading),
                                  Text(userData.email ?? '', style: bodyText),
                                  Text(userData.phoneNumber ?? '', style: bodyText),
                                  Text('Member Since: ${userData.createdAt?.day}/${userData.createdAt?.month}/${userData.createdAt?.year}',
                                      style: subHeading
                                  ),
                                  // ElevatedButton(onPressed: (){
                                  //   //TODO: EDIT PROFILE
                                  //   // Get.to(EditProfileScreen());
                                  //
                                  // }, child: Text("Edit Profile"))
                                ]
                            )
                          ]

                      ),

                    ),

                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              //TODO: MY LISTINGS
                              Get.to(MyListingsScreen());

                            },
                            child: ListTile(
                              leading: Icon(Icons.list_alt_outlined,  color: Colors.blue,),
                              title: Text("My Listings", style: mainHeading,),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              //TODO: EDIT PRIFILE
                              Get.to(ProfileUpdateScreen());
                            },
                            child: ListTile(
                              leading: Icon(Icons.edit,  color: Colors.blue,),
                              title: Text("Edit Profile", style: mainHeading,),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              _authFunctions.signOut();

                            },
                            child: ListTile(
                              leading: Icon(Icons.exit_to_app_sharp,  color: Colors.blue,),
                              title: Text("Log Out", style: mainHeading,),
                            ),
                          ),

                        ],
                      ),

                    ),
                  ],
                ),
              );


            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: Text("Something went wrong"));
            }

          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

// String _formatDate(String dateString) {
//   final date = DateTime.parse(dateString);
//   return '${date.day}/${date.month}/${date.year}';
// }
}


class ProfileController extends GetxController {
  static ProfileController get instance  =>Get.find();


  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();




  final _authFunctions = Get.put(AuthenticationFunctions());
  final _userFunctions = Get.put(UserFunctions());
  //query the data. first get user's email
  getUserData(){

    final email = _authFunctions.firebaseUser?.email;
    if (email != null){
      return  _userFunctions.getUserDetails(email);

    } else{
      Get.snackbar("Error", "Login to proceed");
    }
  }


  updateRecord(UserModel user) async{
    await  _userFunctions.updateUserRecord(user);
  }

}


