
import 'package:flutter/material.dart';

class TheSnackBar {
  static SnackBar of({required String body, required int status}){
    return SnackBar(
      content: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: status == 200 ? Colors.green : Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset.zero,
                    color: status == 200 ? Colors.green : Colors.red,
                    spreadRadius: 1,
                    blurRadius: 2
                  )
                ]
              )),
          const SizedBox(width: 8),
          Text(body, overflow: TextOverflow.ellipsis),
        ],
      )
    );
  }
}
