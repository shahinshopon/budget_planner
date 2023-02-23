
import 'package:budget_planner/src/model/budget.dart';
import 'package:budget_planner/src/model/income.dart';
import 'package:budget_planner/src/pages/incomes/edit_income.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/utils/utils.dart';
import 'package:budget_planner/src/widgets/budgets_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../widgets/budget_temp_card.dart';

class IncomesPage extends StatefulWidget {
  @override
  _IncomesPageState createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> 
with TickerProviderStateMixin{
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final _prefs = new UserPrefs();
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  List<Tab> _tabsList = [];
   TabController _tabController;
   Stream<QuerySnapshot> query;
   Stream<QuerySnapshot> _query;
   Stream<QuerySnapshot> queryExp;
   String user, budgetSelected, tabMonth;
   int month, year;
   List<Budget> budgets;
   List<Income> incomes;
  Budget budget = new Budget();
   Color selectedColor;
  Color colorIncome = Color(0xff07A82D);

   @override
  void dispose() {
    if (_tabController != null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = _prefs.userId;
    budgetSelected = _prefs.currentBudget;
    month = new DateTime.now().month;
    year = new DateTime.now().year;
    DateTime now = DateTime.now();
    tabMonth = '${now.month.toString()}${now.year.toString()}';
    
    
    
  }

   void _showBudgets(){
    
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
                                            budgetSelected = budgets[index].timestamp;
                                            _prefs.currentBudget = budgets[index].timestamp;
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
    return StreamBuilder(
      stream: query = Firestore.instance
                      .collection('users')
                      .document(user)
                      .collection('budgets')
                      .where('timestamp', isEqualTo: budgetSelected)
                      .snapshots(), 
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
        if (data.connectionState == ConnectionState.active) {
          if (data.data.documents.length > 0  ){
             budgets = data.data.documents.map((data) => Budget.fromMap(data.data)).toList();
             budget = budgets[0];
             selectedColor = Color(int.parse(budget.color));

             if(budget.months.isEmpty){
               return Container(
                 child: Column(
                   children: [
                     AppBar(
                      backgroundColor: Colors.transparent,
                      title: Text(
                          'incomes'.tr(),
                          style: TextStyle( fontSize: 22, letterSpacing: 0.338, fontFamily: "montserrat-Regular", fontWeight: FontWeight.w400),
                      ),
                      elevation: 0,
                      centerTitle: true,
                    ),
                    InkWell(
                      onTap: _showBudgets,
                      child: budget.monthlyBudget ? BudgetCard(budget: budget, selectedColor: Color( int.parse(budget.color),) , context: context, oCcy: oCcy) :
                                        BudgetTempCard(budget: budget, selectedColor:  Color( int.parse(budget.color),), context: context, oCcy: oCcy, startDate: budget.startDate, endDate: budget.endDate)
                    ),
                    Container(
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
                              'add_expense'.tr()+" ${budget.name}"+'choose_one_card'.tr(),
                              style: Theme.of(context).textTheme.caption,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                          ],
                      ),
                        ),
                  ),
                   ],
                 ),
               );
             }else{
               return prepareBody(budget.months);
             }
          }
          return Container(

              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                      children: [
                  _appBarWidget(),
                  InkWell(
                    onTap: _showBudgets,
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
                              'add_expense'.tr()+" ${budget.name}"+'choose_one_card'.tr(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                            SizedBox(height: 10),
                          ],
                      ),
                        ),
                  ),
                ],
              ),
            );
        }
        return Center( child: Column(
          children: [
           _appBarWidget(),
            SizedBox(height: 150,),
            SpinKitFadingCircle(size: 50, color: Theme.of(context).accentColor),
            SizedBox(height: 50,),
            
          ],
        ));
      },
    );
  }
  Widget _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
        title: Text(
             'incomes'.tr(),
             style: TextStyle( fontSize: 22, letterSpacing: 0.338, fontFamily: "montserrat-Regular", fontWeight: FontWeight.w400),
        ),
        elevation: 0,
        centerTitle: true,
    );
  
  }

  Widget prepareBody(List<dynamic> monthsExp) {
     int currentMont;
    for (var i = 0; i < monthsExp.length; i++) {
      
      if(monthsExp[i] == tabMonth){
        currentMont = i;
      }
    }
     
     _tabsList.clear();
     if (monthsExp.isNotEmpty) {
      this._tabsList = monthsExp.map((month) {
       
        String tempMonth = month;
        
        String monthLabel = '${labelMonth(tempMonth.substring(0,3))}'' ${tempMonth.substring(month.length-4,month.length)}';
        
        
        return Tab(
          text: monthLabel,
        );
      }).toList();

      _tabController = TabController(vsync: this, length: _tabsList.length);
      if (_tabsList.length > 1) {
        
        _tabController.animateTo(currentMont);
      }

      return DefaultTabController(
        length: _tabsList.length,
        child: _parentView(),
      );
    }else {
      return _parentView();
    }
  }

    Widget _parentView() {
    return Scaffold(
      appBar: _appBar(),
      key: _scaffold,
      body: _body(),
    );
  }

    _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
        title: Text(
             'incomes'.tr(),
             style: TextStyle( fontSize: 22, letterSpacing: 0.338, fontFamily: "montserrat-Regular", fontWeight: FontWeight.w400),
        ),
        elevation: 0,
        centerTitle: true,
        bottom: _tabsList.isNotEmpty
            ? TabBar(
                controller: _tabController,
                tabs: _tabsList,
                isScrollable: true,
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size(0, 0),
              ));
  }

   Widget _body() {
     return TabBarView(
        // ignore: sort_child_properties_last
        children: _tabsList.map((Tab tab) {
          return _loadIncomes(tab.text);
        }).toList(),
        controller: _tabController,
      );
   }

    Widget _loadIncomes(String selectedMonth) {
     String tabMonthLabel = labelToInt(selectedMonth);
     queryExp = Firestore.instance
                      .collection('users')
                      .document(user)
                      .collection('incomes')
                      .where('budgetTimestamp', isEqualTo: budgetSelected)
                      .where("tabMonth", isEqualTo: tabMonthLabel)
                      .orderBy('day', descending: true)
                      .snapshots();
     return CustomScrollView(
       slivers: <Widget>[
         SliverList(
           delegate: SliverChildListDelegate([
             Column(
               children: [
                  InkWell(
                    onTap: _showBudgets,
                     child: budget.monthlyBudget? BudgetCard(budget: budget, selectedColor: Color( int.parse(budget.color),) , context: context, oCcy: oCcy) :
                                        BudgetTempCard(budget: budget, selectedColor:  Color( int.parse(budget.color),), context: context, oCcy: oCcy, startDate: budget.startDate, endDate: budget.endDate)
                     
                    ),
                  StreamBuilder(
                    stream: queryExp,
                    builder: (_, AsyncSnapshot<QuerySnapshot> data){
                      if (data.connectionState == ConnectionState.active) {
                        if (data.data.documents.length > 0  ){
                          incomes = data.data.documents.map((data) => Income.fromMap(data.data)).toList();
                          double monthChange = incomes.map((inc) => inc.income).fold(0.0, (a, b) => a + b);
                          
                            return Column(
                              children: [
                                monthlyIncomes( monthChange),
                                _showIncomes(incomes)
                              ],
                            );
                        }
                      }
                      return SpinKitFadingCircle(size: 50, color: Theme.of(context).accentColor);
                    }
                  )
               ],
             )
           ])
         )
       ]
     );

   }

    Widget monthlyIncomes( double amount ){
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
                    'income_month'.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "montserrat-Regular"),
                  ),
                ),
                Center(
                  child: Text(
                    " + \$${oCcy.format(amount)}",
                     style: TextStyle(
                        color: budget.color == null ? selectedColor : Color( int.parse(budget.color)),
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

  Widget _showIncomes(List<Income> incomes){
    double width = MediaQuery.of(context).size.width * 0.60;
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only( left: 12, right: 12),
              child: InkWell(
                onTap: ()=>  Navigator.push(context, MaterialPageRoute(builder: (context) => EditIncomePage(budget: budget, income: incomes[index],))),
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
                                  incomes[index].dateCreate,
                                  style: TextStyle(
                                    color: Colors.grey[200],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                                Text(
                                  '\$${oCcy.format(incomes[index].lastValue)} + \$${oCcy.format(incomes[index].income)}, \$${oCcy.format( incomes[index].lastValue + incomes[index].income)}',
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
                                        '+ \$${oCcy.format(incomes[index].income)}',
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: budget.color == null ? selectedColor : Color( int.parse(budget.color)),
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
                        incomes[index].notes == 'note' ? Container(): Container(
                                    padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.edit),
                                        Container(
                                          width: width,
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          child: Text(
                                            incomes[index].notes == null ? 'income_notes'.tr() : incomes[index].notes,
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
              ),
            );
          }, 
          separatorBuilder: (_, index) {
                return SizedBox(height: 1.0);
              }, 
          itemCount: incomes.length
        )
      ],
    );
  }

  

  
}