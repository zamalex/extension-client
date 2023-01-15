import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/category_model.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:extension/model/products_data.dart';


class PackageListItem extends StatelessWidget {
  const PackageListItem({
    Key key,
    this.product,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var image = product.thumbnailImage.isEmpty?AssetImage('assets/images/onboarding/welcome.jpg'):NetworkImage(product.thumbnailImage);

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
              Banner(
                message: product.has_discount?'${product.base_discounted_price.toStringAsFixed(2)} sar':'${product.basePrice} sar',
                location: BannerLocation.topStart,
                child: Container(
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: kPaddingS, left: kPaddingS, right: kPaddingS),
                child: StrutText(
                  product.name,
                  maxLines: 1,
                  style: TextStyle(color: Colors.black,fontSize: 18),
                ),
              ),
              StrutText(
                product.shop_name??'',
                maxLines: 1,
                style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black,fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
             /* StrutText(
                '${product.basePrice} SAR',
                maxLines: 1,
                style: Theme.of(context).textTheme.subtitle1.copyWith(color: kPrimaryColor,fontSize: 14),
                overflow: TextOverflow.ellipsis,
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
