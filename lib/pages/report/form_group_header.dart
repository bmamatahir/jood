import 'package:flutter/material.dart';

class FormGroupHeader extends StatelessWidget {
  final String text;

  const FormGroupHeader(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        Divider(),
        SizedBox(height: 8),
      ],
    );
  }
}
