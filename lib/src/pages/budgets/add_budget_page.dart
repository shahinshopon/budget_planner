
import 'package:budget_planner/src/model/budget.dart';
import 'package:budget_planner/src/utils/dialog.dart';
import 'package:budget_planner/src/utils/utils.dart';
import 'package:budget_planner/src/widgets/budgets_card.dart';
import 'package:budget_planner/src/widgets/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../user_preferences/user_preferences.dart';


class AddBudgetPage extends StatefulWidget {


  @override
  _AddBudgetPageState createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
   final oCcy = new NumberFormat("#,##0.00", "en_US");
  final formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _prefs =  UserPrefs();
  Budget budget =  Budget();

   String name = "Budget Name", color, typeBudget, timestamp, date, dateCreate, dateUpdate, startDate, endDate;
  double initIncome = 0, balance = 0, expenses = 0, planIncome= 0; 
   bool monthlyBudget, _saving = true;
   int selectedColorIndex = 0, monthBudget;
  Color selectedColor = Color.fromRGBO(8, 185, 198, 1);

  Future getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat.yMMMd().format(now.toLocal());
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      date = _date;
      timestamp = _timestamp;
      dateCreate = date;
      dateUpdate = _timestamp;
      startDate = date;
      endDate = date;
    });

  }

  @override
  void initState() {
    super.initState();
    color = selectedColor.value.toString();
    monthBudget = 1;
    monthlyBudget = true;
    typeBudget = 'montly';
    
  }

  @override
  Widget build(BuildContext context) {

     final  budgetEdit  = ModalRoute.of(context).settings.arguments;
    if(budgetEdit != null){ budget = budgetEdit as Budget; }
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('new_month_budget'.tr(), 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontFamily: "montserrat-Regular", fontSize: 18.0, letterSpacing: 0.338,) ),
        centerTitle: true,
         actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor,),
            onPressed: (){Navigator.of(context).pop();},
        )],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Form(
                key: formkey,
                child: Column(
                children: <Widget>[
                  BudgetCard(budget: budget, selectedColor: selectedColor, context: context, oCcy: oCcy, ),
                  colorsListWidget(),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      initialValue: budget.name == null ? '' : budget.name,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'hint_budget_name'.tr(),
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          Icons.edit,
                          color: budget.color == null ? selectedColor : Color( int.parse(budget.color))
                        ),
                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                        border: InputBorder.none,
                      ),
                      validator: (value){
                        if(value.isEmpty) return 'empty_value'.tr(); return null;
                      },
                      onChanged: (String value ) => setState(() {
                          name = value;
                          budget.name = name;
                      }),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                            maxLength: 7,
                            initialValue: budget.initialIncome == null ? '': budget.initialIncome.toString(),
                            onChanged: (value) {
                              setState(() {
                                  if( value.isNotEmpty && !isNumeric(value)){
                                  initIncome = double.parse(value).abs();
                                  budget.initialIncome = initIncome;
                                }else {
                                  initIncome = 0;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: 20),
                              border: InputBorder.none,
                              hintText: 'hint_initial_income'.tr(),
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: Icon(
                                FontAwesomeIcons.moneyBill,
                                color:  budget.color == null ? selectedColor : Color( int.parse(budget.color))
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              // ignore: deprecated_member_use
                              // BlacklistingTextInputFormatter(
                              //   new RegExp('[\\,|\\-]'),
                              // ),
                            ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                            maxLength: 7,
                            initialValue: budget.planIncome == null ? '': budget.planIncome.toString(),
                            onChanged: (value) {
                              setState(() {
                                  if( value.isNotEmpty && !isNumeric(value)){
                                  planIncome = double.parse(value).abs();
                                  budget.planIncome = planIncome;
                                }else {
                                  planIncome = 0;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: 20),
                              border: InputBorder.none,
                              hintText: 'hint_plan_income_month'.tr(),
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: Icon(
                                FontAwesomeIcons.moneyBill,
                                color:  budget.color == null ? selectedColor : Color( int.parse(budget.color))
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              // ignore: deprecated_member_use
                              // BlacklistingTextInputFormatter(
                              //   new RegExp('[\\,|\\-]'),
                              // ),
                            ],
                    ),
                  ),
                 
                  _saving ? Button(icon: FontAwesomeIcons.save, title: 'submit'.tr(), callback: _submit, color: budget.color == null ? selectedColor : Color( int.parse(budget.color)) ):  Center(
                      child: SpinKitFadingCircle(
                        size: 50,
                        color: Theme.of(context).accentColor,
                      ),
                  ),

                ],
              ))
            ])
          )
        ]
      )
    );
  }

  Widget colorsListWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 14, right: 10),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              selectedColor = colorsList[index];
              selectedColorIndex = index;
              setState(() {
                color = selectedColor.value.toString();
                budget.color = color;
                
              });
            },
            child: colorWidget(index, colorsList[index]),
          );
        },
        itemCount: colorsList.length,
      ),
    );
  }

  Widget colorWidget(int index, Color color) {
    if (index == selectedColorIndex) {
      return Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              color: colorsList[index],
            ),
            Container(
              height: 40,
              width: 40,
              color: Colors.black12,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(5),
        height: 40,
        width: 40,
        color: colorsList[index],
      );
    }
  }

  void _submit() async {

     if(formkey.currentState.validate()){
      formkey.currentState.validate();

      setState(() { _saving = false; });

      if( budget.timestamp == null){
         if( name != null ){
        await getDate().then((value) => uploadTempBudget().then((_) {
          openDialog(context, '', 'saved_budget_successfully'.tr());
        
        }));
         
      }else{
        openDialog(context, '', 'valid_name'.tr());
      }
      }else{
        await updateTempBudget().then((_) {
          openDialog(context, '', 'updated'.tr());
          _prefs.currentBudget = budget.timestamp;
        });
      }
     }
  }

  Future uploadTempBudget() async {
    String user = _prefs.userId;
    await Firestore.instance.collection('users').document(user).collection('budgets').document(timestamp).setData({
       
        'timestamp'    : timestamp,
        'name'         : name,
        'color'        : color,
        'incomes'      : initIncome,
        'initialIncome' : initIncome,
        'planIncome'   : planIncome,
        'expenses'     : expenses,
        'balance'      : initIncome,
        'dateCreate'   : dateCreate,
        'dateUpdate'   : dateUpdate,
        'typeBudget'   : typeBudget,
        'startDate'    : startDate,
        'monthlyBudget': monthlyBudget,
        'endDate'      : endDate,
        'monthBudget'  : monthBudget,
        'months'       : [],
        'monthsExp'    : []
    });
    _prefs.currentBudget = timestamp;
    Navigator.of(context).pop();
  }

  Future updateTempBudget() async {
    String user = _prefs.userId;
     DateTime now = DateTime.now();
    String _update = DateFormat('yyyyMMddHHmmss').format(now);
    budget.dateUpdate =  _update;
    await Firestore.instance.collection('users').document(user).collection('budgets').document(budget.timestamp).updateData({
       
        'timestamp'    : budget.timestamp,
        'name'         : budget.name,
        'color'        : budget.color,
        'initialIncome' : budget.initialIncome,
        'planIncome'   : budget.planIncome,
        'expenses'     : budget.expenses,
        'balance'      : budget.balance,
        'dateCreate'   : budget.dateCreate,
        'dateUpdate'   : budget.dateUpdate,
        'typeBudget'   : budget.typeBudget,
        'startDate'    : budget.startDate,
        'monthlyBudget': budget.monthlyBudget,
        'endDate'      : budget.endDate,
        'monthBudget'  : budget.monthBudget,
        'months'       : budget.months
    });
    _prefs.currentBudget = budget.timestamp;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}

