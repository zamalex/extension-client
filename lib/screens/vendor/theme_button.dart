import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    Key key,
    this.onPressed,
    this.text,
    this.showLoading = false,
    this.disableTouchWhenLoading = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final bool showLoading;
  final bool disableTouchWhenLoading;

  Widget _buildLoading() {
    if (!showLoading) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 14,
      height: 14,
      child: const CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 48,child: ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
      onPressed: disableTouchWhenLoading && showLoading ? null : onPressed,
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text.toUpperCase(),
            style: TextStyle(color: Colors.white,),
          ),
          _buildLoading()
        ],
      ),
    ),);
  }
}