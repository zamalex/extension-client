import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/model/cart_provider.dart';
import 'package:extension/model/products_data.dart';
import 'package:extension/screens/products/product_item.dart';

class ProductsList extends StatelessWidget {

  int salon;

  ProductsList(this.salon);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data as List<Product>;
            data.forEach((element) {
              element.salon_id = salon;
            });
            print(data.length.toString());
            return Center(
              child: Container(padding:EdgeInsets.symmetric(horizontal: 10),height: MediaQuery.of(context).size.height,child: GridView.builder(
                  physics: ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProdcutItem(data[index]);
                  }
              ) ,color: kScaffold,),
            );
          }
        }

        // Displaying LoadingSpinner to indicate waiting state
        return Center(
          child: CircularProgressIndicator(),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: ProductModel().getProducts(salon),
    );
  }
}




