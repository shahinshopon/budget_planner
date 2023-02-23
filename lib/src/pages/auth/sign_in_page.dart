
import 'package:budget_planner/src/bloc/auth_bloc.dart';
import 'package:budget_planner/src/bloc/internet_bloc.dart';
import 'package:budget_planner/src/model/img.dart';
import 'package:budget_planner/src/pages/auth/email_page.dart';
import 'package:budget_planner/src/pages/auth/success.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:budget_planner/src/utils/snacbar.dart';
import 'package:budget_planner/src/utils/toast.dart';
import 'package:budget_planner/src/widgets/loading_signin_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SigInPage extends StatefulWidget {


  @override
  _SigInPageState createState() => _SigInPageState();
}

class _SigInPageState extends State<SigInPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool signInStart = false;
   String brandName;

  void handleFacebbokLogin () async{
    final AuthBloc ab = Provider.of<AuthBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if(ib.hasInternet == false){
      openSnacbar(_scaffoldKey, 'no_internet'.tr());
    }else{
      setState((){ 
        signInStart = true;
        brandName = 'Facebook';
        });
      await ab.logInwithFacebook().then((_){
        if(ab.hasError == true){
          openToast1(context, 'error_fb'.tr());
           
          setState(() {
            signInStart = false;
          });
        }else {
          ab.checkUserExists().then((value){
          if(ab.userExists == true){
            ab.getUserData(ab.uid).then((value) => ab.saveDataToSP().then((value) => ab.setSignIn().then((value) => nextScreenReplace(context, SuccessPage()))));
          } else{
            ab.getJoiningDate().then((value) => ab.saveDataToSP().then((value) => ab.saveToFirebase().then((value) => ab.setSignIn().then((value) => nextScreenReplace(context, SuccessPage())))));
          }
        }); 
       }
      });
    }
  }

  void handleGoogleLogin () async{
    final AuthBloc ab = Provider.of<AuthBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if(ib.hasInternet == false){
      openSnacbar(_scaffoldKey, 'no_internet'.tr() );
    }else{
      setState((){ 
        signInStart = true;
        brandName = 'Google';
        });
      await ab.signInWithGoogle().then((_){
        if(ab.hasError == true){
          
          openToast1(context,  'error_google'.tr());
          setState(() {
            signInStart = false;
          });
        }else {
          ab.checkUserExists().then((value){
          if(ab.userExists == true){
            ab.getUserData(ab.uid).then((value) => ab.saveDataToSP().then((value) => ab.setSignIn().then((value) => nextScreenReplace(context, SuccessPage()))));
          } else{
            ab.getJoiningDate().then((value) => ab.saveDataToSP().then((value) => ab.saveToFirebase().then((value) => ab.setSignIn().then((value) => nextScreenReplace(context, SuccessPage())))));
          }
            });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: signInStart == false ? singInUI() : loadingUI(brandName));
  }

  Widget singInUI(){
    return Scaffold(
      body:  SingleChildScrollView(
        child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              
              child: Column(
                children: <Widget>[
                  SizedBox(height: 65,),
                  Text(
                    'app_name'.tr() ,
                    style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 25,
                    letterSpacing: 1.338,
                    fontFamily: "Montserrat-Bold.",
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10,),
                    child: Image.asset(Img.get('login_icon.png',)),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'sign_in'.tr()  ,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 0.338,
                    fontWeight: FontWeight.w800,
                  ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 30, right: 30),
                    child: Text(
                      'message_login'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      ),
                    ),
                  ),

                  SizedBox(height: 30,),
                  _buildSocialBtnRow(context),
                  
                   Text(
                      'or'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        
                      ),
                  ),
                  SizedBox(height: 40,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      //elevation: 12.0,
                      onPressed: ()=> nextScreen(context, EmailPage()) ,
                      // padding: EdgeInsets.all(13.0),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(12.0),
                      // ),
                      // color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.solidEnvelope, color: Theme.of(context).accentColor),
                          SizedBox(width: 10,),
                          Text(
                            'use_email'.tr(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                 
                  
                ],
              ),
            ),
      ),
        
    );
  }

  Widget _buildSocialBtnRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _socialBtn(
            () => handleFacebbokLogin(),
            AssetImage(Img.get('facebook.jpg')),
          ),
          _socialBtn(
            () => handleGoogleLogin(),
            AssetImage(Img.get('google.png')),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn( onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70.0,
        width: 70.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage( image: logo),
        ),
      ),
    );
  }

  
}