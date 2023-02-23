
import 'package:budget_planner/src/bloc/user_bloc.dart';
import 'package:budget_planner/src/pages/settings/alarm.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion = '0.0';
  String packageName = '';
  final TextStyle style = TextStyle(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 0.338,
              
              fontWeight: FontWeight.w500,
              );

  void initPackageInfo () async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      packageName = packageInfo.packageName;
    });
  }

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
     final UserBloc ub = Provider.of<UserBloc>(context );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('settings'.tr(), style: TextStyle( fontSize: 22, letterSpacing: 0.338, fontFamily: "montserrat-Regular", fontWeight: FontWeight.w400),),
      ),
      body: Padding(padding: EdgeInsets.only(left: 20, right: 15, top: 15,),
      child: ListView(children: [
        SizedBox(height: 10,),
            ListTile(
              onTap: (){},
              leading: Icon(FontAwesomeIcons.solidThumbsUp, color:  Theme.of(context).accentColor,),
              title: Text('rate_us'.tr(), style: style),
              
            ),
          
           Divider(
             color: Colors.grey,
             height: 5.0,
             thickness: 1.5,
           ),
           
           SizedBox(height: 10,),
           ListTile(
              onTap: () => nextScreen(context, Alarm()),
              leading: Icon(FontAwesomeIcons.userClock, color: Theme.of(context).accentColor,),
              title: Text('reminders'.tr(), style: style),
              
            ),
             Divider(
             color: Colors.grey,
             height: 5.0,
             thickness: 1.5,
           ),
           ListTile(
              onTap: () => {},
              leading: Icon(FontAwesomeIcons.codeBranch, color:   Theme.of(context).accentColor,),
              title: Text('app_version'.tr(), style: style),
              subtitle: Text(appVersion, style: TextStyle(fontSize: 16),),
              
            ),
             Divider(
             color: Colors.grey,
             height: 5.0,
             thickness: 1.5,
           ),
            Container(
             
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Theme.of(context).accentColor,),
                title: Text('member_since'.tr(), style: style,),
                subtitle: Text(ub.joiningDate, style: TextStyle(fontSize: 16),),
              ),
            ),

      ],),
      ),
    );
  }
}