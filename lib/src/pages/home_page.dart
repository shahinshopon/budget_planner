
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:budget_planner/src/banklin_icons.dart';
import 'package:budget_planner/src/pages/budgets/budgtes_page.dart';
import 'package:budget_planner/src/pages/category/category_list.dart';
import 'package:budget_planner/src/pages/cc_expenses/add_expense.dart';
import 'package:budget_planner/src/pages/cc_expenses/expenses_page.dart';
import 'package:budget_planner/src/pages/dashboard.dart';
import 'package:budget_planner/src/pages/incomes/add_incomes.dart';
import 'package:budget_planner/src/pages/incomes/incomes_page.dart';
import 'package:budget_planner/src/pages/profile_page.dart';
import 'package:budget_planner/src/pages/settings/adds.dart';
import 'package:budget_planner/src/utils/next_screen.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'budgets/add_budget_page.dart';
import 'budgets/add_budget_temp.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
   //InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  // @override
  // void initState() { 
  //   super.initState();
  //   _interstitialAd = InterstitialAd(
  //     adUnitId: Adds.inter,
  //     listener: (event){
  //       switch (event) {
  //         case MobileAdEvent.loaded:
  //           _isInterstitialAdReady = true;
  //           break;
  //         case MobileAdEvent.failedToLoad:
  //           _isInterstitialAdReady = false;
  //           break;
  //         case MobileAdEvent.closed:
  //           _play();
  //           break;
  //         default:
  //       }
  //     }
  //   );
  //   _interstitialAd.load();
  // }

  @override
  void dispose() {
    
    super.dispose();
    //_interstitialAd.dispose();
  }

  void _play() async{
   // await _interstitialAd.dispose();
   // _interstitialAd = null;
    
  }
  // void _show(){
  //   _interstitialAd = InterstitialAd(
  //                   adUnitId: Adds.inter,
  //                   listener: (event){
  //                     switch (event) {
  //                       case MobileAdEvent.loaded:
  //                         _isInterstitialAdReady = true;
  //                         break;
  //                       case MobileAdEvent.failedToLoad:
  //                         _isInterstitialAdReady = false;
  //                         break;
  //                       case MobileAdEvent.closed:
  //                         _play();
  //                         break;
  //                       default:
  //                     }
  //                   }
  //                 );
  //                 _interstitialAd.load();
  //                _isInterstitialAdReady ? _interstitialAd.show(): _play();
  // }

  Widget page = DashboardPage();
  int currentIndex = 0;

  whenBackButtonClicked() {
    if(currentIndex == 0){
      SystemNavigator.pop();
    }else{
      setState(() {
        currentIndex = 0;
        page = DashboardPage();
      });
    }
    
  }
  

   @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      
      bottomNavigationBar: customNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SpeedDial(
            overlayColor: Theme.of(context).accentColor,
            animatedIcon: AnimatedIcons.add_event,
            //marginRight: 28,
            //marginBottom: 110,
            children: [
              SpeedDialChild(
                child: Icon(BanklinIcons.plus),
                label: 'add_expense'.tr(), labelBackgroundColor: Colors.black, 
                onTap: (){
                 //  _show();
                  nextScreen(context, AddExpensePage());
                  
                  } 
              ),
               SpeedDialChild(
                child: Icon(BanklinIcons.plus),
                label: 'add_incomes'.tr(), labelBackgroundColor: Colors.black, 
                onTap: () {
                  // _show();
                  nextScreen(context, AddIncomePage());} 
              ),
               
              SpeedDialChild(
                child: Icon(BanklinIcons.plus),
                label: 'categorias'.tr(), labelBackgroundColor: Colors.black,
                onTap: () {
                 //  _show();
                  nextScreen(context, CategoryList());
                  } 
              ),
              SpeedDialChild(
                child: Icon(FontAwesomeIcons.moneyCheck),
                label: 'add_budget_temp'.tr(), labelBackgroundColor: Colors.black,
                onTap: () {
                 //  _show();
                  nextScreen(context, AddTempBudgetPage());
                } 
              ),
              SpeedDialChild(
                child: Icon(FontAwesomeIcons.moneyCheckAlt),
                label: 'add_budget_month'.tr(), labelBackgroundColor: Colors.black,
                onTap: () {
                //  _show();
                  nextScreen(context, AddBudgetPage());
                  } 
              ),
              
            ],
          ),
      body:page
    );
  }

  Widget customNavBar() { 
    return Container(
    
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).accentColor,
            blurRadius: 15
          )
        ]
      ),
      child: BottomNavyBar(
          selectedIndex: currentIndex,
          showElevation: true,
          itemCornerRadius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          onItemSelected: (index) => setState(() {
            currentIndex = index;
            if(index == 0) {
              page = DashboardPage();
            }else if(index == 1){
              page = ExpensesPage();
            }else if(index == 2){
              page = IncomesPage();
            }else if(index == 3){
              page = BudgetsPage();
            }else if(index == 4){
              page = ProfilePage();
            }
            
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(BanklinIcons.pie_chart),
              title: Text('dashboard'.tr()),
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(FontAwesomeIcons.list),
              title: Text('expense'.tr()),
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(BanklinIcons.business),
              title: Text('incomes'.tr()),
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            
            BottomNavyBarItem(
              icon: Icon(BanklinIcons.wallet),
              title: Text('budgets'.tr()),
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.white,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(BanklinIcons.settings),
              title: Text('profile'.tr()),
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.white,
              textAlign: TextAlign.center,
            ),
          ],
        ),
    );
  }

  
 

  
}