import 'dart:async';
import 'package:budget_planner/src/pages/auth/intro_page.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class SuccessPage extends StatefulWidget {


  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
 //final _prefs = new UserPrefs();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 3000)).then((_) => nextScreenReplace(context, IntroPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 150,
          width: 150,
          child: SpinKitPumpingHeart(
              size: 150,
              color: Theme.of(context).accentColor
            ),
        ),
      ),
    );
  }
}