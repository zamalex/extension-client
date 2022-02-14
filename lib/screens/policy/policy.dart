
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/policy_model.dart';
import 'package:salon/screens/cart/cart_item.dart';
import 'package:salon/screens/checkout/checkout.dart';
import 'package:salon/widgets/app_button.dart';
import 'package:salon/widgets/strut_text.dart';


class PolicyScreen extends StatefulWidget {

  String type,title;

PolicyScreen(this.type,this.title);

  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {

  String content='';




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PolicyModel().getPolicy(widget.type).then((value) {
      setState(() {
        content = value==null?'':value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(title: Text(widget.title),centerTitle: true,),
      body: SingleChildScrollView(child: Text(content),),
    );
  }
}

