
import 'package:budget_planner/src/pages/home_page.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'biometric_authentication.dart';

class OptionsMainPage extends StatefulWidget {
  

  @override
  _OptionsMainPageState createState() => _OptionsMainPageState();
}

class _OptionsMainPageState extends State<OptionsMainPage> {
   final _prefs =  UserPrefs();
    //BannerAd _bannerAd;

   @override
   void initState() { 
     super.initState();
    
     
   }

   @override
  void dispose() {
    super.dispose();
    //_bannerAd.dispose();
    
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
         constraints: const BoxConstraints.expand(),
         child: Column(
          
           children: [
           SizedBox(height: 80,),
           Text(
                    'app_name'.tr() ,
                    style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 40,
                    letterSpacing: 1.338,
                    fontFamily: "montserrat-Bold",
                    fontWeight: FontWeight.bold,
                  ),
                 ),
                  SizedBox(height: 80,),
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: SwitchListTile(
                      value: _prefs.useFingerPrint,
                      onChanged: (_) {
                        setState(() {
                          _prefs.useFingerPrint = !_prefs.useFingerPrint;
                        });
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'use_finger'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'use_finger_change'.tr(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            
                SizedBox(height: 200,),
                  
                
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                      // color: Theme.of(context).accentColor,
                      // padding: EdgeInsets.all(15.0),
                      //           shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(180.0),
                      // ),
                      child: Icon(Icons.fingerprint, size: 55,),
                      onPressed:()=> nextScreenReplace(context, BiometricAuth())
                          
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                      // color: Theme.of(context).accentColor,
                      // padding: EdgeInsets.all(15.0),
                      //           shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(150.0),
                      // ),
                      child: Icon(Icons.home, size: 55,),
                      onPressed:()=> nextScreenReplace(context, HomePage())
                          
                    ),
                    ],
                  ),
             
         ],),
      ),
    );
  }

  void _loadBanner(){
   // _bannerAd..load()..show(anchorType: AnchorType.bottom);

  }
}