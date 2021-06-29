import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';

class OrderDetails extends StatelessWidget {
final mGrey = const Color.fromRGBO(118 ,123 ,128, 1);
final dGrey = const Color.fromRGBO(184 ,189 ,194, 1);
final mYellow = const Color.fromRGBO(255 ,200 ,89, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromRGBO(118 ,123 ,128, 1),iconTheme: const IconThemeData(color: Colors.white),title: Text('Order Details'),centerTitle: true,),
      body: Container(height: MediaQuery.of(context).size.height,padding:EdgeInsets.all(10),color: const Color.fromRGBO( 248 ,248 ,248, 1),child:
        SingleChildScrollView(
          child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
            ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 0),leading: CircleAvatar(backgroundColor: Colors.grey,radius: 30,
            ),
              title: Text('Ahlam Abullah',style: TextStyle(color: Colors.black),),
              subtitle: Text('Riyadh, Saudi Arabia',style: TextStyle(color: mGrey),),
            ),
            SizedBox(height: 10,),
            _iconText(Icon(Icons.location_pin,color: mGrey,size: 30,), 'Address'),
            SizedBox(height: 5,),
            Text('Fake address, Riyadh, Saudi Arabia',style:TextStyle(color: Colors.black) ,),
            SizedBox(height: 5,),

            SizedBox(height: 10,),
            _iconText(Icon(Icons.location_pin,color: mGrey,size: 30,), 'Email address'),
            SizedBox(height: 5,),
            Text('Ahlam_Ab22@gmail.com',style:TextStyle(color: Colors.black) ,),
            SizedBox(height: 5,),

            SizedBox(height: 10,),
            _iconText(Icon(Icons.location_pin,color: mGrey,size: 30,), 'Phone number'),
            SizedBox(height: 5,),
            Text('+966 55 391 0099',style:TextStyle(color: Colors.black) ,),
            SizedBox(height: 10,),
            Divider(color: Colors.grey,),
            SizedBox(height: 10,),
            _iconText(Icon(Icons.location_pin,color: mGrey,size: 30,), 'Shipment no. 2135459664'),
            SizedBox(height: 10,),
            _iconText(Icon(Icons.location_pin,color: mGrey,size: 30,), 'Invoice summary'),
            SizedBox(height: 10,),
            Row(children: [
              Expanded(child: Divider(thickness: 2,color: mYellow,)),
              SizedBox(width: 5,),
              Expanded(child: Divider(thickness: 2,color: mYellow,)),
              SizedBox(width: 5,),
              Expanded(child: Divider(thickness: 2,color: mYellow,)),
              SizedBox(width: 5,),
              Expanded(child: Divider(thickness: 2,color: dGrey,)),

            ],),
            Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
              Text('Prepared',style: TextStyle(color: mYellow),),
              RichText(text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: ' Ordered by', style: TextStyle(color: mYellow)),
                  TextSpan(
                      text: ' Wed, Nov 17',
                      style: TextStyle(color: Colors.black)),

                ],
              ))
            ],),
            SizedBox(height: 20,),
            Text('Payment Method',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)
            ,SizedBox(height: 10,),
            _iconTextLight(Icon(Icons.location_pin,color: mGrey,size: 30,), 'Pay in cash'),
            SizedBox(height: 10,),
            Divider(color: Colors.grey,),
            SizedBox(height: 10,),
            Text('Order summary',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)
            ,SizedBox(height: 10,),
            Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
              Text('Total price',style: TextStyle(color: Colors.black),),
              Text('15.00 SAR',style: TextStyle(color: Colors.black),),

            ],),
            SizedBox(height: 10,),
            Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
              Text('Delivery fees',style: TextStyle(color: Colors.black),),
              Text('00.00 SAR',style: TextStyle(color: Colors.black),),


            ],),
            SizedBox(height: 10,),
            Divider(color: Colors.grey,),
            SizedBox(height: 10,),
            Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
              Text('Total',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              Text('15.00 SAR',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),


            ],),
            SizedBox(height: 20,),
            Row(children: [
              Expanded(child: SizedBox(height: 48,child: ElevatedButton(child: Text('Print Invoice',style: TextStyle(color: mGrey),)
                ,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: mGrey)
                    )
                )),),)),
              SizedBox(width: 10,),
              Expanded(child: SizedBox(height: 48,child: ElevatedButton(child: Text('Change Status',style: TextStyle(color: Colors.white),)
                ,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(mGrey)) ,),)),

            ],)

          ],),
        )),
    );
  }

  Widget _iconText(Widget icon,String text){
    return Row(children: [
      icon,
      Text(text,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)
    ],);
  }

Widget _iconTextLight(Widget icon,String text){
  return Row(children: [
    icon,
    Text(text,style: TextStyle(color: Colors.black,fontSize: 17),)
  ],);
}
}
