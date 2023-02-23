
import 'package:budget_planner/src/model/category.dart';
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:budget_planner/src/utils/dialog.dart';
import 'package:budget_planner/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';


class AddCategory extends StatefulWidget {


  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
   String date, color,timestamp;
  final formkey = GlobalKey<FormState>();
  var selectedIconIndex = 0;
  var selectedColorIndex = 0;
  Color selectedColor = Color.fromRGBO(8, 185, 198, 1);
  String selectedIcon = "icons/ic_food.png";
   String title;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Category category = new Category();
  final _prefs = new UserPrefs();

  Future getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd MMMM yy').format(now);
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      category.date = _date;
      timestamp = _timestamp;
      category.timestamp = _timestamp;
      category.icon = selectedIcon;
      category.color = selectedColor.value.toString();
    });
  }
  
  @override
  Widget build(BuildContext context) {

    final  editCategory  = ModalRoute.of(context).settings.arguments;
     if(editCategory != null){
       category = editCategory as Category;
       selectedColor = Color(int.parse(category.color));
       selectedIcon = category.icon;
       for (var i = 0; i < colorsList.length; i++) {
          if (colorsList[i].value == int.parse(category.color)) {
            selectedColorIndex = i;
            break;
          }
        }
        selectedIconIndex = iconsList.indexOf(selectedIcon);
     }
    title = category.timestamp == null ? 'new_category'.tr() : 'edit_category'.tr();

    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      
        title: Text(title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontFamily: "montserrat-Regular", fontSize: 22.0, letterSpacing: 0.338,) ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.save, color: Theme.of(context).accentColor,),
            onPressed: handleSubmit,
        )],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Form(
                key: formkey,
                child: Column(
                  children: [
                    _categoryWidget(),
                    colorsListWidget(),
                    Container(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      initialValue: category.categoryName == null ? '' : category.categoryName,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLength: 18,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'category_name'.tr(),
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          Icons.edit,
                          color: category.color == null ? selectedColor : Color( int.parse(category.color))
                        ),
                        
                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                        border: InputBorder.none,
                        ),
                        validator: (value){
                          if(value.isEmpty) return 'add_category_name'.tr(); return null;
                        },
                        onChanged: (String value ) => setState(() {
                           
                           category.categoryName = value;
                        }),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  SizedBox(
                    height: 420,
                    child:  iconsListWidget(),
                  ),

                  ],
                )
              )
            ])
          )
        ],
      ),
       
    );
  }

  Widget _categoryWidget(){
    return Container(
      padding: EdgeInsets.only(right: 30, left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.only(top: 7, bottom: 7),
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: category.color == null ? selectedColor : Color( int.parse(category.color))
              ),
              height: 90,
              width: 80,
              child: Container(
                margin: EdgeInsets.all(15),
                child: Image(
                  image: category.icon == null ? AssetImage(selectedIcon) : AssetImage(category.icon),
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    category.categoryName == null ? 'category_name'.tr() : category.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color:
                          Colors.white,
                      fontSize: 22,
                     
                    ),
                  ),
                ),
              ),
          ],
        ),
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
                category.color = color;
                
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

  Widget iconsListWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(iconsList.length, (index) {
          return GestureDetector(
            onTap: () {
              selectedIcon = iconsList[index];
              selectedIconIndex = index;
              category.icon = iconsList[selectedIconIndex];
              setState(() {});
            },
            child: iconWidget(index, iconsList[index]),
          );
        }),
      ),
    );
  }

  Widget iconWidget(int index, String assetImage) {
    if (index == selectedIconIndex) {
      return Container(
        margin: EdgeInsets.all(20),
        height: 40,
        width: 40,
        child: Image(
          image: AssetImage(assetImage),
          color: selectedColor,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(20),
        height: 40,
        width: 40,
        child: Image(
          image: AssetImage(assetImage),
          color: Colors.grey,
        ),
      );
    }
  }

  void handleSubmit() async {
  
  if(formkey.currentState.validate()){
    formkey.currentState.validate();
    if(category.timestamp == null){
        await getDate().then((value) => uploadCategory().then((_) {
          openDialog(context, '','successfully'.tr(), );
          
        }));
          
     }else{
       await upDateCategory().then((_) {
          openDialog(context, '','updated'.tr());
          
          
        });
     }

  }
     
    
  }

  Future uploadCategory() async {
    
    var user = _prefs.userId;
    await Firestore.instance.collection('users').document(user).collection('categories').document(timestamp).setData({
       
        'timestamp'     : category.timestamp,
        'category name' : category.categoryName,
        'color'         : category.color,
        'icon'          : category.icon,
        'date'          : category.date
        
      
    });
    Navigator.of(context).pop();
  }

  Future upDateCategory() async {
    var user = _prefs.userId;
    await Firestore.instance.collection('users').document(user).collection('categories').document(category.timestamp).updateData({
       
        'timestamp'     : category.timestamp,
        'category name' : category.categoryName,
        'color'         : category.color,
        'icon'          : category.icon,
        'date'          : category.date
    });
    Navigator.of(context).pop();
  }

}