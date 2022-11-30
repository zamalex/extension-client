
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/model/cart_provider.dart';
import 'package:extension/model/policy_model.dart';
import 'package:extension/screens/cart/cart_item.dart';
import 'package:extension/screens/checkout/checkout.dart';
import 'package:extension/widgets/app_button.dart';
import 'package:extension/widgets/strut_text.dart';


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

