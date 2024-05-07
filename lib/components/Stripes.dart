import 'package:flutter/material.dart';

class Stripes extends StatelessWidget {
  final Color color;
  final double? width;
  const Stripes({super.key, required this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            width: width ?? 1,
            height: 300,
            color: color,
          ),
        ),
        const SizedBox(height: 20),
        Flexible(
          flex: 1,
          child:Container(
            width: width ?? 1,
            height: 300,
            color: color,
          ),
        ),
        const SizedBox(height: 20),
        Flexible(
          flex: 1,
          child:Container(
            width: width ?? 1,
            height: 300,
            color: color,
          ),
        ),
        const SizedBox(height: 20),
        Flexible(
          flex: 1,
          child: Container(
            width: width ?? 1,
            height: 300,
            color: color,
          ),
        ),
        const SizedBox(height: 20),
        Flexible(
          flex: 1,
          child: Container(
            width: width ?? 1,
            height: 300,
            color: color,
          ),
        ),
        const SizedBox(height: 20),
        Flexible(
          flex: 1,
          child:Container(
            width: width ?? 1,
            height: 300,
            color: color,
          ),
        ),
      ],
    );
  }
}
