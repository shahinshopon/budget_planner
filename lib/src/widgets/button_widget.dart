import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.callback,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function callback;
  final Color color;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only( top: 20, left: 20, right: 20),
      child: ElevatedButton(
      //  padding: EdgeInsets.all(15.0),
       // elevation: 12.0,
        onPressed: callback,
        // shape:RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20.0),
        //   ) ,
       // color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: 10,),
            Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}