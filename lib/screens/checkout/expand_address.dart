import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
class ExpandAddress extends StatefulWidget {

  @override
  _ExpandAddressState createState() => _ExpandAddressState();
}

class _ExpandAddressState extends State<ExpandAddress> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: kWhite,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.location_pin,color: kPrimaryColor,),
              title: Text('Address',style: TextStyle(color: kPrimaryColor)),
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
                  Row(mainAxisAlignment:MainAxisAlignment.start,children: [Text('Askan Building 17, Al Olaya, Riyadh',style: TextStyle(color: kPrimaryColor),),],)
                  ,Row(mainAxisAlignment:MainAxisAlignment.end,children: [Text('change address',style: TextStyle(color: Colors.black,decoration: TextDecoration.underline,),),],)
                ],),)
              ),
            )
          ],
        ));
  }
}
