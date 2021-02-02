import 'package:flutter/material.dart';

class BorderAroundAvatar extends StatelessWidget {
  final Widget child;

  const BorderAroundAvatar({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
