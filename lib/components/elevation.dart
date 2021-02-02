import 'package:flutter/material.dart';

class Elevation extends StatelessWidget {
  final Widget child;

  const Elevation({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
