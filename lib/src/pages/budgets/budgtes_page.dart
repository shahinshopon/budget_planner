import 'package:budget_planner/src/model/budget.dart';
import 'package:budget_planner/src/model/img.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/widgets/budget_temp_card.dart';
import 'package:budget_planner/src/widgets/budgets_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class BudgetsPage extends StatefulWidget {


  @override
  _BudgetsPageState createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final _prefs = new UserPrefs();
   List<Budget> budgets;
   Stream<QuerySnapshot> _query;


  @override
  Widget build(BuildContext context) {
    String user = _prefs.userId;
    
   _query = Firestore.instance
            .collection('users')
            .document(user)
            .collection('budgets')
            .orderBy('dateUpdate', descending: true)
            .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
            'budgets'.tr(),
             style: TextStyle( fontSize: 22, letterSpacing: 0.338, fontFamily: "montserrat-Regular", fontWeight: FontWeight.w400),
        ),
        elevation: 0.0,
        centerTitle: true, 
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 645,
              child: StreamBuilder<QuerySnapshot>(
                stream: _query ,
                builder: (_, AsyncSnapshot<QuerySnapshot> data){
                  if (data.connectionState == ConnectionState.active) {
                    if (data.data.documents.length > 0  ){
                      budgets = data.data.documents.map((data) => Budget.fromMap(data.data)).toList();
                      return ListView.builder(
                        itemCount: budgets.length,
                        itemBuilder:(_, int index){
                         
                          return Container( 
                            //padding: EdgeInsets.only(left: 18, right: 18, top: 10),
                            child: Hero(tag: budgets[index].timestamp, 
                            child: InkWell(
                              onTap: () =>  Navigator.pushNamed(context, 'budgetOpt',  arguments: budgets[index]),
                              child: budgets[index].monthlyBudget ? BudgetCard(budget: budgets[index], selectedColor: Color( int.parse(budgets[index].color),) , context: context, oCcy: oCcy) :
                              BudgetTempCard(budget: budgets[index], selectedColor:  Color( int.parse(budgets[index].color),), context: context, oCcy: oCcy, startDate: budgets[index].startDate, endDate: budgets[index].endDate)
                              
                            )
                            ),
                          );
                        }
                      );
                    }
                    return Center(
                        child: Column(
                          children: <Widget>[
                          SizedBox(height: 30,),
                          Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                              elevation: 3.0,
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(Img.get('no_data.png')),
                                ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Text(
                                'add_budget'.tr(),
                                style: TextStyle( color: Theme.of(context).accentColor, letterSpacing: 1.5, fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                    );
                  }
                  return Center( child: SpinKitFadingCircle(
                          size: 50,
                          color: Theme.of(context).accentColor,
                        ), );
                },
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}

