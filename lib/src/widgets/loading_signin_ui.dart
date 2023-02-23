
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget loadingUI(String brandName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 180,
            width: 180,
            
            child: SpinKitFadingCircle(
              size: 150,
              color: Color.fromRGBO(0, 149, 100, 2.0),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'starting'.tr() + ' $brandName....',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[500]),
          )
        ],
      ),
    );
  }
