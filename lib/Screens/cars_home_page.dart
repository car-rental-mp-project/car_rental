
import 'dart:io';

import 'package:car_rent/Screens/login/authentication_functions.dart';
import 'package:car_rent/Screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:car_rent/Screens/car_details_page.dart';
import 'package:car_rent/utils/colors.dart' as AppColors;
import 'package:car_rent/utils/tabs.dart';
import 'package:car_rent/utils/utils.dart';
import 'package:car_rent/models/car_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../remote_config.dart';
import 'login/user_functions.dart';

class CarsHomePage extends StatefulWidget {
  const CarsHomePage({Key? key}) : super(key: key);

  @override
  State<CarsHomePage> createState() => _CarsHomePageState();
}

class _CarsHomePageState extends State<CarsHomePage>
    with SingleTickerProviderStateMixin {
  late String _selectedOption;
  late Future<void> bannerAdFuture;
  // Remove BannerAd and related properties
  bool isAdLoaded = false;
  bool isAdLoaded2 = false;
  var adUnit =
      "ca-app-pub-3940256099942544/6300978111"; //testing ad unit for banner1
  var adUnit2 = "ca-app-pub-3940256099942544/6300978111";

  @override
  void initState() {
    super.initState();
    // Remove the initialization of bannerAdFuture
  }

  // Remove the initBannerAd method

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CarsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.secondaryColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          // PopupMenuButton and other app bar widgets here
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: const BoxDecoration(color: Colors.white),
              alignment: Alignment.center,
              child:
                  Image.asset("assets/images/drivesyncLogo.png", height: 50, width: 120),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight -
                    
                    MediaQuery.of(context).padding.bottom,
                child: FutureBuilder<List<Car>>(
                  future: controller.getAllCarsDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<Car> carData = snapshot.data!;
                        return ListView.builder(
                          itemCount: carData.length,
                          itemBuilder: (ctx, i) {
                            final car = carData[i];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            CarDetailsPage(car: car),
                                      ),
                                    );
                                  },
                                  leading: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          offset: const Offset(0, 2),
                                          color: Colors.grey.withOpacity(0.1),
                                        )
                                      ],
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            car.imageUrls!.isNotEmpty
                                                ? car.imageUrls![0]
                                                : ''),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    car.name ?? '',
                                    style: mainHeading,
                                  ),
                                  subtitle: Text(
                                    car.description ?? '',
                                    style: subHeading,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Center(
                            child: Text("Something went wrong"));
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}

class CarsController extends GetxController {
  static CarsController get instance => Get.find();

  final _authFunctions = Get.put(AuthenticationFunctions());
  final _carFunctions = Get.put(CarFunctions());

  //query data, firstly get users' emails
  getUsersCarsData() {
    final email = _authFunctions.firebaseUser?.email;
    if (email != null) {
      return _carFunctions.getCarDetails(email);
    } else {
      Get.snackbar("Error", "Login to proceed");
    }
  }

  getAllCarsDetails() {
    return _carFunctions.getAllCarDetails();
  }
}
