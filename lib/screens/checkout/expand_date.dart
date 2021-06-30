import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
class ExpandDate extends StatefulWidget {

  @override
  _ExpandDateState createState() => _ExpandDateState();
}

class _ExpandDateState extends State<ExpandDate> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.alarm,color: kPrimaryColor,),
              title: Text('Delivery date & time',style: TextStyle(color: kPrimaryColor)),
              trailing: Container(
                child:   IconButton(
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  icon: expanded
                      ? Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  )
                      : Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (expanded) Divider(),
            AnimatedCrossFade(
              duration: Duration(milliseconds: 250),
              crossFadeState: expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              secondChild: Container(),
              firstChild: Container(
                // height: 150,
                  child: Padding(padding: EdgeInsets.only(right: 20,left: 20,bottom: 10),child: Column(children: [
                    Row(mainAxisAlignment:MainAxisAlignment.start,children: [Text('Wed, Nov 17, 2020',style: TextStyle(color: kPrimaryColor),),],)
                    ,Row(mainAxisAlignment:MainAxisAlignment.start,children: [Text('12:30 - 14:30',style: TextStyle(color:kPrimaryColor),),],)
                  ],),)
              ),
            )
          ],
        ));
  }
}
