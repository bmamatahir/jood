import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReportButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      isExtended: true,
      tooltip: 'Report',
      icon: Icon(Icons.ios_share),
      label: Text('Signal'),
    );
  }
}
