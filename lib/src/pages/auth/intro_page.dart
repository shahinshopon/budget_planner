//import 'package:budget_plan/src/pages/auth/biometric_authentication.dart';
import 'package:budget_planner/src/model/img.dart';
import 'package:budget_planner/src/pages/auth/options_page.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class IntroPage extends StatefulWidget {

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      
      body: Column(
        children: <Widget>[
          Container(
            height: h * 0.80,
            child: Carousel(
              dotVerticalPadding: h * 0.00,
              dotColor: Colors.grey,
              dotIncreasedColor: Theme.of(context).accentColor,
              autoplay: false,
              dotBgColor: Colors.transparent,
              dotSize: 6,
              dotSpacing: 15,
              images: [page1(), page2(), page3()],
            ),
          ),
          SizedBox( height: h * 0.05),
          Container(
            height: 45,
            width: w * 0.70,
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(25),
                ),
            child: ElevatedButton(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(25)),
              child: Text(
                'get_started'.tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () => nextScreenReplace(context, OptionsMainPage()),
            ),
          ),
          SizedBox( height: 0.15),
        ],
      ),
    );
  }

  Widget page1() {
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox( height: 50),
          Container(
            alignment: Alignment.center,
            height: h * 0.38,
            child: Image(
              image: AssetImage(Img.get('intro2.2.png')),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox( height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              'onboard_title_1'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins',color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox( height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'onboard_message_1'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget page2() {
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox( height: 50),
          Container(
            alignment: Alignment.center,
            height: h * 0.38,
            child: Image(
              image: AssetImage(Img.get('intro2.1.png')),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox( height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              'onboard_title_2'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox( height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'onboard_message_2'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget page3() {
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center,
            height: h * 0.38,
            child: Image(
              image: AssetImage(Img.get('intro3.1.png')),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              'onboard_title_3'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox( height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'onboard_message_3'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
