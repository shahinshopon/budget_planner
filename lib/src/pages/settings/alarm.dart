import 'dart:convert';

import 'package:budget_planner/src/pages/settings/reminder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:meditation/screens/reminder/reminder-stats.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

 Time timeofalarm;
var showtime;
List<String> multipleAlarm = [];

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class _AlarmState extends State<Alarm> {
  
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =  AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var initializationSettingsIOS =  IOSInitializationSettings(
        // onDidReceiveLocalNotification: onDidReceiveLocalNotification
        );
    var initializationSettings =  InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    getalarmtime();
  }

  getalarmtime() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    setState(() {
      if (myPrefs.getStringList("multipleAlarm") != null) {
        multipleAlarm = myPrefs.getStringList("multipleAlarm");
      }
    });
  }

  selecttime(BuildContext context) async {
    TimeOfDay selectedTimeRTL = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTimeRTL != null) {
      int hour = selectedTimeRTL.hour;
      int min = selectedTimeRTL.minute;
      timeofalarm = Time(hour, min, 0);
      setState(() {
        showtime = TimeOfDay(hour: hour, minute: min).format(context);
      });
      SharedPreferences myPrefs = await SharedPreferences.getInstance();

      if (!multipleAlarm
          .any((alarm) => alarm.contains('${selectedTimeRTL.hashCode}'))) {
        var data =
            jsonEncode({'id': selectedTimeRTL.hashCode, 'time': showtime});

        multipleAlarm.add(data);
        myPrefs.setStringList("multipleAlarm", multipleAlarm);
        // myPrefs.setString('alarm_time', '$showtime');

        if (timeofalarm != null) {
          scheduledalarm(selectedTimeRTL.hashCode, timeofalarm);
          /* snackbar('Daily reminder set for $showtime.'); */
        }
      } else {
        /* snackbar('Reminder Already exist for $showtime'); */
      }
    }
  }


  Future scheduledalarm(int id, var timeofalarm) async {
    var scheduledNotificationDateTime =
        Time(timeofalarm.hour, timeofalarm.minute);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your  channel name', 'your  channel description',
        //sound: 'sd',
        //autoCancel: true,
        playSound: true,
        color: Theme.of(context).accentColor,
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "sd.aiff", presentSound: true);

    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        //for multiple alarm give unique id each time as--> DateTime.now().millisecond,
        id,
        'title_reminder'.tr(),
        '$showtime'+ 'msg_reminder'.tr(),
        scheduledNotificationDateTime,
        platformChannelSpecifics);
   
  }

  // ignore: missing_return
  Future<dynamic> onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    // showDialog(
    //   context: context,
    //   builder: (_) => Container()
    //   // new AlertDialog(
    //   //   title: new Text('Alarm'),
    //   //   content: new Text('$alarmtime'),
    //   // ),
    // );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Notification', 'Flutter Local Notification', platform,
        payload: 'your alarm ');
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Text('reminders'.tr(),style: TextStyle(
              color:  Colors.white,
              fontSize: 22,
              letterSpacing: 0.338,
             
              fontWeight: FontWeight.w400,
            ),),
            actions: <Widget>[
          IconButton(icon: Icon(FontAwesomeIcons.plus), color: Theme.of(context).accentColor, onPressed: () => selecttime(context))
        ],
            ),
          body: SingleChildScrollView(
          child:Builder(
          builder: (context) => 
           Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(text: "\n"),
                        TextSpan(
                          text: 'set_reminder'.tr(),
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: "\n"),
                        TextSpan(
                          text:
                             'msg_set_reminder'.tr(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ]),
                    ),
                SizedBox(
                  height: 20,
                ),
                Reminder(),
           
                SizedBox(
                  height: MediaQuery.of(context).size.height * .07,
                ),
                multipleAlarm != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: multipleAlarm.length,
                        itemBuilder: (context, index) {
                          var alarm = jsonDecode(multipleAlarm[index]);

                          return Dismissible(
                            secondaryBackground: Container(
                                padding: EdgeInsets.only(right: 20),
                                color: Theme.of(context).accentColor,
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )),
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            
                            onDismissed: (direction) async {
                              SharedPreferences myPrefs =
                                  await SharedPreferences.getInstance();

                              await flutterLocalNotificationsPlugin
                                  .cancel(jsonDecode(multipleAlarm[index])['id']);
                              multipleAlarm.removeAt(index);
                              myPrefs.setStringList(
                                  "multipleAlarm", multipleAlarm);

                              setState(() {
                                multipleAlarm =
                                    myPrefs.getStringList("multipleAlarm");
                              });

                              /* snackbar(
                                  "Reminder for ${alarm['time']} is removed !"); */
                            },
                            background: Container(color: Theme.of(context).accentColor),
                            child: Card(
                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0)),
                                clipBehavior: Clip.antiAlias,
                               
                                elevation: 5,
                              child: ListTile(
                                title: Text(
                                  "${alarm['time']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox(),
                
              ],
            
        ),
          )
          )
          )
          );
  }
}
