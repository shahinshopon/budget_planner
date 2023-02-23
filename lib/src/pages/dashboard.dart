import 'dart:collection';

import 'package:budget_planner/src/model/category.dart';
import 'package:budget_planner/src/model/expense.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/utils/utils.dart';
import 'package:budget_planner/src/widgets/card_expense_month.dart';
import 'package:budget_planner/src/widgets/chart_categories_list.dart';
import 'package:budget_planner/src/widgets/circularPieChart.dart';
import 'package:budget_planner/src/widgets/line_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardPage extends StatefulWidget {
  

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  
   String tabMonth, monthLabel;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
   Stream<QuerySnapshot> query;
  final _prefs = new UserPrefs();
   String user;
   List<Expense> expenses;
   int month;

  @override
  void initState() {
    super.initState();
    user = _prefs.userId;
    DateTime now = DateTime.now();
     tabMonth = '${now.month.toString()}${now.year.toString()}';
    
     monthLabel = '${labelMonth(tabMonth.substring(0,3))}'+' ${now.year.toString()}';
    month = now.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('dashboard'.tr(),
      style: TextStyle(
            color:  Colors.white,
            fontSize: 22,
            letterSpacing: 0.338,
            fontFamily: "montserrat-Regular",
            fontWeight: FontWeight.w700,
          ),),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      ),
      body:CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([

              Column(
                children: [
                  StreamBuilder(
                    stream: query =  Firestore.instance
                          .collection('users')
                          .document(user)
                          .collection('expenses')
                          .where('tabMonthExp', isEqualTo: tabMonth )
                          .orderBy('day')
                          .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
                      if (data.connectionState == ConnectionState.active) {
                        if (data.data.documents.length > 0  ){
                          expenses = data.data.documents.map((data) => Expense.fromMap(data.data)).toList();
                          double monthChange = expenses.map((exp) => exp.value).fold(0.0, (a, b) => a + b);
                          dynamic days = daysInMonth(month);
                           List<double> perDay = List.generate(days, (int index) {
                            return expenses.where((exp) => exp.day == (index + 1))
                                .map((exp) => exp.value)
                                .fold(0.0, (a, b) => a + b);
                          });

                          List<String> creditCards = [];
                          expenses.forEach((e) { 
                            if(!creditCards.contains(e.budget)){
                              creditCards.add(e.budget);
                            }
                          });
                          
                          List<Map> cardsExpensed = [];
                          for (var i = 0; i < creditCards.length; i++) {
                            Map<String, dynamic> map = new HashMap();
                            double expend;
                            double total = 0;
                            map['bank'] = creditCards[i];
                            
                            expenses.forEach((e) { 
                              if(e.budget == creditCards[i]){
                                expend = e.value;
                                total  = expend + total;
                              }

                            });
                            map['expend'] = total;
                            cardsExpensed.add(map);
                          }
                        
           
                          List<Map> chartDataList = [];
                          for (var i = 0; i < expenses.length; i++) {
                            Map<String, dynamic> map = new HashMap();
                            map['expend'] = expenses[i].value.toString();
                            map['transaction'] = expenses[i].dateCreate;
                            map['place'] = expenses[i].place;
                            map['category'] = Category(
                              timestamp: expenses[i].category,
                              categoryName: expenses[i].category,
                              color: expenses[i].categoryColor,
                              icon: expenses[i].categoryIcon,

                            );
                            chartDataList.add(map);
                          }

                           return Column(
                            children: [
                              Text('hi'.tr() + ' '+_prefs.userName +  'charges'.tr(), style: TextStyle(
                                  color:  Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 0.338,
                                  fontFamily: "montserrat-Regular",
                                  fontWeight: FontWeight.w800,
                                ),),
                              Text( monthLabel , style: TextStyle(
                                  color:  Colors.white,
                                  fontSize: 16,
                                  letterSpacing: 0.338,
                                  fontFamily: "montserrat-Regular",
                                  fontWeight: FontWeight.w800,
                                ),),
                              _overviewExpenses(monthChange),
                              Container(
                                padding: EdgeInsets.only(left: 10,  right: 10),
                                child: Card(
                                  color: Colors.black,
                                  shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
                                  elevation: 10.0,
                                  child: CardExpenseMonth(cardExpnses:cardsExpensed ,),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15,  right: 15),
                                child: LineChartPage(data: perDay, max: monthChange +1000,)
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10, left:10, top: 5),
                                child: Card(
                                  color: Colors.black,
                                  shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
                                  elevation: 10.0,
                                  child: Column(
                                    children: [
                                    //  CircularPieChart(chartDataList),
                                      ChartCategoriesList(categoriesList: chartDataList)
                                    ],
                                  )
                                )
                              )

                            ],
                          );
                        }else{
                          return  Container(
                            padding: EdgeInsets.all(12),
                            child: Card(
                                  clipBehavior: Clip.antiAlias,
                                shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                                elevation: 3.0,
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    
                                    Image.asset('assets/img/no_data.png'),
                                    SizedBox(height: 10),
                                    Text(
                                       'no_expenses'.tr() + " $monthLabel",
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                    SizedBox(height: 10),
                                  ],
                              ),
                                ),
                          );

                        }
                      }
                      return Column(
                        children: [
                          Text(monthLabel,style: TextStyle(
                                  color:  Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 0.338,
                                  fontFamily: "montserrat-Regular",
                                  fontWeight: FontWeight.w800,
                                ), ),
                          _overviewExpenses(0),
                          SizedBox(height: 150,),
                          
                          SpinKitFadingCircle(size: 50, color: Theme.of(context).accentColor),
                        ],
                      );
                    },
                  ),
                ],
              ),

             
            ])
          )
        ]
      ),
      
    );
  }

   Widget _overviewExpenses(double amount){
    return Container(
      padding: EdgeInsets.only(right: 12, left:12, top: 2),
      child: Card(
        color: Colors.black,
        shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'overview_expenses'.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "montserrat-Regular"),
                  ),
                ),
                Center(
                  child: Text(
                    "  \$${oCcy.format(amount)}",
                     style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "montserrat-Regular"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}