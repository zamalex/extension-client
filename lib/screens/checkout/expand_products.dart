import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/model/cart_provider.dart';
import 'package:extension/generated/l10n.dart';

class ExpandProducts extends StatefulWidget {

  @override
  _ExpandProductsState createState() => _ExpandProductsState();
}

class _ExpandProductsState extends State<ExpandProducts> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: kWhite,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              onTap: (){Navigator.pop(context);},
              leading: Icon(Icons.shopping_bag,color: kPrimaryColor,),
              title: Text(L10n.of(context).Productss,style: TextStyle(color: kPrimaryColor)),
              trailing: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(backgroundColor: kPrimaryColor,child: Text(Provider.of<CartProvider>(context,listen: false).items.length.toString(),style: TextStyle(color: Colors.white),),radius: 12,),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                       /* setState(() {
                          expanded = !expanded;
                        });*/
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
                height: 150,
                child: ListView.builder(
                  itemBuilder: (c, i) {
                    return Container();/*ListTile(
                        leading: Icon(Icons.ac_unit_rounded,color: Colors.black,),
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('?????? ????????????',style: TextStyle(color: kPrimaryColor),),
                              Text('12 ????????',style: TextStyle(color: kPrimaryColor)),
                              Text('???????????? 1',style: TextStyle(color: kPrimaryColor))
                            ]),
                        subtitle: Divider());*/
                  },
                  itemCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            )
          ],
        ));
  }
}
