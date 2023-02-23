
import 'package:budget_planner/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum Language { english, spanish,  }

class LanguageSettingsPage extends StatefulWidget {
  @override
  _LanguageSettingsPageState createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
   var _language;
   final _prefs = new UserPrefs();

   @override
  void initState() {
    super.initState();
    switch (_prefs.language) {
      case 'en':
        _language = Language.english;
        break;

      case 'es':
        _language = Language.spanish;
        break;

      default:
        break;
    }
  }

  _changeLanguage(int index) {
    switch (index) {
      case 0:
        _language = Language.english;
        _prefs.language = 'en';
        break;

      case 1:
        _language = Language.spanish;
        _prefs.language = 'es';
        break;

    }
    EasyLocalization.of(context).locale = EasyLocalization.of(context).supportedLocales[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text('lang_settin'.tr(),
      style: TextStyle(
            color:  Colors.white,
            fontSize: 20,
            letterSpacing: 0.338,
            fontFamily: "montserrat-Regular",
            fontWeight: FontWeight.w700,
          ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             RadioListTile(
              value: Language.english,
              onChanged: (value) => _changeLanguage(0),
              groupValue: _language,
              title: Text('english'.tr()),
            ),
            Divider(
              height: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            RadioListTile(
              value: Language.spanish,
              onChanged: (value) => _changeLanguage(1),
              groupValue: _language,
              title: Text('spanish'.tr()),
            ),
          ],
        ),
      ),
      
      
    );
  }
}