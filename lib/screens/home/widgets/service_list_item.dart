import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/category_model.dart';
import 'package:salon/model/products_data.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';

class ServiceListItem extends StatelessWidget {
  const ServiceListItem({
    Key key,
    this.category,
  }) : super(key: key);

  final Product category;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBoxDecorationRadius),
      ),
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(kBoxDecorationRadius)),
        ),
          child: Column(
            children: <Widget>[
              Container(
                height: 90.0,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(kBoxDecorationRadius),
                    topRight: Radius.circular(kBoxDecorationRadius),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/onboarding/welcome.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kPaddingS, left: kPaddingS, right: kPaddingS),
                child: StrutText(
                  category.name,
                  maxLines: 1,
                  style: TextStyle(color: Colors.black,fontSize: 18),
                ),
              ),
            ],
          ),

      ),
    );
  }
}