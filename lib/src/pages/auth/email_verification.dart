import 'dart:async';
import 'package:budget_planner/src/bloc/auth_bloc.dart';
import 'package:budget_planner/src/bloc/internet_bloc.dart';
import 'package:budget_planner/src/model/img.dart';
import 'package:budget_planner/src/pages/auth/sign_up_page.dart';
import 'package:budget_planner/src/pages/auth/success.dart';
import 'package:budget_planner/src/utils/dialog.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:budget_planner/src/utils/snacbar.dart';
import 'package:budget_planner/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class EmailVerifiedPage extends StatefulWidget {
  EmailVerifiedPage({Key key, this.email, this.password}) : super(key: key);

  final String email;
  final String password;

  @override
  _EmailVerifiedPageState createState() => _EmailVerifiedPageState(
    this.email,
    this.password
  );
}

class _EmailVerifiedPageState extends State<EmailVerifiedPage> {

  _EmailVerifiedPageState(
     this.email,
    this.password
  );

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email;
  String password;
  bool _autoValidate = false;
  bool signInStart = false;
  Timer timer;

  void handleVerified() async {
    final AuthBloc ab = Provider.of<AuthBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);

    if(formKey.currentState.validate()){
      formKey.currentState.validate();
      await ib.checkInternet();
    if(ib.hasInternet == false){
      openSnacbar(_scaffoldKey, 'no_internet'.tr());
    }else{
       
        await ab.checkEmailVerified(email, password).then((_) {
          if(ab.hasError == true){
          openToast1(context, 'Something is wrong. Please try again.');
            setState(() {
              signInStart = false;
            });
        }else{
          openDialog(context, '', 'submit_email'.tr());
          if( ab.userEmailVerify){
            nextScreen(context, SuccessPage());
            ab.setSignIn();
          }
        }
        });
        
    }
      formKey.currentState.save();
      }else {
    setState(() {
      _autoValidate = true;
    });
  } 
  }


  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
            
        child: CustomScrollView(
          slivers: <Widget>[
             SliverList(delegate: SliverChildListDelegate(
               [
                 Form(
                   key: formKey,
                   // ignore: deprecated_member_use
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                   child: Column(
                     children: [
                        SizedBox(height: 70,),
                        Text(
                         'email_verify'.tr() ,
                         textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 1.338,
                            fontFamily: "montserrat-Regular",
                            fontWeight: FontWeight.w800,
                            
                          ),
                        ),
                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 100, right: 100, bottom: 5,),
                          child: Image.asset(Img.get('icon.png',)),
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.only(top: 5, left: 30, right: 30),
                          child: Text(
                            'verify_desc1'.tr() + email + 'verify_desc2'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 35,),
                        _verifiedBtn(),
                        SizedBox(height: 10,),
                      
                        _changeBtn(),
                        SizedBox(height: 55,),
                        _buildLoginBackBtn()
                     ],
                   ),
                 )
               ]
             ))
          ]
        ),
      ), 
    );
  }

  Widget _verifiedBtn() {

    return ElevatedButton(
       // elevation: 12.0,
        onPressed: handleVerified,
        // padding: EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        // ),
        // color: Colors.white,
        child: Container(
          width: double.infinity,
          child: Text(
            'verified'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    );
  }
  
  
  Widget _changeBtn() {

    return ElevatedButton(
      //  elevation: 12.0,
        onPressed: () => nextScreenReplace(context, SignUpPage()),
        // padding: EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        // ),
       // color: Colors.white,
        child: Container(
          width: double.infinity,
          child: Text(
            'change_eamail'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    );
  }


  Widget _buildLoginBackBtn() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'back'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'sign_up'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}