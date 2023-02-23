

import 'package:budget_planner/src/model/budget.dart';
import 'package:budget_planner/src/model/expense.dart';
import 'package:budget_planner/src/model/income.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/widgets/budget_temp_card.dart';
import 'package:budget_planner/src/widgets/budgets_card.dart';
import 'package:budget_planner/src/widgets/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BudgetOptPage extends StatefulWidget {


  @override
  _BudgetOptPageState createState() => _BudgetOptPageState();
}

class _BudgetOptPageState extends State<BudgetOptPage> {
  final formkey = GlobalKey<FormState>();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _prefs =  UserPrefs();
  Budget budget =  Budget();
  Color selectedColor = Color.fromRGBO(8, 185, 198, 1);
   String user;

  @override
  void initState() {
    super.initState();
    user = _prefs.userId;
  }

  @override
  Widget build(BuildContext context) {
    final  budgetEdit  = ModalRoute.of(context).settings.arguments;
    budget = budgetEdit as Budget;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(budget.name, 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontFamily: "montserrat-Regular", fontSize: 22.0, letterSpacing: 0.338,) ),
        centerTitle: true,
      ),
      body: Column(
        children: [
           budget.monthlyBudget ? BudgetCard(budget: budget, selectedColor: Color( int.parse(budget.color),) , context: context, oCcy: oCcy) :
              BudgetTempCard(budget: budget, selectedColor:  Color( int.parse(budget.color),), context: context, oCcy: oCcy, startDate: budget.startDate, endDate: budget.endDate),
          
        Button(icon: FontAwesomeIcons.solidEdit, title: 'edit_btn'.tr(), callback: (){
            if( budget.monthlyBudget ){
                                 Navigator.pushNamed(context, 'mBudget',  arguments: budget);
                               }else{
                                  Navigator.pushNamed(context, 'tBudget',  arguments: budget);
                               }
          }, color:  budget.color == null ? selectedColor : Color( int.parse(budget.color))),
        Button(icon: FontAwesomeIcons.trash, title: 'delete'.tr(), callback: _delete, color: budget.color == null ? selectedColor : Color( int.parse(budget.color))),
  

        ],
      ),
    );
  }



  void _delete() async {
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ask_delete'.tr()+ " ${budget.name}?"),
          content:Text('warnig_delete'.tr()),
          actions: <Widget>[
            ElevatedButton(
              child:  Text('cancel'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('delete_btn'.tr()),
              onPressed: () {
                deleteExpenses();
                deleteIncomes();
                Firestore.instance
                              .collection('users')
                              .document(user)
                              .collection('budgets')
                              .document(budget.timestamp)
                              .delete();
                
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void deleteExpenses() async{
    final QuerySnapshot snap = await Firestore.instance.collection('users/$user/expenses').where('budgetTimestamp', isEqualTo: budget.timestamp).getDocuments();
    List<Expense> expenses = snap.documents.map((data) => Expense.fromMap(data.data)).toList();
    print('se eliminaran ${expenses.length} gastos');

    for (var i = 0; i < expenses.length; i++) {
       Firestore.instance
                              .collection('users')
                              .document(user)
                              .collection('expenses')
                              .document(expenses[i].timestamp)
                              .delete(); 
    }

  }

  void deleteIncomes() async{
    final QuerySnapshot snap = await Firestore.instance.collection('users/$user/incomes').where('budgetTimestamp', isEqualTo: budget.timestamp).getDocuments();
    List<Income> incomes = snap.documents.map((data) => Income.fromMap(data.data)).toList();
   

     for (var i = 0; i < incomes.length; i++) {
       Firestore.instance
                              .collection('users')
                              .document(user)
                              .collection('incomes')
                              .document(incomes[i].timestamp)
                              .delete(); 
    }
    
  }
}