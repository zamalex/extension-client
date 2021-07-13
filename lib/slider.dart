import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:salon/screens/home/widgets/wavy_header_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:salon/model/banners_model.dart'as bann;

class CarosilSlider extends StatefulWidget {
   double shrinkOffsetPercentage;
   List<bann.Banner> banners=[];

   CarosilSlider(this.shrinkOffsetPercentage,this.banners);

   // CarosilSlider(this.banners);
   @override
  _CarosilSliderState createState() => _CarosilSliderState();
}

class _CarosilSliderState extends State<CarosilSlider> {
  int _current = 0;

  List<Widget> getChild() {
    return widget.banners.map((e) => WavyHeaderImage(shrinkOffsetPercentage: widget.shrinkOffsetPercentage)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return
      CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 1,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
        items: getChild(),
      );

      /*Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.sliderImages.map((image) {
            int index = widget.sliderImages.indexOf(image);
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(219, 226, 237, 1)),
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Colors.white
                      : Color.fromRGBO(219, 226, 237, 1)),
            );
          }).toList(),
        ),
      ),*/

  }
}

