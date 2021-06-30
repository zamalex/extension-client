import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
class ExpandCopon extends StatefulWidget {

  @override
  _ExpandCoponState createState() => _ExpandCoponState();
}

class _ExpandCoponState extends State<ExpandCopon> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: kWhite,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.shopping_bag,color: kPrimaryColor,),
              title: Text('Coupon Code',style: TextStyle(color: kPrimaryColor)),
              trailing: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Code10%',style: TextStyle(color: kPrimaryColor),),
                    IconButton(
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
                    )
                  ],
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
                height: 50,

              ),
            )
          ],
        ));
  }
}
