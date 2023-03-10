import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/model/loginmodel.dart';
import 'package:extension/screens/change_password.dart';
import 'package:extension/screens/vendor/theme_button.dart';
import 'package:extension/widgets/bold_title.dart';

import '../main.dart';


class VerifyCode extends StatefulWidget {

  int user_id;
  bool register;
  String phone;
  VerifyCode({this.user_id,this.register=false,this.phone});
  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  FocusNode firstNode = FocusNode();
  FocusNode secNode = FocusNode();
  FocusNode thirdtNode = FocusNode();
  FocusNode forthNode = FocusNode();

  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();
  var controller4 = TextEditingController();
  bool loading = false;
  verify(){

    if(controller1.text.isEmpty||controller2.text.isEmpty||controller3.text.isEmpty||controller4.text.isEmpty)
      return;
    setState(() {
      loading = true;
    });
    if(widget.register){
      LoginModel().verifyRegister(widget.user_id.toString(), controller1.text+controller2.text+controller3.text+controller4.text).then((value){
        if(widget.register&&value['status']!=null&&value['status']as bool){
          (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
              .onTap(3);
          Navigator.of(context).popUntil((route) => route.isFirst);
          // Navigator.of(context, rootNavigator: true).pop();
        }else  if(!widget.register&&value['status']!=null&&value['status']as bool){

          Navigator.of(context).push(MaterialPageRoute(builder: (c){
            return ChangePasswordScreen(controller1.text+controller2.text+controller3.text+controller4.text);
          }));
          // Navigator.of(context, rootNavigator: true).pop();
        }
        else

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['message'].toString())));


        // Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          loading=false;
        });
      });
    }else{
      LoginModel().verifyPassword(widget.phone, controller1.text+controller2.text+controller3.text+controller4.text).then((value){
        if(widget.register&&value['status']!=null&&value['status']as bool){
          (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
              .onTap(3);
          Navigator.of(context).popUntil((route) => route.isFirst);
          // Navigator.of(context, rootNavigator: true).pop();
        }else  if(!widget.register&&value['status']!=null&&value['status']as bool){

          Navigator.of(context).push(MaterialPageRoute(builder: (c){
            return ChangePasswordScreen(controller1.text+controller2.text+controller3.text+controller4.text);
          }));
          // Navigator.of(context, rootNavigator: true).pop();
        }
        else

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['message'].toString())));


        // Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          loading=false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),

            BoldTitle(
              title: getIt.get<AppGlobals>().isRTL?'?????? ????????????':'Verification Code',
              padding: const EdgeInsets.only(bottom: kPaddingM),
            ),
            Row(children: [Text(getIt.get<AppGlobals>().isRTL?'???????? ?????? ????????????':'Enter the verification code here.',style: TextStyle(color: Colors.black,fontSize: 15,),),],),
            SizedBox(height: 30,),
            Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
              CodeEntry(focusNode: firstNode,nextNode: secNode,controller: controller1,),
              CodeEntry(focusNode: secNode,nextNode: thirdtNode,controller: controller2,),
              CodeEntry(focusNode: thirdtNode,nextNode: forthNode,controller: controller3,),
              CodeEntry(next: false,focusNode: forthNode,nextNode: forthNode,controller: controller4,),
            ],),
            SizedBox(height: 30,),
            ThemeButton(
              onPressed: (){verify();},
              text: getIt.get<AppGlobals>().isRTL?'????':'Done',
              showLoading: loading,
              disableTouchWhenLoading: true,
            ),
           // TextButton(onPressed: (){}, child: Text('Back to login',style: TextStyle(color: kPrimaryColor),),)
          ],),
      ),
    );
  }
}


class CodeEntry extends StatelessWidget {
  TextEditingController controller;
  bool next;
  FocusNode focusNode;
  FocusNode nextNode;
  CodeEntry({this.next=true,this.focusNode,this.nextNode,this.controller});
  @override
  Widget build(BuildContext context) {
    return  SizedBox(width: 60,height: 60,child: CupertinoTextField(
      focusNode: focusNode,
      autocorrect: false,
      textAlignVertical: TextAlignVertical.center,
      // onSubmitted: widget.onSubmitted,
      //controller: widget.controller,
      //focusNode: widget.focusNode,
    textAlign: TextAlign.center,
      obscureText: false,
      keyboardType: TextInputType.number,
      textInputAction: next?TextInputAction.next: TextInputAction.done,
      maxLines: 1,
      maxLength: 1,
      controller: controller,
      onChanged: (v){
        FocusScope.of(context).requestFocus(nextNode);
      },
      //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      //cursorColor: grey,
      style: TextStyle(color: kPrimaryColor),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kFormFieldsRadius),
        border: Border.all(
          width: 1,
          color: kPrimaryColor,
        ),
      ),
    ),);
  }
}

