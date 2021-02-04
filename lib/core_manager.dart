import 'package:flutter/material.dart';

class CoreManager extends StatefulWidget {
  final Widget child;

  CoreManager({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  _CoreManagerState createState() => _CoreManagerState();
}

class _CoreManagerState extends State<CoreManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
