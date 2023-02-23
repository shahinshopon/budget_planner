
import 'package:budget_planner/src/pages/home_page.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:easy_localization/easy_localization.dart';


class BiometricAuth extends StatefulWidget {
  

  @override
  _BiometricAuthState createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'no_authorized'.tr();
  bool _isAuthenticating = false;
  
  Future<void> _authenticate() async {
    bool authenticated = false;
    
      
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your finger print to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
      if(_authorized == 'Authorized' ){
       nextScreenReplace(context, HomePage());
      }
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }
  @override
  void initState() {
    super.initState();
    _authenticate();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ConstrainedBox(
         constraints: const BoxConstraints.expand(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 80,),
                 Text(
                    'app_name'.tr() ,
                    style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 28,
                    letterSpacing: 1.338,
                    fontFamily: "Montserrat-Bold",
                    fontWeight: FontWeight.w800,
                  ),
                 ),
                 Text(
                    'hi'.tr() ,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    letterSpacing: 1.338,
                    fontFamily: "montserrat-Regular",
                    fontWeight: FontWeight.w700,
                  ),
                 ),
                 Spacer(),
                 Container(
                  height: 180,
                  width: 180,
                  child: FlareActor(
                    'assets/flr/loading.flr',
                    animation : 'loading',
                    //color: Colors.deepPurpleAccent,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                 ),
                 Spacer(),
                 SizedBox( height: 45.0),
                 Text(
                    'configure_auth'.tr() ,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1.338,
                    fontFamily: "montserrat-Regular",
                    fontWeight: FontWeight.w700,
                   ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                  // color: Theme.of(context).accentColor,
                  // padding: EdgeInsets.all(15.0),
                  //           shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(180.0),
                  // ),
                  child: Icon(Icons.fingerprint, size: 55,),
                  onPressed:
                      _isAuthenticating ? _cancelAuthentication : _authenticate,
                  ),
                  Spacer(),
                  SizedBox( height: 25),
              ]
          )
       ),
    );
  }
}