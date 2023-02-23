
import 'package:budget_planner/src/banklin_icons.dart';
import 'package:budget_planner/src/model/budget.dart';
import 'package:budget_planner/src/model/category.dart';
import 'package:budget_planner/src/model/expense.dart';
import 'package:budget_planner/src/pages/category/category_list.dart';
import 'package:budget_planner/src/pages/category/category_list_grid.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/utils/dialog.dart';
import 'package:budget_planner/src/utils/utils.dart';
import 'package:budget_planner/src/widgets/budget_temp_card.dart';
import 'package:budget_planner/src/widgets/budgets_card.dart';
import 'package:budget_planner/src/widgets/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';



class AddExpensePage extends StatefulWidget {
 

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> 
  implements CategorySelectionListener{
   final oCcy = new NumberFormat("#,##0.00", "en_US");
  final formkey = GlobalKey<FormState>();
  final _prefs = new UserPrefs();
  Expense expense = new Expense();
   Category _selectedCategory;
  bool  _saving = true;
   String user, startDate = '', endDate = '', date, timestamp, dateCreate, dateUpdate, place, notes,tabMonthExp;
  double valueExpense = 0;
   Stream<QuerySnapshot> _query;
  Budget budget = new Budget();
  Color selectedColor = Color.fromRGBO(8, 185, 198, 1);
   int day;
  DateTime _selectedExpeseDate = DateTime.now();
 
   @override
  void initState() {
    super.initState();
    user = _prefs.userId;
     if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => onWidgetBuild());
    }
    budget.monthlyBudget = true;
    budget.incomes = 0;
     DateTime now = DateTime.now();
    date = DateFormat.yMMMd().format(now.toLocal());
    dateCreate = DateFormat.yMMMd().format(_selectedExpeseDate.toLocal());
    day = _selectedExpeseDate.day;
    budget.name = 'budget_name'.tr();
  }

   Future getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat.yMMMd().format(now.toLocal());
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    
    setState(() {
      date = _date;
      timestamp = _timestamp;
      dateCreate = date;
      dateUpdate = _timestamp;
      day = now.day;
      tabMonthExp = '${now.month.toString()}${now.year.toString()}';
      
    });
  }

  void onWidgetBuild() {
    _showCategory();
    _showBudgets();
  }

   void _showBudgets(){
   // expense.budgetTimestamp = null;
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
                                            tabMonthExp = '${_selectedExpeseDate.month.toString()}${_selectedExpeseDate.year.toString()}';
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

void _showCategory() {
   // _selectedCategory = null;
    setState(() {});

    showModalBottomSheet(
        context: (context),
        builder: (builder) {
          return Container(
            height: 500,
            color: Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                 Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'choose_cat'.tr(),
                      style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryList(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
                Divider(),
                Expanded(
                  child: CategoryListGrid(this),
                ),
                
              ],
            ),
          );
        });
  }

  @override
  void onCategorySelected(Category category) {
    setState(() {
      _selectedCategory = category;
      expense.category = _selectedCategory.categoryName;
      expense.categoryColor = _selectedCategory.color;
      expense.categoryIcon = _selectedCategory.icon;
      Navigator.pop(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('new_expense'.tr(), 
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
                        child:  budget.monthlyBudget ?  BudgetCard(budget: budget, selectedColor: selectedColor, context: context, oCcy: oCcy) : 
                      BudgetTempCard(budget: budget, selectedColor: selectedColor, context: context, oCcy: oCcy, startDate: startDate, endDate: endDate),
                      ),
                      _expenseCard(),
                        Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectStarDate(context);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.calendarDay,
                                  color: expense.categoryColor == null ? selectedColor : Color( int.parse(expense.categoryColor))
                                ),
                                Text('date'.tr()),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                       "${DateFormat.yMMMd().format(_selectedExpeseDate.toLocal())}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: TextFormField(
                        maxLength: 7,
                        onChanged: (value) {
                          setState(() {
                              if( value.isNotEmpty && !isNumeric(value)){
                              valueExpense = double.parse(value).abs();
                             
                            }else {
                              valueExpense = 0;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(right: 20),
                          border: InputBorder.none,
                          hintText: '\$'+'value'.tr(),
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(
                            BanklinIcons.business,
                            color: expense.categoryColor == null ? selectedColor : Color( int.parse(expense.categoryColor))
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
                    padding: EdgeInsets.only(left: 20, right: 20, top: 5,),
                    child: TextFormField(
                      initialValue: expense.place == null ? '' : expense.place,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLength:25,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'place'.tr(),
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          BanklinIcons.signs,
                          color: expense.categoryColor == null ? selectedColor : Color( int.parse(expense.categoryColor))
                        ),
                        
                        contentPadding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                        border: InputBorder.none,
                        ),
                        validator: (value){
                          if(value.isEmpty) return 'some_place'.tr(); return null;
                        },
                        onChanged: (String value ) => setState(() {
                           
                           expense.place = value;
                        }),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      initialValue: expense.place == null ? '' : expense.place,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLength:35,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'notes'.tr(),
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          FontAwesomeIcons.edit,
                          color: expense.categoryColor == null ? selectedColor : Color( int.parse(expense.categoryColor))
                        ),
                        
                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                        border: InputBorder.none,
                        ),
                        
                        onChanged: (String value ) => setState(() {
                           expense.notes = value;
                        }),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                       _saving ? Button(icon: FontAwesomeIcons.save, title: 'submit'.tr(), callback: _submit, color:budget.color == null ? selectedColor : Color(int.parse(budget.color))):  Center(
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

   Future<Null> _selectStarDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _selectedExpeseDate == null ? DateTime.now() : _selectedExpeseDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now());
      if (picked != null && picked != _selectedExpeseDate) {
        setState(() {
          _selectedExpeseDate = picked;
         dateCreate = DateFormat.yMMMd().format(_selectedExpeseDate.toLocal());
         day = picked.day;
           tabMonthExp = '${_selectedExpeseDate.month.toString()}${_selectedExpeseDate.year.toString()}';
          
        });
      }
  }

    Widget _expenseCard(){
    double width = MediaQuery.of(context).size.width * 0.40;
    return Container(
      padding: EdgeInsets.only(top: 5, left: 12, right: 12),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                       Text(
                        dateCreate,
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 14,
                        ),
                      ),
                       Text(
                        budget.name,
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 14,
                        ),
                      ),

                  ],
                ),
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  InkWell(
                    onTap: _showCategory,
                    child: Container(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            color: expense.categoryColor == null ? Color.fromRGBO(8, 185, 198, 1) : Color( int.parse(expense.categoryColor)) 
                          ),
                          height: 65,
                          width: 65,
                          child: Container(
                            margin: EdgeInsets.all(13),
                            child: Image(
                              image: expense.categoryIcon == null ? AssetImage("icons/ic_money.png") : AssetImage(expense.categoryIcon),
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        expense.place == null ? Container(height: 20,): Container(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(BanklinIcons.signs),
                              Container(
                                width: width,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  expense.place == null ? 'place'.tr() : expense.place,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  expense.category == null ? 'category'.tr() : expense.category  ,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  
                                ),
                              ),
                            ),
                            Text(
                              '\$${oCcy.format(valueExpense)}',
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: expense.categoryColor== null ? selectedColor : Color( int.parse(expense.categoryColor)),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                        expense.notes == null ? Container(height: 20,):Container(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.edit),
                              Container(
                                width: width,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  expense.notes == null ? 'notes'.tr() : expense.notes,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                       SizedBox(height: 10,)

                      ],
                    ),
                  ),
                  
                ],
              ),
               SizedBox(height: 5,),
              
            ],
          ),
        ),
      ),

    );
  }

 

   void _submit() async {
    if(formkey.currentState.validate()){
      formkey.currentState.validate();
      if( valueExpense > 0){
        await getDate().then((value) => uploadExpense().then((_) {
          updateBudgetFound();
          openDialog(context, '', 'income_saved'.tr());
          
        }));
      }else{
        openDialog(context, '', 'income_value_valid'.tr());
      }
    } 
  }

  Future uploadExpense() async {
    setState(() { _saving = false; });
    if(expense.notes == null){expense.notes = 'note';}
    await Firestore.instance.collection('users').document(user).collection('expenses').document(timestamp).setData({
       
        'timestamp'           : timestamp,
        'tabMonthExp'         : tabMonthExp,
        'day'                 : day,
        'dateCreate'          : dateCreate,
        'category'            : expense.category,
        'categoryColor'       : expense.categoryColor,
        'categoryIcon'        : expense.categoryIcon,
        'notes'               : expense.notes,
        'value'               : valueExpense,
        'budget'              : budget.name,
        'place'               : expense.place,
        'budgetTimestamp'     : budget.timestamp,
    
        
    });
    Navigator.of(context).pop();
  }

  Future updateBudgetFound() async {
    double newExpensesValue = budget.expenses + valueExpense ;
    double balance = budget.incomes - newExpensesValue;
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
   
    if(budget.monthsExp.isEmpty){
      budget.monthsExp.add(tabMonthExp);
      
    }else{
      budget.months.forEach((e) { 
        if(!budget.months.contains(tabMonthExp)){
          budget.monthsExp.add(tabMonthExp);
           Firestore.instance.collection('users').document(user).collection('budgets').document(budget.timestamp).updateData({
       
        'expenses'       : newExpensesValue,
        'dateUpdate'   : _timestamp,
        'monthsExp'       : budget.monthsExp,
        'balance'      : balance,
        
        });
        }
      });
      
    }

    await Firestore.instance.collection('users').document(user).collection('budgets').document(budget.timestamp).updateData({
       
        'expenses'       : newExpensesValue,
        'dateUpdate'   : _timestamp,
        'monthsExp'       : budget.monthsExp,
        'balance'      : balance,
        
    });
  }
}