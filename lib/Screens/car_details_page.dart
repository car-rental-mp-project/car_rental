import 'dart:ffi';
import 'dart:io';

//import 'package:car_rent/Screens/api_trial.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/car_model.dart';
import '../utils/utils.dart';
import 'package:car_rent/utils/colors.dart' as AppColors;

//import 'my_bookings.dart';

class CarDetailsPage extends StatefulWidget {
  final Car car;

  const CarDetailsPage({Key? key, required this.car}) : super(key: key);

  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  InterstitialAd? _interstitialAd;
  var interstitialAdUnit = "ca-app-pub-3940256099942544/1033173712";
  bool _adShown = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    _createInterstitialAd();
    super.initState();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          // Show the ad as soon as it is loaded.
          if (!_adShown) {
            _showInterstitialAd(widget.car);
          }
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print('Ad failed to load: $error');
          }
        },
      ),
    );
  }

  void _showInterstitialAd(Car car) async {
    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        if (_adShown) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailsPage(car: widget.car),
            ),
          );
        } else {
          setState(() {
            _adShown = true;
          });
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
        }
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text('Car Details', style: mainHeading),
          centerTitle: true,
          backgroundColor: AppColors.secondaryColor,
          elevation: 0,
        ),
        body: ListView(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 13),
              child: Text(
                'All the good stuff',
                style: mainHeading,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 13),
              child: Text(
                'Everything you need to know',
                style: subHeading,
              ),
            ),
            Container(
              width: 386,
              margin: const EdgeInsets.only(left: 13, right: 13, top: 10, bottom: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 350,
                    height: 227,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 227,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      items: widget.car.imageUrls!.map((imageUrl) {
                        return Container(
                          width: 350,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: const Offset(0, 0),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              // fit: BoxFit.scaleDown,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.car.imageUrls!.map((imageUrl) {
                      int index = widget.car.imageUrls!.indexOf(imageUrl);
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index ? Colors.black : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.car.name.toString(),
                    style: mainHeading,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 24, color: Color(0xFF4FABF1)),
                      const SizedBox(width: 5),
                      Text(widget.car.rating.toString() ?? '', style: subHeading),
                    ],
                  ),
                  Text('Description', style: mainHeading),
                  const SizedBox(height: 5),
                  Text(widget.car.description.toString() ?? '', style: subHeading),
                  const SizedBox(height: 10),
                  Container(
                    height: 70,
                    width: 386,
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
                    margin: const EdgeInsets.only(left: 13, top: 10, right: 13),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: const Color(0xFFEDEFF2),
                      border: Border.all(
                        color: const Color(0xFFEDEFF2),
                        width: 1,
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 1000,
                        height: 65,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 65,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Power",
                                    style: mainHeading,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(widget.car.power.toString(), style: subHeading, textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 65,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Seats",
                                    style: mainHeading,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(widget.car.seats.toString(), style: subHeading, textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 65,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Range",
                                    style: mainHeading,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(widget.car.range.toString(), style: subHeading, textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          width: 414,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: Container(
            height: 48,
            width: 380,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(24),
            ),
            child: OutlinedButton(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingsScreen()));
              },
              child: const Text(
                'CONFIRM NOW',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 18 / 12, // line height in relation to font size
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
