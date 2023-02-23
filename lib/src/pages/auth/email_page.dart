import 'package:budget_planner/src/bloc/auth_bloc.dart';
import 'package:budget_planner/src/bloc/internet_bloc.dart';
import 'package:budget_planner/src/model/img.dart';
import 'package:budget_planner/src/pages/auth/forgot_pass_page.dart';
import 'package:budget_planner/src/pages/auth/sign_up_page.dart';
import 'package:budget_planner/src/pages/auth/success.dart';
import 'package:budget_planner/src/utils/dialog.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:budget_planner/src/utils/snacbar.dart';
import 'package:budget_planner/src/utils/toast.dart';
import 'package:budget_planner/src/widgets/loading_signin_ui.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class EmailPage extends StatefulWidget {
  EmailPage({Key key}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email, password;
  bool signInStart = false;
  bool _obscurePass = true;
  String brandName;
  bool autoValidate = false;

  TextEditingController emailCtrl    = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  void handleEmailLogin() async {
    final AuthBloc ab = Provider.of<AuthBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);

    if(formKey.currentState.validate()){
      formKey.currentState.validate();
      await ib.checkInternet();
      if(ib.hasInternet == false){
        openSnacbar(_scaffoldKey, 'no_internet'.tr());
      }else{
        setState((){ 
          signInStart = true;
          brandName = 'brand_email'.tr();
          });
          await ab.logInwithEmailPass(email, password).then((_){
            if(ab.hasError == true){
               openDialog(context, 'incorrect information', 'Please double check your password and email');
              openToast1(context, 'Something is wrong. Please try again.');
             
            setState(() {
              signInStart = false;
            });
            }else{
              ab.getUserData(ab.uid).then((value) => ab.saveDataToSP().then((value) => ab.setSignIn().then((value) => nextScreenReplace(context, SuccessPage()))));
              
            }
          });
      }
    }else {
    setState(() {
      autoValidate = true;
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
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
           
          child: CustomScrollView(
            
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(
                [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 55,),
                        Text(
                          'app_name'.tr() ,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 28,
                            letterSpacing: 1.338,
                            fontFamily: "montserrat-Regular",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 100, right: 100, bottom: 5,),
                          child: Image.asset(Img.get('icon.png',)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('email'.tr(), style: TextStyle(color: Colors.white),),
                            SizedBox(height: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                 color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 8.0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],

                              ),
                              alignment: Alignment.centerLeft,
                              height: 60.0,
                              child: TextFormField(
                                controller: emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                  ),
                                  hintText: 'enter_email'.tr(),
                                ),
                                validator: validateEmail,
                                onSaved: (String value) {
                                    email = value;
                                  },
                                onChanged: ( value ) => email = value,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('password'.tr(), style: TextStyle(color: Colors.white),),
                            SizedBox(height: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                 color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 8.0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],

                              ),
                              alignment: Alignment.centerLeft,
                              height: 60.0,
                              child: TextFormField(
                                controller: passwordCtrl,
                                obscureText: _obscurePass ?? false,
                                style: TextStyle(
                                color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 5.0),
                                  prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  ),
                                  hintText: 'enter_password'.tr(),
                                  suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscurePass = !_obscurePass;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      _obscurePass ? Icons.visibility : Icons.visibility_off,
                                      size: 20,
                                    ),
                                  ),
                                )
                                ),
                                validator: validatePass,
                                  onSaved: (String value) {
                                      password = value;
                                    },
                                onChanged: ( value ) => password = value,
                              ),
                            ),
                          ],
                        ),
                        _forgotPasswordBtn(),
                        SizedBox(height: 40,),
                        _loginBtn(),
                        SizedBox(height: 40,),
                        _buildSignupBtn(),
                        SizedBox(height: 50,),
                        _buildBackBtn()
                      ],
                    ),
                  ),
                ]
              ))
            ],
          ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'valid_email'.tr();
    else
      return null;
  }

  String validatePass(String value) {
    if (value.length < 6)
      return  'valid_password'.tr();
    else
      return null;
  }

  Widget _forgotPasswordBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () => nextScreen(context, ForgotPage()),
         // padding: EdgeInsets.only(right: 0.0),
          child: Text(
            'forgot_pass'.tr(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),

      ],
       
    );
  }

  Widget _loginBtn(  ) {

    return ElevatedButton(
       // elevation: 12.0,
        onPressed: handleEmailLogin,
        // padding: EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        // ),
        // color: Colors.white,
        child: Container(
          width: double.infinity,
          child: Text(
            'login'.tr(),
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
  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => nextScreen(context, SignUpPage()),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'sign_up_dot'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'sign_up_here'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackBtn() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'soicial_media_dot'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'back'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}