

import 'package:budget_planner/src/bloc/auth_bloc.dart';
import 'package:budget_planner/src/model/img.dart';
import 'package:budget_planner/src/pages/auth/biometric_authentication.dart';
import 'package:budget_planner/src/pages/home_page.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'sign_in_page.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashPage extends StatefulWidget {

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin{
   AnimationController _controller;
  final _prefs =  UserPrefs();
  nextPage(){
    final AuthBloc ab = Provider.of<AuthBloc>(context,listen: false);
    ab.checkSignIn();
    var page = ab.isSignedIn == false ? SigInPage() : _prefs.useFingerPrint ? BiometricAuth() : HomePage();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
    
  }
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    );
    _controller.forward();
    Future.delayed(Duration(milliseconds: 3000)).then((value) => nextPage());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child:  Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage(Img.get('splas2.jpg')),
          fit: BoxFit.cover
          )
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 190,),
            Container(
              padding: EdgeInsets.only(bottom: 5, left: 100, right: 100, top: 10),
              child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Image(
                image: AssetImage(Img.get('icon.png')),
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              )
              ),
            ),
            JumpingText(
              'BuPresupuestos',
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 1.438,
                fontFamily: "montserrat-bold",
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'emblem'.tr(),
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0.438,
              ),
            )
          ],    
        ),
      ),
    ));
  }
}
