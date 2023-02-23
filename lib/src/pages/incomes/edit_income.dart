
import 'package:budget_planner/src/model/budget.dart';
import 'package:budget_planner/src/model/income.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/utils/dialog.dart';
import 'package:budget_planner/src/utils/utils.dart';
import 'package:budget_planner/src/widgets/budget_temp_card.dart';
import 'package:budget_planner/src/widgets/budgets_card.dart';
import 'package:budget_planner/src/widgets/button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EditIncomePage extends StatefulWidget {

  final Budget budget;
  final Income income;

  const EditIncomePage({@required this.budget, @required this.income});

  @override
  _EditIncomePageState createState() => _EditIncomePageState(
     this.budget,
     this.income
  );
}

class _EditIncomePageState extends State<EditIncomePage> {

  _EditIncomePageState(
    this.budget,
    this.income
  );

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final formkey = GlobalKey<FormState>();
  final _prefs = new UserPrefs();
  Income income = new Income();
  bool  _saving = true;
   String user;
  double newIncomeValue = 0;
  Stream<QuerySnapshot> _query;
  Budget budget = new Budget();
  Color colorIncome = Color(0xff07A82D);
  double currentIncome;

  

   @override
  void initState() {
    super.initState();
    user = _prefs.userId;
    currentIncome = income.income;
  }

  

