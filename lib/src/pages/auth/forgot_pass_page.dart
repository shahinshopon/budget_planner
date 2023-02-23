import 'package:budget_planner/src/bloc/auth_bloc.dart';
import 'package:budget_planner/src/bloc/internet_bloc.dart';
import 'package:budget_planner/src/model/img.dart';
import 'package:budget_planner/src/pages/auth/email_page.dart';
import 'package:budget_planner/src/utils/dialog.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:budget_planner/src/utils/snacbar.dart';
import 'package:budget_planner/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPage extends StatefulWidget {


  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   String email;
  bool _autoValidate = false;
  bool signInStart = false;

  TextEditingController emailCtrl    = TextEditingController();

  void handleSubmit() async {
    final AuthBloc ab = Provider.of<AuthBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);

    if(formKey.currentState.validate()){
      formKey.currentState.validate();
      await ib.checkInternet();
    if(ib.hasInternet == false){
      openSnacbar(_scaffoldKey, 'no_internet'.tr());
    }else{
       
        await ab.sendPasswordResetEmail(email).then((_) {
          if(ab.hasError == true){
          openToast1(context, 'Something is wrong. Please try again.');
            setState(() {
              signInStart = false;
            });
        }else{
          openDialog(context, '', 'submit_email'.tr());
          nextScreen(context, EmailPage());
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
                         'forgot_pass'.tr() ,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('email'.tr(), style: TextStyle(color: Colors.white),),
                            SizedBox(height: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                 color:  Theme.of(context).accentColor,
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
                        SizedBox(height: 35,),
                        _submitBtn(),
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

  Widget _submitBtn() {

    return ElevatedButton(
        //elevation: 12.0,
        onPressed: handleSubmit,
        // padding: EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12.0),
        // ),
        // color: Colors.white,
        child: Container(
          width: double.infinity,
          child: Text(
            'submit'.tr(),
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
              text: 'sign_in'.tr(),
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