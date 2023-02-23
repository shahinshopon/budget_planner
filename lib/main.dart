import 'package:budget_planner/src/bloc/auth_bloc.dart';
import 'package:budget_planner/src/bloc/internet_bloc.dart';
import 'package:budget_planner/src/bloc/user_bloc.dart';
import 'package:budget_planner/src/pages/auth/splash_page.dart';
import 'package:budget_planner/src/pages/budgets/add_budget_page.dart';
import 'package:budget_planner/src/pages/budgets/add_budget_temp.dart';
import 'package:budget_planner/src/pages/budgets/budgtes_page.dart';
import 'package:budget_planner/src/pages/category/add_category.dart';
import 'package:budget_planner/src/pages/settings/adds.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = new UserPrefs();
  await prefs.initPrefs();
   runApp(
    EasyLocalization(
      child: MyApp(), 
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'MX'),
        
      ],
      
      path: 'assets/languages')
    
    );
}

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    
    super.initState();
   // FirebaseAdMob.instance.initialize(appId: Adds.appId);
  }

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        ChangeNotifierProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        ChangeNotifierProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
          title: 'BudPresupuestos',
         // localizationsDelegates: context.localizationDelegates,
          localizationsDelegates: [
            // GlobalMaterialLocalizations.delegate,
            // GlobalWidgetsLocalizations.delegate,
            // GlobalCupertinoLocalizations.delegate,
            // DefaultCupertinoLocalizations.delegate,
            EasyLocalization.of(context).delegate,
          ],
          supportedLocales: EasyLocalization.of(context).supportedLocales,
          locale: EasyLocalization.of(context).locale,
          theme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.green,
              primaryColor: Color.fromRGBO(9, 27, 46, 1),
              accentColor: Color.fromRGBO(0, 149, 100, 2.0),

              fontFamily: "montserrat-Regular",
              scaffoldBackgroundColor: Color.fromRGBO(9, 27, 46, 1),
              appBarTheme: AppBarTheme(
                color: Colors.white,
                elevation: 0,
                brightness:
                    Platform.isAndroid ? Brightness.dark : Brightness.light,
              )),
          debugShowCheckedModeBanner: false,
          routes: {
           
            'editCate'   : (BuildContext context) => AddCategory(),
            'budgetOpt'   : (BuildContext context) => BudgetsPage(),
            'mBudget'   : (BuildContext context) => AddBudgetPage(),
            'tBudget'   : (BuildContext context) => AddTempBudgetPage(),
            
            
          },
          home: SplashPage()),
    );
  }
}