import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:extension/screens/home/widgets/wavy_header_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:extension/model/banners_model.dart'as bann;

class CarosilSlider extends StatefulWidget {
   double shrinkOffsetPercentage;
   List<bann.Banner> banners=[];

   ///Home page slider widget
   CarosilSlider(this.shrinkOffsetPercentage,this.banners);

   // CarosilSlider(this.banners);
   @override
  _CarosilSliderState createState() => _CarosilSliderState();
}

class _CarosilSliderState extends State<CarosilSlider> {
  int _current = 0;

  List<Widget> getChild() {
    return widget.banners.map((e) => WavyHeaderImage(imageUrl: e.photo,shrinkOffsetPercentage: widget.shrinkOffsetPercentage)).toList();
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

  }
}

