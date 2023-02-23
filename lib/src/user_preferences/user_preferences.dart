
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {

  static final UserPrefs _instance = new UserPrefs._internal();

  factory UserPrefs() {
    return _instance;
  }
   UserPrefs._internal();

  SharedPreferences _prefs;

  initPrefs() async {
   _prefs = await SharedPreferences.getInstance();
  }

 //get y set name 
 String get userName {
    return _prefs.getString('userName') ?? 'MAR';
  }

 set userName( String value ) {
    _prefs.setString('userName', value);
  }

   //get y set photo 
 String get userUrlPhoto {
    return _prefs.getString('userUrlPhoto') ?? '';
  }

 set userUrlPhoto( String value ) {
    _prefs.setString('userUrlPhoto', value);
  }

   //get y set photo 
 String get userId {
    return _prefs.getString('userId') ?? '';
  }

 set userId( String value ) {
    _prefs.setString('userId', value);
  }

  //get y set name 
 String get userEmail {
    return _prefs.getString('userEmail') ?? '';
  }

 set userEmail( String value ) {
    _prefs.setString('userEmail', value);
  }


  //get y set name 
 String get token {
    return _prefs.getString('token') ?? 'token';
  }

 set token( String value ) {
    _prefs.setString('token', value);
  }

  //get y set last page
 String get lastPage {
    return _prefs.getString('lastPage') ?? 'home';
  }

 set lastPage( String value ) {
    _prefs.setString('lastPage', value);
  }


  //get y set last page
 String get currentBudget {
    return _prefs.getString('currentBudget') ?? '';
  }

 set currentBudget( String value ) {
    _prefs.setString('currentBudget', value);
  }

  //get y set last page
 bool get loginState{
    return _prefs.getBool('loginState') ?? false;
  }

 set loginState( bool value ) {
    _prefs.setBool('loginState', value);
  }

 
   //get y set last page
 bool get userPremium{
    return _prefs.getBool('userPremium') ?? false;
  }

 set userPremium( bool value ) {
    _prefs.setBool('userPremium', value);
  }

    //get y set last page
 bool get useFingerPrint{
    return _prefs.getBool('useFingerPrint') ?? true;
  }

 set useFingerPrint( bool value ) {
    _prefs.setBool('useFingerPrint', value);
  }

  
  //set laguange
 String get language  {
    return _prefs.getString('language') ?? 'en';
  }

 set language( String value ) {
    _prefs.setString('language', value);
  }

  
}