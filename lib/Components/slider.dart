import 'package:flutter/material.dart';
import 'package:morched/constants/constants.dart';
import 'package:slide_to_act/slide_to_act.dart';

class MySlider extends StatefulWidget {
  const MySlider({super.key, required this.onSubmit});
  final VoidCallback onSubmit;

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final GlobalKey<SlideActionState> key = GlobalKey();
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
          child: SlideAction(
            animationDuration: const Duration(milliseconds: 400),
            sliderButtonIconPadding: 8.0,
            textStyle: const TextStyle(
                fontWeight: FontWeight.w400, color: primaryColor, fontSize: 20),
            height: 50,
            innerColor: primaryColor,
            outerColor: Colors.white,
            sliderButtonIcon: const Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            sliderRotate: false,
            text: '     Trouver le Service',
            key: key,
            onSubmit: () {
              widget.onSubmit();
              return null; // Invoke the onSubmit callback
            },
          ),
        );
      },
    );
  }
}
