import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/generated/l10n.dart';

class ExpandDate extends StatefulWidget {

  ExpandDate(this.setDate,this.dateTime);
  Function setDate;
  DateTime dateTime;
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
              onTap: (){
                DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime.now().add(const Duration(days: 7)), onChanged: (date) {

                  }, onConfirm: (date) {
                    widget.setDate(date);
                  }, currentTime: DateTime.now(), locale: LocaleType.en);},
              leading: Icon(Icons.alarm,color: kPrimaryColor,),
              title: Text(L10n.of(context).deliverydatetime,style: TextStyle(color: kPrimaryColor)),
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
                  child:widget.dateTime==null?Container(): Padding(padding: EdgeInsets.only(right: 20,left: 20,bottom: 10),child: Column(children: [
                    Row(mainAxisAlignment:MainAxisAlignment.start,children: [Text(DateFormat('EEEE, d MMM, yyyy').format(widget.dateTime),style: TextStyle(color: kPrimaryColor),),],)
                    ,Row(mainAxisAlignment:MainAxisAlignment.start,children: [Text('${widget.dateTime.hour}:${widget.dateTime.minute}',style: TextStyle(color:kPrimaryColor),),],)
                  ],),)
              ),
            )
          ],
        ));
  }
}
