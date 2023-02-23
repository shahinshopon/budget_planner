
import 'package:budget_planner/src/bloc/auth_bloc.dart';
import 'package:budget_planner/src/bloc/internet_bloc.dart';
import 'package:budget_planner/src/model/img.dart';
import 'package:budget_planner/src/pages/auth/email_verification.dart';
import 'package:budget_planner/src/utils/dialog.dart';
import 'package:budget_planner/src/utils/snacbar.dart';
import 'package:budget_planner/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpPage extends StatefulWidget {


  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   String email, password, confirmPass, userName;
  bool signInStart = false;
  bool _autoValidate = false;
   bool _obscurePass;
   bool _obscureConfPass;

  TextEditingController emailCtrl    = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController userNameCrtl = TextEditingController();
  TextEditingController confirmPasswordCrtl = TextEditingController();

   @override
  void initState() {
    _obscurePass = true;
    _obscureConfPass = true;
    super.initState();
  }

  void handleSignUp() async {
    final AuthBloc ab = Provider.of<AuthBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);

    if(formKey.currentState.validate()){
      formKey.currentState.validate();

      
        await ib.checkInternet();
      if(ib.hasInternet == false){
        openSnacbar(_scaffoldKey, 'no_internet'.tr());
      }else{

          await ab.createUserEmailPass(email, password, userName).then((_){
            if(ab.hasError == true){
              openToast1(context, 'Something is wrong. Please try again. ${ab.errorCode}',);
                setState(() {
                  signInStart = false;
                });
            }else{
              //ab.getJoiningDate().then((value) => ab.saveDataToSP().then((value) => ab.saveToFirebase().then((value) => ab.setSignIn().then((value) =>   Navigator.push(context, MaterialPageRoute(builder: (context) => EmailVerifiedPage(email: email, password: password))),))));
            
            ab.getJoiningDate().then((value) => ab.saveDataToSP().then((value) => ab.saveToFirebase().then((value) =>   Navigator.push(context, MaterialPageRoute(builder: (context) => EmailVerifiedPage(email: email, password: password))),)));
              openDialog(context, '', 'create_user'.tr());
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
                        SizedBox(height: 45,),
                        Text(
                          'sign_up_here'.tr() ,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 25,
                            letterSpacing: 1.338,
                            fontFamily: "montserrat-Regular",
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 20),
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Theme.of(context).accentColor,
                            child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).accentColor
                                ),
                                color: Colors.grey[500],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(Img.get('icon.png',)),
                                    fit: BoxFit.fill)),
                            
                          ),
                          
                        ),
                        
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('user_name'.tr(), style: TextStyle(color: Colors.white),),
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
                                controller: userNameCrtl,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  ),
                                  hintText: 'user_name_hint'.tr(),
                                ),
                                validator: validateName,
                                onSaved: ( value) {
                                    userName = value;
                                  },
                                onChanged: ( value ) => userName = value,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
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
                                  hintText:'enter_email'.tr(),

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
                                obscureText: _obscurePass ,
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
                        SizedBox(height: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('confirm_password'.tr(), style: TextStyle(color: Colors.white),),
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
                                controller: confirmPasswordCrtl,
                                obscureText: _obscureConfPass,
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
                                      _obscureConfPass = !_obscureConfPass;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      _obscureConfPass ? Icons.visibility : Icons.visibility_off,
                                      size: 20,
                                    ),
                                  ),
                                )
                                ),
                                validator: validatePass,
                                onSaved: ( value) {
                                    confirmPass = value;
                                  },
                                onChanged: ( value ) => password = value,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 40,),
                        _signUpBtn(),
                        SizedBox(height: 40,),
                        _buildLoginBackBtn(),
                      
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

  String validateName(String value) {
    if (value.length < 3) {
      return   'valid_user_name'.tr();
    } else 
      return null;
    
  }

  String validateEmail(String value) {
    if (value != null || value.isNotEmpty) {
      final RegExp regex = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regex.hasMatch(value)) {
        return 'Enter a valid email';
      } else {
        return null;
      }
    } else {
      return 'Enter a valid email';
    }
  }

 String validatePass(String value) {
    if (value.length < 6) {
      return 'valid_password'.tr();
    } else {
      return null;
    }
  }


  Widget _signUpBtn() {

    return ElevatedButton(
        //elevation: 12.0,
        onPressed: handleSignUp,
        // padding: EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        // ),
        // color: Colors.white,
        child: Container(
          width: double.infinity,
          child: Text(
            'sign_up'.tr(),
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
              text: 'aready_account'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'back_login'.tr(),
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