import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/category_model.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    Key key,
    this.category,
    this.onTap,
  }) : super(key: key);

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var image = category.image.isEmpty?AssetImage('assets/images/onboarding/welcome.jpg'):NetworkImage(category.image);

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
        child: InkWell(
          onTap: onTap ?? () {},
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
                    image: image as ImageProvider,//AssetImage(category.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: kPaddingS, left: kPaddingS, right: kPaddingS),
                child: StrutText(
                  category.title,
                  maxLines: 1,
                  style: TextStyle(color: Colors.black,fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
