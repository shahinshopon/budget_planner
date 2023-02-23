
import 'package:budget_planner/src/bloc/user_bloc.dart';
import 'package:budget_planner/src/pages/auth/options_page.dart';
import 'package:budget_planner/src/pages/auth/sign_in_page.dart';
import 'package:budget_planner/src/pages/settings/language_settings.dart';
import 'package:budget_planner/src/pages/settings/setting_page.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //final FacebookLogin fbLogin = new FacebookLogin();
   final _prefs = new UserPrefs();

  void handleLogout() async{
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('logout_label_t'.tr(), style: TextStyle(
            fontWeight: FontWeight.w600
          ),),
          content: Text('ready_logout'.tr()),
          actions: <Widget>[
            ElevatedButton(
              child: Text('yes'.tr()),
              onPressed: () async {
                Navigator.pop(context);
                await auth.signOut();
                await googleSignIn.signOut();
                //fbLogin.logOut();
                clearAllData();
                nextScreenCloseOthers(context, SigInPage());

              },
            ),
            ElevatedButton(
              child: Text('cancel'.tr()),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );

  }


  void clearAllData () async{
    
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 3)).then((_){
      final UserBloc ub = Provider.of<UserBloc>(context );
  
      ub.getUserData();
     
    } );
  }
  

  @override
  Widget build(BuildContext context) {
    final UserBloc ub = Provider.of<UserBloc>(context );
    return Scaffold(
      
      appBar: PreferredSize(
        child: Center(
          child: AppBar(
           backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        title: Text('my_profile'.tr()),
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(25)
            ),
            child: ElevatedButton.icon(onPressed: () => handleLogout(), icon: Icon(FontAwesomeIcons.powerOff, color: Colors.white,), label: Text('logout_label'.tr(), style: TextStyle(color: Colors.white),)),
          )
        ],
        
        
      ),
        ), 
        preferredSize: Size.fromHeight(50)),
      body: SingleChildScrollView(
        child: Container(
           
           width: double.infinity,
          
          child: Column(
            children: [
            Container(
              height: 200,
              width: double.infinity,
              padding: EdgeInsets.all(45),
              child: CircleAvatar(
              radius: 180,
              backgroundColor: Colors.white,
                child: Container(
                height: 100,
                width: 100,
                
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey[800]
                    ),
                    
                    color: Colors.grey[500],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(_prefs.userUrlPhoto),
                        fit: BoxFit.cover)),
                
              ),
              
            ),
            
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('user_name'.tr(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                subtitle: Text(ub.name, style: TextStyle(fontSize: 16),),
              ),
            ),
            Divider(color: Colors.grey[500],),
             Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('email'.tr(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                subtitle: Text(ub.email , style: TextStyle(fontSize: 16),),
              ),
            ),
            Divider(color: Colors.grey[500],),
           
         
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('settings'.tr(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                onTap: ()=> nextScreen(context, SettingsPage()),
              ),
            ),
             Divider(color: Colors.grey[500],),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ListTile(
                leading: Icon(Icons.translate),
                title: Text('languages'.tr(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                onTap: ()=> nextScreen(context, LanguageSettingsPage()),
              ),
            ),
             Divider(color: Colors.grey[500],),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ListTile(
                leading: Icon(Icons.fingerprint),
                title: Text('fingerprint'.tr(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                onTap: ()=> nextScreen(context, OptionsMainPage()),
              ),
            )
            
          
            ],
          ),
        ),
      )
    );
  }
}