   void _showBudgets(){
   // income.budgetTimestamp = null;
    setState(() {});
    _query = Firestore.instance
                        .collection('users')
                        .document(user)
                        .collection('budgets')
                        .orderBy('dateUpdate', descending: true)
                        .snapshots();
     List<Budget> budgets;

    showModalBottomSheet(
      context: (context),
      builder: (context){
        return Container(
          height: 500,
          color: Theme.of(context).primaryColor,
          child: Column(
           
            children: [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2),
                  child: Column(
                    
                    children: <Widget>[
                      Text(
                        'choose_budget'.tr(),
                        style: TextStyle(
                            color: Colors.blueGrey[300],
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      SizedBox(
                        height: 335,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _query ,
                          builder: (_, AsyncSnapshot<QuerySnapshot> data){
                            if (data.connectionState == ConnectionState.active) {
                              if (data.data.documents.length > 0  ){
                                budgets = data.data.documents.map((data) => Budget.fromMap(data.data)).toList();
                                return ListView.builder(
                                  itemCount: budgets.length,
                                  itemBuilder: (_, int index){
                                    return Container(
                                      child: Hero(tag: budgets[index].timestamp, 
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            budget = budgets[index];
                                            Navigator.pop(context);
                                          });                             
                                        },
                                        child: budgets[index].monthlyBudget ? BudgetCard(budget: budgets[index], selectedColor: Color( int.parse(budgets[index].color),) , context: context, oCcy: oCcy) :
                                        BudgetTempCard(budget: budgets[index], selectedColor:  Color( int.parse(budgets[index].color),), context: context, oCcy: oCcy, startDate: budgets[index].startDate, endDate: budgets[index].endDate)
                                        
                                      )
                                      ),
                                    );
                                  }
                                );
                              }
                              return Center(
                                child: Text(
                                'add_budget'.tr(),
                                style: TextStyle( color: Theme.of(context).accentColor, letterSpacing: 1.5, fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                              );
                            }return Center( child: SpinKitFadingCircle(
                              size: 50,
                              color: Theme.of(context).accentColor,
                            ), );
                          }

                        ),
                      ),

                    ],
                  ),
                ),
            ],
          ),
        );
      }
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('income_edit'.tr(), 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontFamily: "montserrat-Regular", fontSize: 20.0, letterSpacing: 0.338,) ),
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
                     children: [
                      InkWell(
                        onTap: _showBudgets,
                        child:  budget.monthlyBudget ?  BudgetCard(budget: budget, selectedColor: Color(int.parse(budget.color)), context: context, oCcy: oCcy) : 
                      BudgetTempCard(budget: budget, selectedColor: Color(int.parse(budget.color)), context: context, oCcy: oCcy, startDate: budget.startDate, endDate: budget.endDate),
                      ),
                      _incomeCard(),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                            initialValue: income.income.toString(),
                                  maxLength: 7,
                                  onChanged: (value) {
                                    setState(() {
                                        if( value.isNotEmpty && !isNumeric(value)){
                                        income.income = double.parse(value).abs();
                                        
                                      }else {
                                          income.income = 0;
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(right: 20),
                                    border: InputBorder.none,
                                    hintText: 'enter_income'.tr(),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    icon: Icon(
                                      FontAwesomeIcons.moneyBill,
                                      color: Color( int.parse(budget.color))
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
                          initialValue: income.notes,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          maxLength:35,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'notes'.tr(),
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: Icon(
                              FontAwesomeIcons.edit,
                              color: Color( int.parse(budget.color))
                            ),
                            
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            border: InputBorder.none,
                            ),
                            validator: (value){
                              if(value.isEmpty) return 'some_notes'.tr(); return null;
                            },
                            onChanged: (String value ) => setState(() {
                              income.notes = value;
                            }),
                            style: TextStyle(color: Colors.white),
                          ),
                      ),
                       _saving ? Button(icon: FontAwesomeIcons.save, title: 'update'.tr(), callback: _submit, color:Color(int.parse(budget.color))):  Center(
                          child: SpinKitFadingCircle(
                            size: 50,
                            color: Theme.of(context).accentColor,
                          ),
                      ),
                      _saving ? Button(icon: FontAwesomeIcons.trash, title: 'delete'.tr(), callback: _deleteIncome, color:Color(int.parse(budget.color))):  Center(
                          child: SpinKitFadingCircle(
                            size: 50,
                            color: Theme.of(context).accentColor,
                          ),
                      ),
                     ],
                   ),
                 )
              ])
           )
         ]

      ),
    );
  }

  Widget _incomeCard(){
    double width = MediaQuery.of(context).size.width * 0.60;
    return Container(
      padding: EdgeInsets.only(top: 5, left: 15, right: 15),
      child: Card(
        color: Colors.black,
        shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        income.dateCreate,
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                      Text(
                        '\$${oCcy.format(income.lastValue)} + \$${oCcy.format(income.income)}, \$${oCcy.format( income.lastValue + income.income)}',
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 12,
                        ),
                      
                    ),
                  ],
                ),
                
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Container(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: colorIncome
                        ),
                        height: 45,
                        width: 45,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image(
                            image: AssetImage("icons/ic_money.png"),
                            color: Colors.white,
                          ),
                        ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'income'.tr(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  
                                ),
                              ),
                            ),
                            Text(
                              '+ \$${oCcy.format(income.income)}',
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color( int.parse(budget.color)),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                             
                          ],
                        ),
                        
                       
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.edit),
                              Container(
                                width: width,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  income.notes == null ? 'notes'.tr() : income.notes,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),

    );
  }

   void _submit() async {
     setState(() { _saving = false; });
    if(currentIncome != income.income){
      
      if(income.income > 0){
        await updateIncome().then((_) {
          updateBudgetIncomes();
          openDialog(context, '', 'income_updated'.tr());
        }
        );
      }
    }else{
      await updateIncome();
    } 
  }

  Future updateIncome() async {

    String budgetTimestamp = budget.timestamp;

    await Firestore.instance.collection('users').document(user).collection('incomes').document(income.timestamp).updateData({
       
        'income'          : income.income,
        'notes'           : income.notes,
        'lastValue'       : income.lastValue,
        'budgetTimestamp' : budgetTimestamp,
        'budgetName'      : budget.name,
    });
    Navigator.of(context).pop();
  }

  Future updateBudgetIncomes() async {
    budget.incomes = budget.incomes -currentIncome + income.income;
    budget.balance = budget.incomes - budget.expenses;
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
   
    await Firestore.instance.collection('users').document(user).collection('budgets').document(budget.timestamp).updateData({
       
        'incomes'       : budget.incomes,
        'dateUpdate'   : _timestamp,
        'balance'      : budget.balance,
        
    });
  }

  void _deleteIncome()async{
    setState(() { _saving = false; });
    budget.incomes = budget.incomes - currentIncome;
    budget.balance = budget.balance -currentIncome;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: Text('delete_income'.tr() +"\$${income.income.toString()}?" ),
          
          actions: <Widget>[
            ElevatedButton(
              child: Text('cancel'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() { _saving = true; });
              },
            ),
            ElevatedButton(
              child: Text('delete'.tr()),
              onPressed: deleteIncome
            )
          ],
        );
      },
    );


  }

  Future deleteIncome()async{
    updateBudgetIncomes();
    await Firestore.instance.collection('users').document(user).collection('incomes').document(income.timestamp).delete();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}